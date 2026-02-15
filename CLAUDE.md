# CLAUDE.md - KP Liberation

## Project Overview

KP Liberation is a persistent multiplayer cooperative CTI (Capture The Island) campaign mission for **Arma 3**. It is a continuation of the original "GREUH Liberation" mission. Players capture sectors, build FOBs, manage resources (supplies, ammo, fuel), and fight asymmetric warfare across 18 supported maps with up to 34 players.

- **License**: MIT
- **Language**: SQF (Arma 3 scripting language)
- **Build tools**: TypeScript, Gulp 4, Node.js (>=10)
- **CI**: GitHub Actions (builds PBO artifacts on push to `master` and PRs)

## Repository Structure

```
KP-Liberation/
├── Missionframework/              # Core mission logic (all SQF)
│   ├── init.sqf                   # Main entry point
│   ├── description.ext            # Mission metadata, respawn, UI includes
│   ├── kp_liberation_config.sqf   # Master configuration (~48KB)
│   ├── CfgFunctions.hpp           # Function library definitions (85+ functions)
│   ├── stringtable.xml            # Localization (Czech, German, Russian, Spanish, Turkish)
│   ├── kp_objectInits.sqf         # Object initialization handlers
│   ├── KPLIB_debriefs.hpp         # Debrief/ending screens
│   ├── functions/                 # Reusable SQF functions (fn_*.sqf)
│   │   └── curator/              # Zeus curator functions
│   ├── scripts/
│   │   ├── client/               # Client-side scripts
│   │   │   ├── init_client.sqf   # Client init
│   │   │   ├── actions/          # Player interactions (recycle, intel, unflip)
│   │   │   ├── build/            # FOB construction
│   │   │   ├── commander/        # Commander-specific menus
│   │   │   ├── markers/          # Map markers and overlays
│   │   │   ├── spawn/            # Player spawn/deployment
│   │   │   ├── ui/               # HUD and overlay management
│   │   │   ├── ammoboxes/        # Crate/ammo management
│   │   │   ├── civinformant/     # Civilian informant missions
│   │   │   ├── asymmetric/       # Guerrilla notifications
│   │   │   ├── tutorial/         # Tutorial tasks
│   │   │   ├── misc/             # Miscellaneous client scripts
│   │   │   └── remotecall/       # Client remote execution handlers
│   │   ├── server/               # Server-side scripts
│   │   │   ├── init_server.sqf   # Server init
│   │   │   ├── battlegroup/      # Enemy reinforcement waves
│   │   │   ├── sector/           # Territory control management
│   │   │   ├── patrols/          # AI patrol management
│   │   │   ├── resources/        # Economy (supplies, ammo, fuel)
│   │   │   ├── base/             # FOB and starting area
│   │   │   ├── ai/               # AI behavior (defense, waypoints)
│   │   │   ├── asymmetric/       # Guerrilla faction mechanics
│   │   │   ├── secondary/        # Side missions (convoy, rescue, FOB hunting)
│   │   │   ├── game/             # Core mechanics (saves, victory, weather)
│   │   │   ├── offloading/       # Headless client support
│   │   │   ├── civrep/           # Civilian reputation system
│   │   │   ├── civinformant/     # Informant server logic
│   │   │   ├── highcommand/      # High command support
│   │   │   ├── support/          # Support module scripts
│   │   │   └── remotecall/       # Server remote execution handlers
│   │   ├── shared/               # Shared scripts (client + server)
│   │   │   ├── init_shared.sqf
│   │   │   └── fetch_params.sqf  # Mission parameter loading
│   │   └── fob_templates/        # FOB building templates
│   ├── presets/                   # Unit/equipment presets
│   │   ├── init_presets.sqf       # Preset initialization dispatcher
│   │   ├── blufor/               # 30+ NATO/Allied presets (RHS, CUP, BWMod, etc.)
│   │   ├── opfor/                # 20+ enemy faction presets
│   │   ├── resistance/           # Guerrilla presets
│   │   └── civilians/            # Civilian presets
│   ├── arsenal_presets/           # Weapon/gear loadout files
│   ├── ui/                        # UI dialog definitions (.hpp)
│   ├── KP/                        # Custom KP modules
│   │   ├── KPGUI/                # KP GUI framework
│   │   └── KPPLM/                # KP Player Menu (CBA-based)
│   ├── GREUH/                     # Legacy GREUH extended options module
│   └── res/                       # Resources (images, textures)
├── Missionbasefiles/              # Map-specific base files (18 maps)
│   ├── kp_liberation.Altis/
│   ├── kp_liberation.Tanoa/
│   ├── kp_liberation.Malden/
│   └── ...                        # Each contains mission.sqm for that map
├── _tools/                        # Build pipeline (TypeScript/Gulp)
│   ├── gulpfile.ts                # Gulp task definitions
│   ├── package.json               # Node.js dependencies
│   ├── _presets.json              # Build presets for all 18 maps
│   └── src/                       # TypeScript build sources
├── .github/
│   ├── workflows/main.yml         # CI: build + artifact upload
│   ├── ISSUE_TEMPLATE/            # Bug, feature, task, question templates
│   └── pull_request_template.md   # PR template with testing checklist
├── .vscode/settings.json          # VS Code config (SQF linting, headers)
├── .editorconfig                  # LF line endings, 4-space indent, UTF-8
├── build.bat                      # Windows build script
├── CHANGELOG.md                   # Version history
├── README.md                      # Project documentation
└── LICENSE.md                     # MIT License
```

