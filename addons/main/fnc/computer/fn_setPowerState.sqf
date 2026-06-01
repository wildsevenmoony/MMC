#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Sets the power state for a registered computer object.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: Powered on <BOOL>
 *
 * Return Value:
 * New power state <BOOL>
 */

params [
	["_object", objNull, [objNull]],
	["_poweredOn", true, [true]]
];

if (isNull _object) exitWith {false};

_object setVariable [QGVAR(poweredOn), _poweredOn, true];
if (!_poweredOn) then {
	_object setVariable [QGVAR(booting), false, true];
	_object setVariable [QGVAR(activeUser), createHashMap, true];
	[_object] call FUNC(stopAudio);
	[_object, "powered_off"] call FUNC(setScreenState);
} else {
	[_object, ["desktop", "login"] select (count ([_object] call FUNC(getActiveUser)) == 0)] call FUNC(setScreenState);
};
_poweredOn
