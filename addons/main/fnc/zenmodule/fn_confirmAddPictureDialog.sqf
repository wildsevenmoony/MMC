#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Confirms the Add Picture dynamic dialog.
 */

params ["_display", "_values", "_arguments"];

private _getValue = {
	params ["_key", "_default"];
	private _index = _values findIf {(_x select 0) isEqualTo _key};
	if (_index < 0) exitWith {_default};
	(_values select _index) select 3
};

private _name = ["fileName", "picture.paa"] call _getValue;
private _path = ["filePath", "\Pictures\picture.paa"] call _getValue;
private _texture = ["fileTexture", ""] call _getValue;
private _description = ["fileDescription", ""] call _getValue;
private _selected = (_display getVariable [QGVAR(userCheckboxes), []]) select {cbChecked (_x select 1)};

if (_texture isEqualTo "") then {
	_texture = _path;
};

if (_selected isEqualTo []) exitWith {
	[objNull, "NO USERS SELECTED"] call BIS_fnc_showCuratorFeedbackMessage;
	false
};

{
	private _computer = _x;
	{
		[_computer, _x select 0, _name, _description, "picture", _path, _texture] remoteExecCall [QFUNC(addFileToUser), 2];
	} forEach _selected;
} forEach ([] call FUNC(getRegisteredComputers));

[objNull, "PICTURE ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
true