## Initialization Flow

```
init.sqf
  → KPLIB_fnc_initSectors          (initialize sector data)
  → fetch_params.sqf               (read mission parameters)
  → kp_liberation_config.sqf       (load configuration)
  → presets/init_presets.sqf        (initialize unit/equipment presets)
  → KPPLM or GREUH player menu     (based on CBA availability)
  → scripts/shared/init_shared.sqf (shared initialization)
  → scripts/server/init_server.sqf (server-only, if isServer)
  → scripts/client/init_client.sqf (client-only, if hasInterface)
```

## Build System

The build pipeline is in `_tools/`. It assembles map-specific mission folders from the shared `Missionframework/` and per-map `Missionbasefiles/`, then packs them into PBO files.

```bash
cd _tools
npm install
npx gulp          # default: build → pbo → zip
npx gulp build    # assemble mission folders only
npx gulp pbo      # pack into PBO files
npx gulp zip      # create release ZIPs
npx gulp clean    # remove build/ directory
npx gulp workshop # upload to Steam Workshop
```

Build output goes to `_tools/build/`. Configuration for which maps/presets to build is in `_tools/_presets.json`.

## CI/CD

GitHub Actions workflow (`.github/workflows/main.yml`):
- **Triggers**: Push to `master`, all pull requests
- **Steps**: Checkout → npm install → `npx gulp` → upload PBO artifacts
- **Artifacts**: PBO files from `_tools/build/pbo/`

## Coding Conventions

### File Headers

All SQF and HPP/EXT files must include this header:

```sqf
/*
    File: filename.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: YYYY-MM-DD
    Last Update: YYYY-MM-DD
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Description of the file.

    Parameter(s):
        _param - Description [DATATYPE, defaults to VALUE]

    Returns:
        Description [DATATYPE]
*/
```

### Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Local variables | `_camelCase` | `_nearestFob` |
| Global variables | `UPPER_CASE` or `KPLIB_varName` | `KP_liberation_medical_vehicles`, `GRLIB_save_key` |
| Functions (CfgFunctions) | `KPLIB_fnc_functionName` | `KPLIB_fnc_getNearestFob` |
| Function files | `fn_functionName.sqf` | `fn_getNearestFob.sqf` |
| Compiled scripts | `lowercase_with_underscores` | `add_defense_waypoints` |
| Config arrays | `KP_liberation_*` or `GRLIB_*` | `KP_liberation_preset_blufor` |

