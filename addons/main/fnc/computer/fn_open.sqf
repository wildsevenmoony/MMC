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

if !([_object] call FUNC(canOpen)) exitWith {false};

private _poweredOn = _object getVariable [QGVAR(poweredOn), true];

if (!_poweredOn) exitWith {
	hint "The computer is powered off.";
	false
};

hint "MMC computer UI placeholder.";
true
