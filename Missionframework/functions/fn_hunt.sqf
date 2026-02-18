/*
    File: fn_hunt.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2026-02-18
    Last Update: 2026-02-18
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Orders a group to hunt toward a target position using LAMBS waypoint scripting.
        The group will move aggressively, flanking and using fire-and-movement to
        close on the objective. Falls back to vanilla COMBAT waypoints if LAMBS is not loaded.

    Parameter(s):
        _grp - Group to assign hunt behavior [GROUP]
        _targetPos - Position to hunt toward [ARRAY]
        _range - Completion radius [NUMBER, defaults to 100]

    Returns:
        Nothing
*/

params [
    ["_grp", grpNull, [grpNull]],
    ["_targetPos", [0,0,0], [[]]],
    ["_range", 100, [0]]
];

if (isNull _grp) exitWith {};
if ((units _grp) isEqualTo []) exitWith {};

if (!isNil "lambs_wp_fnc_taskHunt") then {
    // Clear existing waypoints
    while {!((waypoints _grp) isEqualTo [])} do {
        deleteWaypoint ((waypoints _grp) select 0);
    };
    {_x doFollow leader _grp} forEach units _grp;

    // Add LAMBS hunt waypoint
    private _wp = _grp addWaypoint [_targetPos, _range];
    _wp setWaypointType "SCRIPTED";
    _wp setWaypointScript "\lambs\wp\fnc_taskHunt.sqf";
    _wp setWaypointBehaviour "COMBAT";
    _wp setWaypointCombatMode "RED";
    _wp setWaypointSpeed "NORMAL";
    _wp setWaypointCompletionRadius _range;

    // Cycle at the target
    private _wp2 = _grp addWaypoint [_targetPos, _range];
    _wp2 setWaypointType "SAD";
    _wp2 setWaypointBehaviour "COMBAT";
    _wp2 setWaypointCombatMode "RED";

    private _wp3 = _grp addWaypoint [_targetPos, _range];
    _wp3 setWaypointType "CYCLE";
} else {
    // Vanilla fallback - aggressive advance
    while {!((waypoints _grp) isEqualTo [])} do {
        deleteWaypoint ((waypoints _grp) select 0);
    };
    {_x doFollow leader _grp} forEach units _grp;

    private _wp = _grp addWaypoint [_targetPos, _range];
    _wp setWaypointType "MOVE";
    _wp setWaypointBehaviour "COMBAT";
    _wp setWaypointCombatMode "RED";
    _wp setWaypointSpeed "NORMAL";
    _wp setWaypointCompletionRadius _range;

    private _wp2 = _grp addWaypoint [_targetPos, _range];
    _wp2 setWaypointType "SAD";

    private _wp3 = _grp addWaypoint [_targetPos, _range];
    _wp3 setWaypointType "SAD";

    private _wp4 = _grp addWaypoint [_targetPos, _range];
    _wp4 setWaypointType "CYCLE";
};
