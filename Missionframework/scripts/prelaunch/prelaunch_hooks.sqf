/*
    File: prelaunch_hooks.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2026-02-21
    Last Update: 2026-02-21
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Server-side pre-launch gate. Runs on the server from init.sqf before any
        configuration or preset loading. Decides between autoload path (saved config
        exists and force-config param is off) or the interactive dialog path.

        Autoload path: Applies the last-launched config immediately and releases the
        gate without showing any dialog.

        Dialog path: Sets KPPL_waitingForAdmin = true, then waits for
        KPPL_prelaunch_done to be set by KPPL_fnc_commitLaunch (triggered by the
        admin's dialog Launch button) or KPPL_prelaunch_cancelled (Cancel button).

    Parameter(s):
        None

    Returns:
        Nothing (sets KPPL_prelaunch_done = true or KPPL_prelaunch_cancelled = true
        when gate releases)
*/

// Initialise gate variables
KPPL_prelaunch_done      = false;  publicVariable "KPPL_prelaunch_done";
KPPL_prelaunch_cancelled = false;  publicVariable "KPPL_prelaunch_cancelled";
KPPL_waitingForAdmin     = false;  publicVariable "KPPL_waitingForAdmin";

// Compile all KPPL functions on the server so remoteExec calls (e.g.
// KPPL_fnc_commitLaunch, KPPL_fnc_applySlotByName) are available here.
[] call compileFinal preprocessFileLineNumbers "scripts\prelaunch\prelaunch_functions.sqf";

// Load faction definitions (needed for server-side slot application)
[] call compileFinal preprocessFileLineNumbers "scripts\prelaunch\prelaunch_factions.sqf";

// Single-player passthrough — skip dialog entirely
if (!isMultiplayer) exitWith {
    diag_log "[KPPL] Single-player mode — skipping pre-launch dialog.";
    KPPL_prelaunch_done = true;
    publicVariable "KPPL_prelaunch_done";
};

// ── Autoload decision ─────────────────────────────────────────────────────────
private _cfgKey       = format ["KPPL_CONFIG_%1", toUpper worldName];
private _savedCfg     = profileNamespace getVariable [_cfgKey, []];
private _forceConfig  = ["KPPL_param_force_config", 0] call BIS_fnc_getParamValue;
private _hasValidSave = ((count _savedCfg) >= 6);

if (_hasValidSave && _forceConfig == 0) then {
    // ── AUTOLOAD PATH ────────────────────────────────────────────────────────
    diag_log "[KPPL] Autoloading saved configuration.";
    [_cfgKey] call KPPL_fnc_applySlotByName;

    // Record this as the last launched config
    private _lastKey = format ["KPPL_LASTLAUNCHED_%1", toUpper worldName];
    profileNamespace setVariable [_lastKey, _cfgKey];
    saveProfileNamespace;

    KPPL_autoloaded = true;
    publicVariable "KPPL_autoloaded";

    KPPL_prelaunch_done = true;
    publicVariable "KPPL_prelaunch_done";

} else {
    // ── DIALOG PATH ──────────────────────────────────────────────────────────
    diag_log "[KPPL] Showing pre-launch configuration dialog.";
    KPPL_waitingForAdmin = true;
    publicVariable "KPPL_waitingForAdmin";

    // The gate simply waits here. The dialog on the admin machine will call
    // KPPL_fnc_commitLaunch (via remoteExec to server) which sets
    // KPPL_prelaunch_done = true, or KPPL_fnc_cancelLaunch which sets
    // KPPL_prelaunch_cancelled = true. Both are checked in init.sqf.
    // This script returns immediately — init.sqf's waitUntil handles the
    // actual blocking.
};
