#!/usr/bin/env node
const { execSync } = require('child_process');
const readline = require('readline');
const path = require('path');
const fs = require('fs');

const TOOLS_DIR = path.join(__dirname, '_tools');
const PRESETS_PATH = path.join(TOOLS_DIR, '_presets.json');

// Load presets
if (!fs.existsSync(PRESETS_PATH)) {
    console.error('ERROR: _presets.json not found at', PRESETS_PATH);
    process.exit(1);
}
const presets = JSON.parse(fs.readFileSync(PRESETS_PATH, 'utf8'));

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

function ask(question) {
    return new Promise(resolve => rl.question(question, resolve));
}

function run(cmd) {
    console.log(`\n> ${cmd}\n`);
    try {
        execSync(cmd, { cwd: TOOLS_DIR, stdio: 'inherit' });
    } catch (e) {
        console.error(`Command failed: ${cmd}`);
    }
}

function getDisplayName(preset) {
    const display = preset.mapDisplay || preset.map;
    if (preset.missionName !== 'kp_liberation') {
        const variant = preset.missionName.replace('kp_liberation_', '').toUpperCase();
        return `${display} (${variant})`;
    }
    return display;
}

async function selectMaps() {
    console.log('\n============================================');
    console.log('           Select Maps to Build');
    console.log('============================================\n');
    console.log('  0) All maps');
    presets.forEach((p, i) => {
        console.log(`  ${i + 1}) ${getDisplayName(p)}`);
    });
    console.log();

    const input = await ask('Select maps (comma-separated, e.g. 1,3,5): ');
    const trimmed = input.trim();

    if (trimmed === '0') return presets;

    const indices = trimmed.split(',')
        .map(s => parseInt(s.trim()) - 1)
        .filter(i => i >= 0 && i < presets.length);

    if (indices.length === 0) {
        console.log('No valid maps selected.');
        return null;
    }

    return indices.map(i => presets[i]);
}

async function selectStep() {
    console.log('\n============================================');
    console.log('           Select Build Step');
    console.log('============================================\n');
    console.log('  1) Build only    (assemble mission folders)');
    console.log('  2) PBO only      (pack into PBO files)');
    console.log('  3) ZIP only      (create release ZIPs)');
    console.log('  4) Build + PBO');
    console.log('  5) Full build    (build + PBO + ZIP)');
    console.log('  6) Clean         (remove build directory)');
    console.log('  0) Exit');
    console.log();

    const input = await ask('Select option: ');
    return input.trim();
}

function writeFilteredPresets(selected) {
    // Write a temporary presets file with only selected maps
    const tempPath = path.join(TOOLS_DIR, '_presets_filtered.json');
    fs.writeFileSync(tempPath, JSON.stringify(selected, null, 4));
    return tempPath;
}

function restorePresets(tempPath) {
    if (fs.existsSync(tempPath)) {
        fs.unlinkSync(tempPath);
    }
}

async function main() {
    console.log('============================================');
    console.log('       KP Liberation Build Tool');
    console.log('============================================');

    // Install dependencies
    console.log('\nChecking dependencies...');
    run('npm install --loglevel=error');

    while (true) {
        const step = await selectStep();

        if (step === '0') {
            rl.close();
            process.exit(0);
        }

        if (step === '6') {
            run('npx gulp clean');
            continue;
        }

        const steps = {
            '1': ['build'],
            '2': ['pbo'],
            '3': ['zip'],
            '4': ['build', 'pbo'],
            '5': ['build', 'pbo', 'zip']
        };

        const gulpTasks = steps[step];
        if (!gulpTasks) {
            console.log('Invalid option, try again.');
            continue;
        }

        const selected = await selectMaps();
        if (!selected) continue;

        let tempPath = null;
        const buildAll = selected.length === presets.length;

        if (!buildAll) {
            // Swap presets file temporarily
            tempPath = writeFilteredPresets(selected);
            const originalPath = path.join(TOOLS_DIR, '_presets.json');
            const backupPath = path.join(TOOLS_DIR, '_presets_backup.json');
            fs.copyFileSync(originalPath, backupPath);
            fs.copyFileSync(tempPath, originalPath);
        }

        try {
            for (const task of gulpTasks) {
                run(`npx gulp ${task}`);
            }
        } finally {
            // Restore original presets
            if (!buildAll) {
                const originalPath = path.join(TOOLS_DIR, '_presets.json');
                const backupPath = path.join(TOOLS_DIR, '_presets_backup.json');
                if (fs.existsSync(backupPath)) {
                    fs.copyFileSync(backupPath, originalPath);
                    fs.unlinkSync(backupPath);
                }
                if (tempPath) restorePresets(tempPath);
            }
        }

        console.log('\n============================================');
        console.log('  Build complete.');
        console.log('============================================');
    }
}

main().catch(err => {
    console.error(err);
    rl.close();
    process.exit(1);
});
