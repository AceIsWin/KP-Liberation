/*
    File: prelaunch_functions.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2026-02-21
    Last Update: 2026-02-21
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        All KPPL_fnc_* function definitions for the pre-launch configuration system.
        Compiled on both the server (via prelaunch_hooks.sqf) and on admin clients
        (via prelaunch_client.sqf) before the dialog is opened.

    Parameter(s):
        None (defines global functions as variables)

    Returns:
        Nothing
*/

// ─────────────────────────────────────────────────────────────────────────────
// KPPL_fnc_applySlotByName
//   Server-side. Reads a saved config array from profileNamespace using the
//   given key, then publishes all KPPL override variables to every machine.
//
//   Parameter(s):
//       _slotKey - profileNamespace key name [STRING]
//
//   Returns: Nothing
// ─────────────────────────────────────────────────────────────────────────────
KPPL_fnc_applySlotByName = {
    params [["_slotKey", "", [""]]];

    private _cfg = profileNamespace getVariable [_slotKey, []];
    if ((count _cfg) < 6) exitWith {
        diag_log format ["[KPPL] applySlotByName: key '%1' has no valid data.", _slotKey];
    };

    KPPL_preset_blufor      = _cfg select 0;
    KPPL_preset_opfor       = _cfg select 1;
    KPPL_preset_resistance  = _cfg select 2;
    KPPL_preset_civilians   = _cfg select 3;
    KPPL_arsenal            = _cfg select 4;
    KPPL_unitcap_override   = _cfg select 5;    // already a float

    // Optional custom save-key suffix at index 6
    if ((count _cfg) > 6 && { !isNil { _cfg select 6 } } && { (_cfg select 6) isEqualType "" } && { (_cfg select 6) != "" }) then {
        KPPL_save_key_override = format [
            "KP_LIBERATION_%1_%2_SAVEGAME",
            toUpper worldName,
            toUpper (_cfg select 6)
        ];
        publicVariable "KPPL_save_key_override";
    };

    // Broadcast all override variables to all current + future machines
    publicVariable "KPPL_preset_blufor";
    publicVariable "KPPL_preset_opfor";
    publicVariable "KPPL_preset_resistance";
    publicVariable "KPPL_preset_civilians";
    publicVariable "KPPL_arsenal";
    publicVariable "KPPL_unitcap_override";

    diag_log format [
        "[KPPL] Slot '%1' applied: BLUFOR=%2 OPFOR=%3 RES=%4 CIV=%5 ARS=%6 CAP=%7",
        _slotKey,
        KPPL_preset_blufor, KPPL_preset_opfor, KPPL_preset_resistance,
        KPPL_preset_civilians, KPPL_arsenal, KPPL_unitcap_override
    ];
};

// ─────────────────────────────────────────────────────────────────────────────
// KPPL_fnc_registerAdminMachine
//   Server-side. Records the owner ID of the admin's machine so the
//   disconnect-fallback in init.sqf can detect if the admin disconnects.
//
//   Parameter(s):
//       _ownerId - owner ID of the admin's machine [NUMBER]
//
//   Returns: Nothing
// ─────────────────────────────────────────────────────────────────────────────
KPPL_fnc_registerAdminMachine = {
    params [["_ownerId", 0, [0]]];
    KPPL_adminMachineId = _ownerId;
    publicVariable "KPPL_adminMachineId";
    diag_log format ["[KPPL] Admin machine registered. Owner ID: %1", _ownerId];
};

