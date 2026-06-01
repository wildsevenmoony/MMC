#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Opens the computer UI for a registered computer object.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 *
 * Return Value:
 * Opened <BOOL>
 */

params [["_object", objNull, [objNull]]];

if (isNull _object || {!(_object getVariable [QGVAR(isComputer), false])}) exitWith {false};

if (_object getVariable [QGVAR(booting), false]) exitWith {
	hint "The computer is booting.";
	false
};

if !(_object getVariable [QGVAR(poweredOn), true]) exitWith {
	hint "The computer is powered off.";
	false
};

GVAR(activeComputer) = _object;
createDialog QGVAR(RscComputer);
true
