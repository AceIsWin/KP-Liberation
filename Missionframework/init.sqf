
KPLIB_init = false;

// Version of the KP Liberation framework
KP_liberation_version = [0, 96, "7a"];

enableSaving [ false, false ];

if (isDedicated) then {debug_source = "Server";} else {debug_source = name player;};

[] call KPLIB_fnc_initSectors;

// === KPPL PRE-LAUNCH GATE (server only, before config loading) ===
if (isServer) then {
    [] call compileFinal preprocessFileLineNumbers "scripts\prelaunch\prelaunch_hooks.sqf";
    waitUntil {
        sleep 1;
        !isNil "KPPL_prelaunch_done" && {
            KPPL_prelaunch_done || KPPL_prelaunch_cancelled ||
            // Admin disconnected mid-dialog — fall back to last save if one exists
            (
                !isNil "KPPL_adminMachineId" &&
                { KPPL_adminMachineId > 0 } &&
                { !(KPPL_adminMachineId in (allPlayers apply { owner _x })) } &&
                { profileNamespace getVariable [format ["KPPL_LASTLAUNCHED_%1", toUpper worldName], ""] != "" }
            )
        }
    };
    // Admin disconnect fallback — apply last launched save
    if (!KPPL_prelaunch_done && !KPPL_prelaunch_cancelled) then {
        diag_log "[KPPL] Admin disconnected during dialog. Falling back to last launched save.";
        private _fallbackSave = profileNamespace getVariable [format ["KPPL_LASTLAUNCHED_%1", toUpper worldName], ""];
        if (_fallbackSave != "") then {
            [_fallbackSave] call KPPL_fnc_applySlotByName;
            KPPL_autoloaded = true; publicVariable "KPPL_autoloaded";
            KPPL_prelaunch_done = true; publicVariable "KPPL_prelaunch_done";
        } else {
            KPPL_prelaunch_cancelled = true; publicVariable "KPPL_prelaunch_cancelled";
        };
    };
    // On cancel: end the mission on all machines
    if (KPPL_prelaunch_cancelled) then {
        diag_log "[KPPL] Prelaunch cancelled. Ending mission.";
        ["end1", true] remoteExec ["BIS_fnc_endMission", 0];
        sleep 10;
    };
};
// === END KPPL PRE-LAUNCH GATE ===

if (!isServer) then {waitUntil {!isNil "KPLIB_initServer"};};
[] call compileFinal preprocessFileLineNumbers "scripts\shared\fetch_params.sqf";

// Apply prelaunch unitcap override (overrides lobby param value set by fetch_params.sqf)
if (!isNil "KPPL_unitcap_override") then { GRLIB_unitcap = KPPL_unitcap_override; };

[] call compileFinal preprocessFileLineNumbers "kp_liberation_config.sqf";

// Apply prelaunch faction preset overrides (kp_liberation_config.sqf resets these to defaults)
if (!isNil "KPPL_preset_blufor") then {
    KP_liberation_preset_blufor     = KPPL_preset_blufor;
    KP_liberation_preset_opfor      = KPPL_preset_opfor;
    KP_liberation_preset_resistance = KPPL_preset_resistance;
    KP_liberation_preset_civilians  = KPPL_preset_civilians;
};
if (!isNil "KPPL_arsenal") then { KP_liberation_arsenal = KPPL_arsenal; };
if (!isNil "KPPL_save_key_override") then { GRLIB_save_key = KPPL_save_key_override; };

[] call compileFinal preprocessFileLineNumbers "presets\init_presets.sqf";
[] call compileFinal preprocessFileLineNumbers "kp_objectInits.sqf";

// Activate selected player menu. If CBA isn't loaded -> fallback to GREUH
if (KPPLM_CBA && KP_liberation_playermenu) then {
    [] call KPPLM_fnc_postInit;
} else {
    [] execVM "GREUH\scripts\GREUH_activate.sqf";
};

[] call compileFinal preprocessFileLineNumbers "scripts\shared\init_shared.sqf";

if (isServer) then {
    [] call compileFinal preprocessFileLineNumbers "scripts\server\init_server.sqf";
};

if (!isDedicated && !hasInterface && isMultiplayer) then {
    execVM "scripts\server\offloading\hc_manager.sqf";
};

if (!isDedicated && hasInterface) then {
    // Get mission version and readable world name for Discord rich presence
    [
        ["UpdateDetails", [localize "STR_MISSION_VERSION", "on", getText (configfile >> "CfgWorlds" >> worldName >> "description")] joinString " "]
    ] call (missionNamespace getVariable ["DiscordRichPresence_fnc_update", {}]);

    // Add EH for curator to add kill manager and object init recognition for zeus spawned units/vehicles
    {
        _x addEventHandler ["CuratorObjectPlaced", {[_this select 1] call KPLIB_fnc_handlePlacedZeusObject;}];
    } forEach allCurators;

    waitUntil {alive player};
    if (debug_source != name player) then {debug_source = name player};
    [] call compileFinal preprocessFileLineNumbers "scripts\client\init_client.sqf";
} else {
    setViewDistance 1600;
};

// Execute fnc_reviveInit again (by default it executes in postInit)
if ((isNil {player getVariable "bis_revive_ehHandleHeal"} || isDedicated) && !(bis_reviveParam_mode == 0)) then {
    [] call bis_fnc_reviveInit;
};

KPLIB_init = true;

// Notify clients that server is ready
if (isServer) then {
    KPLIB_initServer = true;
    publicVariable "KPLIB_initServer";
};
