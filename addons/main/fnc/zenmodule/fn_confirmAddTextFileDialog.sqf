#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Confirms the Add Text File dynamic dialog.
 */

params ["_display", "_values", "_arguments"];

private _getValue = {
	params ["_key", "_default"];
	private _index = _values findIf {(_x select 0) isEqualTo _key};
	if (_index < 0) exitWith {_default};
	(_values select _index) select 3
};

private _name = ["fileName", "intel.txt"] call _getValue;
private _path = ["filePath", "\Desktop\intel.txt"] call _getValue;
private _content = ["content", "Mission intel goes here."] call _getValue;
private _selected = (_display getVariable [QGVAR(userCheckboxes), []]) select {cbChecked (_x select 1)};

if (_selected isEqualTo []) exitWith {
	[objNull, "NO USERS SELECTED"] call BIS_fnc_showCuratorFeedbackMessage;
	false
};

{
	private _computer = _x;
	{
		[_computer, _x select 0, _name, _content, "text", _path] remoteExecCall [QFUNC(addFileToUser), 2];
	} forEach _selected;
} forEach ([] call FUNC(getRegisteredComputers));

[objNull, "TEXT FILE ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
true
