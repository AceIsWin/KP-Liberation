/*
    File: fn_rush.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2026-02-18
    Last Update: 2026-02-18
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Orders a group to rush a target position using LAMBS waypoint scripting.
        The group performs a full speed aggressive assault on the position.
        Falls back to vanilla FULL speed COMBAT waypoints if LAMBS is not loaded.

    Parameter(s):
        _grp - Group to assign rush behavior [GROUP]
        _targetPos - Position to rush toward [ARRAY]
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

if (!isNil "lambs_wp_fnc_taskRush") then {
    // Clear existing waypoints
    while {!((waypoints _grp) isEqualTo [])} do {
        deleteWaypoint ((waypoints _grp) select 0);
    };
    {_x doFollow leader _grp} forEach units _grp;

    // Add LAMBS rush waypoint
    private _wp = _grp addWaypoint [_targetPos, _range];
    _wp setWaypointType "SCRIPTED";
    _wp setWaypointScript "\lambs\wp\fnc_taskRush.sqf";
    _wp setWaypointBehaviour "COMBAT";
    _wp setWaypointCombatMode "RED";
    _wp setWaypointSpeed "FULL";
    _wp setWaypointCompletionRadius _range;

    // SAD after rushing
    private _wp2 = _grp addWaypoint [_targetPos, _range];
    _wp2 setWaypointType "SAD";
    _wp2 setWaypointBehaviour "COMBAT";
    _wp2 setWaypointCombatMode "RED";

    private _wp3 = _grp addWaypoint [_targetPos, _range];
    _wp3 setWaypointType "CYCLE";
} else {
    // Vanilla fallback - full speed assault
    while {!((waypoints _grp) isEqualTo [])} do {
        deleteWaypoint ((waypoints _grp) select 0);
    };
    {_x doFollow leader _grp} forEach units _grp;

    private _wp = _grp addWaypoint [_targetPos, _range];
    _wp setWaypointType "MOVE";
    _wp setWaypointBehaviour "COMBAT";
    _wp setWaypointCombatMode "RED";
    _wp setWaypointSpeed "FULL";
    _wp setWaypointCompletionRadius _range;
    _wp setWaypointFormation "LINE";

    private _wp2 = _grp addWaypoint [_targetPos, _range];
    _wp2 setWaypointType "SAD";

    private _wp3 = _grp addWaypoint [_targetPos, _range];
    _wp3 setWaypointType "SAD";

    private _wp4 = _grp addWaypoint [_targetPos, _range];
    _wp4 setWaypointType "CYCLE";
};
