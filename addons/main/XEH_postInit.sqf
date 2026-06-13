#include "script_component.hpp"

/*
 * Author: Moony
 * Replays local ACE interactions for registered computers on clients/JIP.
 */

if (!hasInterface) exitWith {};

[] call FUNC(addZeusActions);

[] spawn {
	waitUntil {
		!isNull player
	};

	for "_i" from 0 to 20 do {
		{
			if (_x getVariable [QGVAR(isComputer), false]) then {
				[_x] call FUNC(addActions);
			};
		} forEach (allMissionObjects "All");

		uiSleep 1;
	};
};
