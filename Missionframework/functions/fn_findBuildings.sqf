/*
    File: fn_findBuildings.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2026-02-18
    Last Update: 2026-02-18
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Finds nearby buildings with available positions for AI garrison using LAMBS.
        Falls back to vanilla building search if LAMBS is not loaded.

    Parameter(s):
        _pos - Center position to search from [ARRAY]
        _range - Search radius [NUMBER, defaults to 150]
        _minPositions - Minimum building positions required [NUMBER, defaults to 3]

    Returns:
        Array of building positions [ARRAY]
*/

params [
    ["_pos", [0,0,0], [[]]],
    ["_range", 150, [0]],
    ["_minPositions", 3, [0]]
];

private _positions = [];

if (!isNil "lambs_danger_fnc_findBuildings") then {
    _positions = [_pos, _range] call lambs_danger_fnc_findBuildings;
} else {
    // Vanilla fallback
    private _buildings = (nearestObjects [_pos, ["House"], _range]) select {alive _x};
    {
        private _bPos = [_x] call BIS_fnc_buildingPositions;
        if (count _bPos >= _minPositions) then {
            _positions append _bPos;
        };
    } forEach _buildings;
};

_positions