// ─────────────────────────────────────────────────────────────────────────────
// KPPL_fnc_commitLaunch
//   Server-side (called via remoteExec from admin machine).
//   Applies config selections, saves them, then releases the init gate.
//
//   Parameter(s):
//       _blufor      - BLUFOR preset index       [NUMBER, default 0]
//       _opfor       - OPFOR preset index        [NUMBER, default 0]
//       _resistance  - Resistance preset index   [NUMBER, default 0]
//       _civilians   - Civilians preset index    [NUMBER, default 0]
//       _arsenal     - Arsenal preset index      [NUMBER, default 0]
//       _unitcapIdx  - Unit cap lobby param idx  [NUMBER, default 2]
//       _saveKeySuffix - Custom save slot suffix [STRING, default ""]
//
//   Returns: Nothing
// ─────────────────────────────────────────────────────────────────────────────
KPPL_fnc_commitLaunch = {
    params [
        ["_blufor",        0,  [0]],
        ["_opfor",         0,  [0]],
        ["_resistance",    0,  [0]],
        ["_civilians",     0,  [0]],
        ["_arsenal",       0,  [0]],
        ["_unitcapIdx",    2,  [0]],
        ["_saveKeySuffix", "", [""]]
    ];

    // Convert unit-cap lobby integer index to float
    private _unitcapFloat = switch (_unitcapIdx) do {
        case 0: {0.5};
        case 1: {0.75};
        case 3: {1.25};
        case 4: {1.5};
        case 5: {2.0};
        default {1.0};
    };

    // Set and broadcast override variables
    KPPL_preset_blufor     = _blufor;
    KPPL_preset_opfor      = _opfor;
    KPPL_preset_resistance = _resistance;
    KPPL_preset_civilians  = _civilians;
    KPPL_arsenal           = _arsenal;
    KPPL_unitcap_override  = _unitcapFloat;

    publicVariable "KPPL_preset_blufor";
    publicVariable "KPPL_preset_opfor";
    publicVariable "KPPL_preset_resistance";
    publicVariable "KPPL_preset_civilians";
    publicVariable "KPPL_arsenal";
    publicVariable "KPPL_unitcap_override";

    // Optional custom save key
    if (_saveKeySuffix != "") then {
        KPPL_save_key_override = format [
            "KP_LIBERATION_%1_%2_SAVEGAME",
            toUpper worldName,
            toUpper _saveKeySuffix
        ];
        publicVariable "KPPL_save_key_override";
    };

    // Persist config to profileNamespace for future autoload
    private _cfgKey = format ["KPPL_CONFIG_%1", toUpper worldName];
    private _cfgArray = [_blufor, _opfor, _resistance, _civilians, _arsenal, _unitcapFloat];
    if (_saveKeySuffix != "") then { _cfgArray pushBack _saveKeySuffix; };
    profileNamespace setVariable [_cfgKey, _cfgArray];

    // Record as last launched slot
    private _lastKey = format ["KPPL_LASTLAUNCHED_%1", toUpper worldName];
    profileNamespace setVariable [_lastKey, _cfgKey];
    saveProfileNamespace;

    diag_log format [
        "[KPPL] Launch committed: BLUFOR=%1 OPFOR=%2 RES=%3 CIV=%4 ARS=%5 CAP=%6 KEY=%7",
        _blufor, _opfor, _resistance, _civilians, _arsenal, _unitcapFloat, _saveKeySuffix
    ];

    // Release the server-side init gate
    KPPL_prelaunch_done = true;
    publicVariable "KPPL_prelaunch_done";
};

// ─────────────────────────────────────────────────────────────────────────────
// KPPL_fnc_cancelLaunch
//   Server-side (called via remoteExec from admin machine).
//   Sets the cancel flag and triggers end-mission.
//
//   Parameter(s): None
//   Returns: Nothing
// ─────────────────────────────────────────────────────────────────────────────
KPPL_fnc_cancelLaunch = {
    diag_log "[KPPL] Launch cancelled by admin.";
    KPPL_prelaunch_cancelled = true;
    publicVariable "KPPL_prelaunch_cancelled";
};

// ─────────────────────────────────────────────────────────────────────────────
// KPPL_fnc_saveConfig
//   Server-side (called via remoteExec from admin machine).
//   Saves the current dialog selections to profileNamespace without launching.
//
//   Parameter(s):
//       _cfg - Config array [ARRAY]
//
//   Returns: Nothing
// ─────────────────────────────────────────────────────────────────────────────
KPPL_fnc_saveConfig = {
    params [["_cfg", [], [[]]]];
    if ((count _cfg) < 6) exitWith {
        diag_log "[KPPL] saveConfig: invalid config array.";
    };
    private _cfgKey = format ["KPPL_CONFIG_%1", toUpper worldName];
    profileNamespace setVariable [_cfgKey, _cfg];
    saveProfileNamespace;
    diag_log format ["[KPPL] Configuration saved to '%1'.", _cfgKey];
};

// ─────────────────────────────────────────────────────────────────────────────
// KPPL_fnc_clearConfig
//   Server-side (called via remoteExec from admin machine).
//   Removes the saved config from profileNamespace.
//
//   Parameter(s): None
//   Returns: Nothing
// ─────────────────────────────────────────────────────────────────────────────
KPPL_fnc_clearConfig = {
    private _cfgKey = format ["KPPL_CONFIG_%1", toUpper worldName];
    profileNamespace setVariable [_cfgKey, nil];
    private _lastKey = format ["KPPL_LASTLAUNCHED_%1", toUpper worldName];
    profileNamespace setVariable [_lastKey, nil];
    saveProfileNamespace;
    diag_log "[KPPL] Saved configuration cleared.";
};

