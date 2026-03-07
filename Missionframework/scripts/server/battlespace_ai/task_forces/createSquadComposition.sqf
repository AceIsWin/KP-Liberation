BATTLESPACE_TASK_FORCES_GET_SQUAD_COMPOSITION = {
	params ["_size", ["_overrideSquadAdditions", []], ["_ambush", false]];
	if (_size <= 2) exitWith { [] };

	// Each entry = their chance
	private _squadAdditions = [opfor_heavygunner, opfor_marksman, opfor_rifleman, opfor_rpg, opfor_rifleman, opfor_team_leader, opfor_grenadier];

	if(air_weight > 40) then {
		_squadAdditions append [opfor_aa, opfor_heavygunner, opfor_rifleman];
	};

	if(armor_weight > 40) then {
		_squadAdditions append [opfor_rpg, opfor_rpg, opfor_machinegunner, opfor_rifleman, opfor_heavygunner];
	};

	if(infantry_weight > 40) then {
		_squadAdditions append [opfor_heavygunner, opfor_rpg, opfor_rto];
	};

	if((count _overrideSquadAdditions) > 0) then {
		_squadAdditions = _overrideSquadAdditions;
	};


	private _baseSquad = [opfor_squad_leader, opfor_medic];

	if(!_ambush) then {
		private _rtoChance = (random 100);
		private _willHaveRto = false;
		_willHaveRto = _rtoChance <= 14;
		if(_willHaveRto == true) then {
			_baseSquad pushBack opfor_rto;
		};
	};


	while {(count _baseSquad < _squadSize)} do {
		_baseSquad pushBack selectRandom _squadAdditions;
	};
	_baseSquad
};