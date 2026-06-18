#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Closes the local MMC dialog if its computer was destroyed.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 *
 * Return Value:
 * None
 */

params [["_object", objNull, [objNull]]];

if (!isNull _object) then {
	_object setVariable [QGVAR(destroyed), true];
	_object setVariable [QGVAR(poweredOn), false];
	_object setVariable [QGVAR(booting), false];
};

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _computer = _display getVariable [QGVAR(computer), objNull];
if (_computer isEqualTo _object) then {
	_display closeDisplay 1;
};
