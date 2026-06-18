#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Opens or starts a registered MMC computer from a Zeus action.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 *
 * Return Value:
 * Handled <BOOL>
 */

params [["_computer", objNull, [objNull]]];

if (!hasInterface) exitWith {false};
if (isNull _computer || {!(_computer getVariable [QGVAR(isComputer), false])}) exitWith {
	["Computer is no longer available.", 1.5, player, 12] call ace_common_fnc_displayTextStructured;
	false
};
if (!alive _computer || {_computer getVariable [QGVAR(destroyed), false]}) exitWith {
	["This computer is destroyed.", 1.5, player, 12] call ace_common_fnc_displayTextStructured;
	false
};
if (_computer getVariable [QGVAR(booting), false]) exitWith {
	["The computer is booting.", 1.5, player, 12] call ace_common_fnc_displayTextStructured;
	false
};

if !(_computer getVariable [QGVAR(poweredOn), true]) exitWith {
	[_computer, true] call FUNC(startComputer)
};

[_computer] call FUNC(open)
