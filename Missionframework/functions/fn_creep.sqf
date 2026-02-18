/*
    File: fn_creep.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2026-02-18
    Last Update: 2026-02-18
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Orders an infantry group to creep (cautious advance using cover) toward a target
        position using LAMBS waypoint scripting. Falls back to vanilla stealth waypoints
        if LAMBS is not loaded.

    Parameter(s):
        _grp - Group to assign creep behavior [GROUP]
        _targetPos - Position to creep toward [ARRAY]
        _range - Completion radius [NUMBER, defaults to 50]

    Returns:
        Nothing
*/

params [
    ["_grp", grpNull, [grpNull]],
    ["_targetPos", [0,0,0], [[]]],
    ["_range", 50, [0]]
];

if (isNull _grp) exitWith {};
if ((units _grp) isEqualTo []) exitWith {};

// Only apply to infantry groups
if (vehicle (leader _grp) != (leader _grp)) exitWith {};

if (!isNil "lambs_wp_fnc_taskCreep") then {
    // Clear existing waypoints
    while {!((waypoints _grp) isEqualTo [])} do {
        deleteWaypoint ((waypoints _grp) select 0);
    };
    {_x doFollow leader _grp} forEach units _grp;

    // Add LAMBS creep waypoint
    private _wp = _grp addWaypoint [_targetPos, _range];
    _wp setWaypointType "SCRIPTED";
    _wp setWaypointScript "\lambs\wp\fnc_taskCreep.sqf";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointCombatMode "YELLOW";
    _wp setWaypointSpeed "LIMITED";
    _wp setWaypointCompletionRadius _range;

    // Add SAD cycle after reaching target
    private _wp2 = _grp addWaypoint [_targetPos, _range];
    _wp2 setWaypointType "SAD";
    _wp2 setWaypointBehaviour "COMBAT";
    _wp2 setWaypointCombatMode "RED";

    private _wp3 = _grp addWaypoint [_targetPos, _range];
    _wp3 setWaypointType "CYCLE";
} else {
    // Vanilla fallback - slow cautious advance with stealth
    while {!((waypoints _grp) isEqualTo [])} do {
        deleteWaypoint ((waypoints _grp) select 0);
    };
    {_x doFollow leader _grp} forEach units _grp;

    _grp setBehaviourStrong "AWARE";
    _grp setSpeedMode "LIMITED";
    _grp setCombatMode "YELLOW";

    private _wp = _grp addWaypoint [_targetPos, _range];
    _wp setWaypointType "MOVE";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointSpeed "LIMITED";
    _wp setWaypointCombatMode "YELLOW";
    _wp setWaypointCompletionRadius _range;
    _wp setWaypointFormation "STAG COLUMN";

    private _wp2 = _grp addWaypoint [_targetPos, _range];
    _wp2 setWaypointType "SAD";

    private _wp3 = _grp addWaypoint [_targetPos, _range];
    _wp3 setWaypointType "CYCLE";
};
