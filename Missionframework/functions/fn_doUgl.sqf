/*
    File: fn_doUgl.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2026-02-18
    Last Update: 2026-02-18
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Orders units with underbarrel grenade launchers (UGL) to fire at a target position
        using LAMBS danger fsm. If LAMBS is not loaded, performs a vanilla suppressive fire action.

    Parameter(s):
        _unit - Unit to perform the UGL fire [OBJECT]
        _targetPos - Position to fire at [ARRAY]

    Returns:
        Whether the unit fired [BOOL]
*/

params [
    ["_unit", objNull, [objNull]],
    ["_targetPos", [0,0,0], [[]]]
];

if (isNull _unit || {!alive _unit}) exitWith {false};

if (!isNil "lambs_danger_fnc_doUGL") then {
    [_unit, _targetPos] call lambs_danger_fnc_doUGL;
    true
} else {
    // Vanilla fallback - check if unit has a grenade launcher muzzle
    private _weapon = primaryWeapon _unit;
    if (_weapon isEqualTo "") exitWith {false};

    private _muzzles = getArray (configFile >> "CfgWeapons" >> _weapon >> "muzzles");
    private _uglMuzzle = _muzzles select {toLower _x != "this"};

    if (_uglMuzzle isEqualTo []) exitWith {false};

    _unit forceWeaponFire [_uglMuzzle select 0, "Single"];
    true
};
