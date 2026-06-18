#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Starts an audio file from the computer object on all clients.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: Audio file data <HASHMAP>
 * 2: Audio file index <NUMBER, default: -1>
 *
 * Return Value:
 * Started <BOOL>
 */

params [
	["_object", objNull, [objNull]],
	["_file", createHashMap, [createHashMap]],
	["_index", -1, [0]]
];

if (isNull _object) exitWith {false};

private _soundClass = _file getOrDefault ["soundClass", ""];
if (_soundClass isEqualTo "") exitWith {false};

private _name = _file getOrDefault ["name", "Audio"];
_object setVariable [QGVAR(audioIndex), _index, true];
[_object, _soundClass, _name] remoteExecCall [QFUNC(playAudioLocal), 2];
true
