#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Confirms the Add Audio dynamic dialog.
 */

params ["_display", "_values", "_arguments"];

private _getValue = {
	params ["_key", "_default"];
	private _index = _values findIf {(_x select 0) isEqualTo _key};
	if (_index < 0) exitWith {_default};
	(_values select _index) select 3
};

private _name = ["fileName", "audio.ogg"] call _getValue;
private _path = _name;
private _soundClass = [["soundClass", ""] call _getValue] call FUNC(normalizeAudioClass);
private _description = ["fileDescription", ""] call _getValue;
private _selected = (_display getVariable [QGVAR(userCheckboxes), []]) select {cbChecked (_x select 1)};

if (_selected isEqualTo []) exitWith {
	[objNull, "NO USERS SELECTED"] call BIS_fnc_showCuratorFeedbackMessage;
	false
};

{
	private _computer = _x;
	{
		[_computer, _x select 0, _name, _description, "audio", _path, "", _soundClass] remoteExecCall [QFUNC(addFileToUser), 2];
	} forEach _selected;
} forEach ([] call FUNC(getRegisteredComputers));

[objNull, "AUDIO FILE ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
true
