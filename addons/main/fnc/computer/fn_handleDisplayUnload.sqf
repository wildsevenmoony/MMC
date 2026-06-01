#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Cleans up the MMC display and optionally logs out the current computer.
 */

params [
	["_display", displayNull, [displayNull]],
	["_exitCode", 0, [0]]
];

if (!isNull _display && {GVAR(logoutOnClose)}) then {
	private _computer = _display getVariable [QGVAR(computer), objNull];
	[_computer] call FUNC(logout);
};

uiNamespace setVariable [QGVAR(display), displayNull];
