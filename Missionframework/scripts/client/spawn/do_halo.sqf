/*
    File: do_halo.sqf
    Author: AceIsWin (KP Liberation Fork)
    Description:
        HALO jump system for player and attached AI squad members.
        Opens map dialog for DZ selection, saves squad gear via HashMap,
        equips parachutes, teleports to altitude, and restores original
        gear on landing. AI land in formation spread around player DZ.

    Parameter(s):
        None - called via player action

    Returns:
        Nothing

    Dependencies:
        - liberation_halo dialog (description.ext)
        - GRLIB_halo_altitude (kp_liberation_config.sqf)
        - GRLIB_halo_param (kp_liberation_config.sqf) - cooldown in minutes, 0/1 = no cooldown
        - markers_reset (shared init)
        - paraDrop (remote function)
*/

// --- Guard: don't stack HALO calls ---
if (!isNil "KPLIB_halo_in_progress" && {KPLIB_halo_in_progress}) exitWith {};

// --- Cooldown check ---
if (isNil "KPLIB_last_halo_jump") then { KPLIB_last_halo_jump = -86400 };

if (GRLIB_halo_param > 1) then {
    private _cooldownEnd = KPLIB_last_halo_jump + (GRLIB_halo_param * 60);
    if (_cooldownEnd >= time) exitWith {
        private _remaining = ceil ((_cooldownEnd - time) / 60);
        hint format [localize "STR_HALO_DENIED_COOLDOWN", _remaining];
    };
};

KPLIB_halo_in_progress = true;

// --- Cleanup handler - guarantees state reset on any exit path ---
private _cleanup = {
    KPLIB_halo_in_progress = false;
    "spawn_marker" setMarkerPosLocal markers_reset;
    "spawn_marker" setMarkerTextLocal "";
    ["halo_map_event", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
    if (dialog) then { closeDialog 0 };
};

// --- Config ---
private _minJumpDist     = 200;
private _maxAiDist       = 50;
private _chuteClassname  = "B_Parachute";
private _jumpAltitude    = GRLIB_halo_altitude + 200;

// --- Map dialog for DZ selection ---
dojump = 0;
halo_position = getPosATL player;

createDialog "liberation_halo";

["halo_map_event", "onMapSingleClick", {
    halo_position = _pos;
}] call BIS_fnc_addStackedEventHandler;

"spawn_marker" setMarkerTextLocal (localize "STR_HALO_PARAM");

waitUntil { dialog };

while { dialog && alive player && dojump == 0 } do {
    "spawn_marker" setMarkerPosLocal halo_position;
    sleep 0.1;
};

if (dialog) then {
    closeDialog 0;
    sleep 0.1;
};

"spawn_marker" setMarkerPosLocal markers_reset;
"spawn_marker" setMarkerTextLocal "";
["halo_map_event", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

// --- Cancelled ---
if (dojump == 0) exitWith {
    call _cleanup;
};

// --- Validate DZ ---
if (player distance2D halo_position < _minJumpDist) exitWith {
    hint format ["DZ too close. Minimum: %1m", _minJumpDist];
    call _cleanup;
};

// --- Mark cooldown from confirmed jump ---
KPLIB_last_halo_jump = time;

// --- Select eligible AI ---
private _aiUnits = (units group player) select {
    !isPlayer _x
    && {alive _x}
    && {lifeState _x != "INCAPACITATED"}
    && {isNull objectParent _x}
    && {_x distance2D player < _maxAiDist}
};

// --- Collect wounded AI that can't jump ---
private _leftBehind = (units group player) select {
    !isPlayer _x
    && {alive _x}
    && {lifeState _x == "INCAPACITATED"}
    && {_x distance2D player < _maxAiDist}
};

private _totalJumpers = 1 + count _aiUnits;

if (count _leftBehind > 0) then {
    hint format [
        "HALO: %1 jumper%2 ready. %3 wounded left behind.",
        _totalJumpers,
        ["s", ""] select (_totalJumpers == 1),
        count _leftBehind
    ];
} else {
    hint format [
        "HALO: %1 jumper%2 ready.",
        _totalJumpers,
        ["s", ""] select (_totalJumpers == 1)
    ];
};

sleep 1;

// --- Save all gear to HashMap: unit -> {backpack, items, magazines} ---
private _gearCache = createHashMap;

private _fnc_saveAndSwapGear = {
    params ["_unit", "_gearCache", "_chuteClassname"];

    private _bp = backpack _unit;

    if (_bp != "" && {_bp != _chuteClassname}) then {
        _gearCache set [_unit, createHashMapFromArray [
            ["backpack", _bp],
            ["items",    backpackItems _unit],
            ["mags",     magazinesAmmoCargo (backpackContainer _unit)]
        ]];
    };

    if (!isNull objectParent _unit) then {
        moveOut _unit;
        sleep 0.2;
    };

    removeBackpack _unit;
    _unit addBackpack _chuteClassname;
};

// --- Save and swap AI gear, teleport with formation spread ---
{
    private _idx = _forEachIndex;
    private _unit = _x;

    [_unit, _gearCache, _chuteClassname] call _fnc_saveAndSwapGear;

    // Formation spread: ring around DZ, spaced evenly
    private _angle = (360 / (count _aiUnits)) * _idx;
    private _radius = 15 + random 10;
    private _offsetX = _radius * sin _angle;
    private _offsetY = _radius * cos _angle;

    _unit setPosATL [
        (halo_position select 0) + _offsetX,
        (halo_position select 1) + _offsetY,
        _jumpAltitude
    ];
    _unit setVelocity [0, 0, 0];

    sleep 0.2;
} forEach _aiUnits;

// --- Save and swap player gear, teleport ---
[player, _gearCache, _chuteClassname] call _fnc_saveAndSwapGear;

player setPosATL [
    halo_position select 0,
    halo_position select 1,
    _jumpAltitude
];

// --- Initiate paradrop sequences ---
[player, halo_position] remoteExec ["paraDrop", player];
sleep 1;

{
    [_x, halo_position] remoteExec ["paraDrop", _x];
    sleep 0.3;
} forEach _aiUnits;

// --- Wait for landing ---
waitUntil {
    sleep 0.5;
    !alive player
    || isTouchingGround player
    || (getPosATL player select 2) < 1
    || (getPos player select 2) < 0.5
};

sleep 2;

// --- Restore gear from HashMap ---
private _fnc_restoreGear = {
    params ["_unit", "_gearCache"];

    private _saved = _gearCache getOrDefault [_unit, createHashMap];
    if (count _saved == 0 || {!alive _unit}) exitWith {};

    private _savedBp    = _saved get "backpack";
    private _savedItems = _saved get "items";
    private _savedMags  = _saved getOrDefault ["mags", []];

    removeBackpack _unit;
    sleep 0.1;
    _unit addBackpack _savedBp;
    clearAllItemsFromBackpack _unit;

    // Restore partial magazines first (preserves ammo counts)
    {
        (backpackContainer _unit) addMagazineAmmoCargo [_x select 0, 1, _x select 1];
    } forEach _savedMags;

    // Restore non-magazine items
    { _unit addItemToBackpack _x } forEach _savedItems;
};

// Player first, then AI
[player, _gearCache] call _fnc_restoreGear;

{
    [_x, _gearCache] call _fnc_restoreGear;
} forEach _aiUnits;

// --- Regroup AI on player after landing ---
{
    _x doFollow player;
} forEach _aiUnits;

// --- Done ---
call _cleanup;