// ─────────────────────────────────────────────────────────────────────────────
// KPPL_fnc_dialogInit
//   Client-side. Called by the dialog's onLoad event.
//   Populates all combo boxes and restores any previously saved config.
//
//   Parameter(s): None (reads global KPPL_factions_* arrays)
//   Returns: Nothing
// ─────────────────────────────────────────────────────────────────────────────
KPPL_fnc_dialogInit = {
    // Helper: populate a StdCombo from an entry array [name, index, detectClass, modLabel]
    private _fnc_populateCombo = {
        params ["_combo", "_entries"];
        lbClear _combo;
        {
            private _name      = _x select 0;
            private _modLabel  = _x select 3;
            private _detectCls = _x select 2;
            private _available = (_detectCls == "") || { isClass (configfile >> "CfgVehicles" >> _detectCls) || isClass (configfile >> "CfgWeapons" >> _detectCls) || isClass (configfile >> "CfgPatches" >> _detectCls) };
            private _displayName = if (_available) then { _name } else { format ["%1  [%2 not loaded]", _name, _modLabel] };
            private _idx = _combo lbAdd _displayName;
            _combo lbSetValue [_idx, _x select 1];
        } forEach _entries;
    };

    [9105, KPPL_factions_blufor]     call _fnc_populateCombo;
    [9107, KPPL_factions_opfor]      call _fnc_populateCombo;
    [9109, KPPL_factions_resistance] call _fnc_populateCombo;
    [9111, KPPL_factions_civilian]   call _fnc_populateCombo;
    [9113, KPPL_factions_arsenal]    call _fnc_populateCombo;

    // Unit cap combo
    lbClear 9117;
    {
        private _idx = 9117 lbAdd (_x select 0);
        9117 lbSetValue [_idx, _x select 1];
    } forEach [
        ["x0.5  (Light)",    0],
        ["x0.75 (Reduced)",  1],
        ["x1.0  (Normal)",   2],
        ["x1.25 (Heavy)",    3],
        ["x1.5  (Intense)",  4],
        ["x2.0  (Max)",      5]
    ];

    // Restore saved config if available, otherwise use defaults
    private _cfgKey  = format ["KPPL_CONFIG_%1", toUpper worldName];
    private _savedCfg = profileNamespace getVariable [_cfgKey, []];

    private _fnc_selectByValue = {
        params ["_combo", "_val"];
        private _count = lbSize _combo;
        for "_i" from 0 to (_count - 1) do {
            if ((_combo lbValue _i) == _val) exitWith { _combo lbSetCurSel _i; };
        };
        // fallback: select first
        _combo lbSetCurSel 0;
    };

    if ((count _savedCfg) >= 6) then {
        [9105, _savedCfg select 0] call _fnc_selectByValue;
        [9107, _savedCfg select 1] call _fnc_selectByValue;
        [9109, _savedCfg select 2] call _fnc_selectByValue;
        [9111, _savedCfg select 3] call _fnc_selectByValue;
        [9113, _savedCfg select 4] call _fnc_selectByValue;
        // unitcap stored as float in cfg; match to unitcap combo which uses integer indices
        private _savedUnitcapFloat = _savedCfg select 5;
        private _unitcapIdx = switch (true) do {
            case (_savedUnitcapFloat == 0.5):  {0};
            case (_savedUnitcapFloat == 0.75): {1};
            case (_savedUnitcapFloat == 1.25): {3};
            case (_savedUnitcapFloat == 1.5):  {4};
            case (_savedUnitcapFloat == 2.0):  {5};
            default {2};
        };
        [9117, _unitcapIdx] call _fnc_selectByValue;
        // Restore custom save key suffix
        if ((count _savedCfg) > 6 && { (_savedCfg select 6) isEqualType "" }) then {
            (findDisplay 9100 displayCtrl 9124) ctrlSetText (_savedCfg select 6);
        };
    } else {
        // Defaults
        [9105, 0] call _fnc_selectByValue;
        [9107, 0] call _fnc_selectByValue;
        [9109, 0] call _fnc_selectByValue;
        [9111, 0] call _fnc_selectByValue;
        [9113, 0] call _fnc_selectByValue;
        [9117, 2] call _fnc_selectByValue;
    };

    // Update save key hint
    [] call KPPL_fnc_updateSaveKeyHint;

    // Status line: saved config info
    private _statusText = if ((count _savedCfg) >= 6) then {
        "Saved configuration loaded. Review selections and click LAUNCH MISSION."
    } else {
        "No saved configuration. Select factions and click LAUNCH MISSION."
    };
    (findDisplay 9100 displayCtrl 9127) ctrlSetText _statusText;
};

