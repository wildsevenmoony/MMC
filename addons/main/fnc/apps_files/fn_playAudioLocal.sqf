#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Starts a local looping audio source on a computer object.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: Audio source CfgVehicles class <STRING>
 * 2: Display name <STRING>
 *
 * Return Value:
 * Started <BOOL>
 */

params [
	["_object", objNull, [objNull]],
	["_soundClass", "", [""]],
	["_name", "Audio", [""]]
];

if (isNull _object || {_soundClass isEqualTo ""}) exitWith {false};

[_object] call FUNC(stopAudioLocal);

private _source = createSoundSource [_soundClass, _object, [], 0];
if (isNull _source) exitWith {false};

_source attachTo [_object, [0, 0, 0]];
_object setVariable [QGVAR(audioSource), _source];
_object setVariable [QGVAR(audioName), _name];
true
