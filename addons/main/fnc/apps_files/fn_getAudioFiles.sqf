#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Returns all audio files visible to the active user on a computer.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 *
 * Return Value:
 * Audio files <ARRAY>
 */

params [["_object", objNull, [objNull]]];

if (isNull _object) exitWith {[]};

private _data = _object getVariable [QGVAR(data), createHashMap];
private _activeUser = [_object] call FUNC(getActiveUser);
private _files = (_data getOrDefault ["files", []]) + (_activeUser getOrDefault ["files", []]);

_files select {(_x getOrDefault ["type", ""]) isEqualTo "audio"}