// ─────────────────────────────────────────────────────────────────────────────
// KPPL_fnc_updateSaveKeyHint
//   Client-side. Updates the save key hint label (IDC 9125) based on the
//   current text in the save key edit field (IDC 9124).
//
//   Parameter(s): None
//   Returns: Nothing
// ─────────────────────────────────────────────────────────────────────────────
KPPL_fnc_updateSaveKeyHint = {
    private _suffix = ctrlText (findDisplay 9100 displayCtrl 9124);
    private _fullKey = if (_suffix == "") then {
        format ["KP_LIBERATION_%1_SAVEGAME  (default)", toUpper worldName]
    } else {
        format ["KP_LIBERATION_%1_%2_SAVEGAME", toUpper worldName, toUpper _suffix]
    };
    (findDisplay 9100 displayCtrl 9125) ctrlSetText format ["Save slot: %1", _fullKey];
};

// ─────────────────────────────────────────────────────────────────────────────
// KPPL_fnc_getLaunchParams
//   Client-side. Reads the current combo values from the dialog and returns
//   them as an array suitable for passing to KPPL_fnc_commitLaunch.
//
//   Parameter(s): None
//   Returns: [blufor, opfor, resistance, civilians, arsenal, unitcap_idx, save_key_suffix]
// ─────────────────────────────────────────────────────────────────────────────
KPPL_fnc_getLaunchParams = {
    private _fnc_comboValue = {
        params ["_combo"];
        private _sel = lbCurSel _combo;
        if (_sel < 0) then { 0 } else { _combo lbValue _sel }
    };

    [
        9105 call _fnc_comboValue,   // BLUFOR
        9107 call _fnc_comboValue,   // OPFOR
        9109 call _fnc_comboValue,   // Resistance
        9111 call _fnc_comboValue,   // Civilians
        9113 call _fnc_comboValue,   // Arsenal
        9117 call _fnc_comboValue,   // Unit cap (integer index)
        ctrlText (findDisplay 9100 displayCtrl 9124)  // Save key suffix
    ]
};

// ─────────────────────────────────────────────────────────────────────────────
// KPPL_fnc_onLaunchClicked
//   Client-side. Action for the LAUNCH MISSION button.
//   Reads dialog params, closes dialog, sends commitLaunch to server.
//
//   Parameter(s): None
//   Returns: Nothing
// ─────────────────────────────────────────────────────────────────────────────
KPPL_fnc_onLaunchClicked = {
    private _params = [] call KPPL_fnc_getLaunchParams;
    closeDialog 0;
    _params remoteExec ["KPPL_fnc_commitLaunch", 2];
};

// ─────────────────────────────────────────────────────────────────────────────
// KPPL_fnc_onCancelClicked
//   Client-side. Action for the Cancel / End Mission button.
//   Closes dialog, tells server to cancel and end mission.
//
//   Parameter(s): None
//   Returns: Nothing
// ─────────────────────────────────────────────────────────────────────────────
KPPL_fnc_onCancelClicked = {
    closeDialog 0;
    [] remoteExec ["KPPL_fnc_cancelLaunch", 2];
    // Server cancelLaunch sets KPPL_prelaunch_cancelled; init.sqf then calls
    // BIS_fnc_endMission on all machines.
};

// ─────────────────────────────────────────────────────────────────────────────
// KPPL_fnc_onSaveConfigClicked
//   Client-side. Action for the Save Config button.
//   Reads dialog params and sends to server for storage in profileNamespace.
//
//   Parameter(s): None
//   Returns: Nothing
// ─────────────────────────────────────────────────────────────────────────────
KPPL_fnc_onSaveConfigClicked = {
    private _params  = [] call KPPL_fnc_getLaunchParams;
    // Convert unitcap idx to float before saving
    private _unitcapFloat = switch (_params select 5) do {
        case 0: {0.5};
        case 1: {0.75};
        case 3: {1.25};
        case 4: {1.5};
        case 5: {2.0};
        default {1.0};
    };
    private _cfg = [
        _params select 0,  // blufor
        _params select 1,  // opfor
        _params select 2,  // resistance
        _params select 3,  // civilians
        _params select 4,  // arsenal
        _unitcapFloat
    ];
    if ((_params select 6) != "") then { _cfg pushBack (_params select 6); };
    [_cfg] remoteExec ["KPPL_fnc_saveConfig", 2];
    (findDisplay 9100 displayCtrl 9127) ctrlSetText "Configuration saved. Click LAUNCH MISSION when ready.";
};

// ─────────────────────────────────────────────────────────────────────────────
// KPPL_fnc_onClearConfigClicked
//   Client-side. Action for the Clear Saved Config button.
//   Tells server to delete the saved config from profileNamespace.
//
//   Parameter(s): None
//   Returns: Nothing
// ─────────────────────────────────────────────────────────────────────────────
KPPL_fnc_onClearConfigClicked = {
    [] remoteExec ["KPPL_fnc_clearConfig", 2];
    (findDisplay 9100 displayCtrl 9127) ctrlSetText "Saved configuration cleared. Changes will not persist after restart.";
};
