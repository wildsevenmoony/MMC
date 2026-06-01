#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Stops audio currently playing from a computer object on all clients.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 *
 * Return Value:
 * Stopped <BOOL>
 */

params [["_object", objNull, [objNull]]];

if (isNull _object) exitWith {false};

_object setVariable [QGVAR(audioIndex), -1, true];
[_object] remoteExecCall [QFUNC(stopAudioLocal), 2];
true
