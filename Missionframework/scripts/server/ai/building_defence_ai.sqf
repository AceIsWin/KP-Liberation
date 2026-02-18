params ["_unit", ["_sector", ""]];

_unit setUnitPos "UP";
_unit disableAI "PATH";
private _move_is_disabled = true;
private _hostiles = 0;
private _ratio = 0.4;
private _range = 40;

while {_move_is_disabled && local _unit && alive _unit && !(captive _unit)} do {

    if !(_sector isEqualTo "") then {
        _ratio = [_sector] call KPLIB_fnc_getBluforRatio;
    };

    _range = floor (linearConversion [0, 1, _ratio, 0, GRLIB_capture_size / 3 * 2, true]);

    _hostiles = ((getPos _unit) nearEntities [["Man"], _range]) select {side _x == GRLIB_side_friendly};

    if (_move_is_disabled &&
        {
            (_sector in blufor_sectors) ||
            {!(_hostiles isEqualTo [])} ||
            {damage _unit > 0.25}
        }
    ) then {
        _move_is_disabled = false;
        _unit enableAI "PATH";
        _unit setUnitPos "AUTO";

        // LAMBS: When building defenders are activated, use UGL against nearby hostiles
        if (!(_hostiles isEqualTo []) && {count _hostiles > 2}) then {
            private _targetPos = getPos (_hostiles select 0);
            [_unit, _targetPos] call KPLIB_fnc_doUgl;
        };

        // LAMBS: Once activated, assign garrison behavior to the unit's group
        // so they tactically reposition within nearby buildings
        if (!isNil "lambs_wp_fnc_taskGarrison") then {
            private _grp = group _unit;
            if (!isNull _grp && {count (units _grp) > 1}) then {
                [_grp, getPos _unit, 80] call KPLIB_fnc_garrison;
            };
        };
    };

    if (_move_is_disabled) then {
        private _target = assignedTarget _unit;
        if(!(isnull _target)) then {
            private _vd = (getPosASL _target) vectorDiff (getpos _unit);
            private _newdir = (_vd select 0) atan2 (_vd select 1);
            if (_newdir < 0) then {_dir = 360 + _newdir};
            _unit setdir (_newdir);
        };
    };
    sleep 5;
};
