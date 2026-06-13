#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Returns registered MMC computer objects known locally or through public object state.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Registered computer objects <ARRAY>
 */

private _computers = [];

if (GVAR(registeredComputers) isEqualType []) then {
	_computers append GVAR(registeredComputers);
};

{
	if (!isNull _x && {_x getVariable [QGVAR(isComputer), false]}) then {
		_computers pushBackUnique _x;
	};
} forEach (allMissionObjects "All");

GVAR(registeredComputers) = _computers;
_computers
