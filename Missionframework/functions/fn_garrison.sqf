/*
    File: fn_garrison.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2026-02-18
    Last Update: 2026-02-18
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Orders a group to garrison nearby buildings using LAMBS waypoint scripting.
        Units will occupy building positions and engage enemies from cover.
        Falls back to vanilla building_defence_ai if LAMBS is not loaded.

    Parameter(s):
        _grp - Group to garrison [GROUP]
        _targetPos - Center position to garrison around [ARRAY]
        _range - Radius to search for buildings [NUMBER, defaults to 150]

    Returns:
        Nothing
*/

params [
    ["_grp", grpNull, [grpNull]],
    ["_targetPos", [0,0,0], [[]]],
    ["_range", 150, [0]]
];

if (isNull _grp) exitWith {};
if ((units _grp) isEqualTo []) exitWith {};

if (!isNil "lambs_wp_fnc_taskGarrison") then {
    // Clear existing waypoints
    while {!((waypoints _grp) isEqualTo [])} do {
        deleteWaypoint ((waypoints _grp) select 0);
    };
    {_x doFollow leader _grp} forEach units _grp;

    // Add LAMBS garrison waypoint
    private _wp = _grp addWaypoint [_targetPos, 0];
    _wp setWaypointType "SCRIPTED";
    _wp setWaypointScript "\lambs\wp\fnc_taskGarrison.sqf";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointCombatMode "YELLOW";
    _wp setWaypointSpeed "LIMITED";
    _wp setWaypointCompletionRadius _range;
} else {
    // Vanilla fallback - move to position and set defensive posture
    while {!((waypoints _grp) isEqualTo [])} do {
        deleteWaypoint ((waypoints _grp) select 0);
    };
    {_x doFollow leader _grp} forEach units _grp;

    private _wp = _grp addWaypoint [_targetPos, 0];
    _wp setWaypointType "HOLD";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointCombatMode "YELLOW";
    _wp setWaypointSpeed "LIMITED";
};
