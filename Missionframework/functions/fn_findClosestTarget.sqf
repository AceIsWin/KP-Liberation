/*
    File: fn_findClosestTarget.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2026-02-18
    Last Update: 2026-02-18
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Finds the closest known enemy target for a given unit using LAMBS danger fsm.
        Falls back to vanilla nearestEnemy if LAMBS is not loaded.

    Parameter(s):
        _unit - Unit to find target for [OBJECT]
        _range - Maximum search range [NUMBER, defaults to 500]

    Returns:
        Closest enemy target or objNull [OBJECT]
*/

params [
    ["_unit", objNull, [objNull]],
    ["_range", 500, [0]]
];

if (isNull _unit || {!alive _unit}) exitWith {objNull};

private _target = objNull;

// Try LAMBS target assessment first
if (!isNil "lambs_danger_fnc_findClosestTarget") then {
    _target = [_unit, _range] call lambs_danger_fnc_findClosestTarget;
} else {
    // Vanilla fallback - check known enemies from unit's group knowledge
    private _enemies = (_unit nearEntities [["Man", "Car", "Tank", "Air"], _range]) select {
        side _x != side _unit &&
        {side _x != civilian} &&
        {alive _x} &&
        {_unit knowsAbout _x > 1.5}
    };

    if !(_enemies isEqualTo []) then {
        _enemies = [_enemies, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy;
        _target = _enemies select 0;
    };
};

_target
