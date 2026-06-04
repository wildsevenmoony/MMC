#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Marks a registered computer as destroyed and applies the broken screen texture.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 *
 * Return Value:
 * Handled <BOOL>
 */

params [["_object", objNull, [objNull]]];

if (isNull _object) exitWith {false};

_object setVariable [QGVAR(destroyed), true, true];
_object setVariable [QGVAR(poweredOn), false, true];
_object setVariable [QGVAR(booting), false, true];
_object setVariable [QGVAR(activeUser), createHashMap, true];
_object setVariable [QGVAR(inUseBy), "", true];

[_object] call FUNC(stopAudio);
[_object, "broken"] call FUNC(setScreenState);
[_object] remoteExecCall [QFUNC(handleDestroyedLocal), 0];

true