### Code Style

- **Indentation**: 4 spaces (no tabs)
- **Line endings**: LF (Unix-style)
- **Charset**: UTF-8
- **Trailing whitespace**: trimmed (except in .md files)
- **Final newline**: required
- Functions are compiled with `compileFinal preprocessFileLineNumbers` for optimization
- Remote execution uses `remoteExec` and `remoteExecCall`
- Error logging via `[message, tag] call KPLIB_fnc_log`
- Null checks use `isNull`, `isNil`; early returns use `exitWith`
- Comments: `//` for single-line, `/* */` for block comments

### Function Organization

Functions are registered in `CfgFunctions.hpp` under the `KPLIB` class. They follow the Arma 3 CfgFunctions pattern:
- Main functions: `Missionframework/functions/fn_*.sqf`
- Curator functions: `Missionframework/functions/curator/`
- Client/server functions: registered via their own `CfgFunctions.hpp` includes

### Preset System

Unit presets are selected via integer indices in `kp_liberation_config.sqf`:
- `KP_liberation_preset_blufor` (0-30+): Select from `presets/blufor/`
- `KP_liberation_preset_opfor` (0-20+): Select from `presets/opfor/`
- `KP_liberation_preset_resistance` (0-8): Select from `presets/resistance/`
- `KP_liberation_preset_civilians` (0-3): Select from `presets/civilians/`
- `KP_liberation_arsenal` (0-16): Select from `arsenal_presets/`

Custom presets go in the `custom.sqf` files in each preset folder (index 0).

## Key Architectural Patterns

- **Client-server split**: Scripts are strictly divided into `client/`, `server/`, and `shared/` directories. Server scripts run only on the server; client scripts run only on player machines.
- **Persistent state**: Uses `profileNamespace` for server-side saves with key `GRLIB_save_key`. Auto-saves when last player disconnects.
- **Headless client offloading**: AI processing can be offloaded to headless clients via `scripts/server/offloading/`.
- **Sector FSM**: Territory control uses finite state machine monitoring.
- **Resource economy**: Three resource types (supplies, ammo, fuel) managed through storage crates at FOBs.
- **Mod compatibility**: Optional support for CBA A3, ACE3, ACRE 2, and numerous unit/vehicle mods via the preset system.

## Pull Request Requirements

PRs must include (per `.github/pull_request_template.md`):
1. Classification: Bug fix / New feature / Other
2. Whether save data wipe is needed
3. Description of changes
4. Content checklist
5. Testing confirmation on both **Local MP** and **Dedicated MP**
6. Update `CHANGELOG.md` for new features

## Common Tasks

### Adding a new unit preset

1. Create a new `.sqf` file in the appropriate `presets/` subfolder (blufor, opfor, resistance, or civilians)
2. Follow the structure of an existing preset file (define arrays for units, vehicles, buildings, etc.)
3. Add a new case in `presets/init_presets.sqf` with the next available index
4. Update `kp_liberation_config.sqf` comment block documenting available presets

### Adding a new function

1. Create `fn_functionName.sqf` in `Missionframework/functions/`
2. Add the class entry to `CfgFunctions.hpp` under the appropriate section
3. Include the standard file header
4. Call via `[] call KPLIB_fnc_functionName`

### Adding a new map

1. Create a new folder in `Missionbasefiles/` named `kp_liberation.<mapclass>/`
2. Add a `mission.sqm` for the map (from Arma 3 Eden editor)
3. Add a preset entry in `_tools/_presets.json`

### Localization

All player-facing strings should be added to `Missionframework/stringtable.xml` using the Arma 3 stringtable format. Supported languages: English, Czech, German, Russian, Spanish, Turkish.
