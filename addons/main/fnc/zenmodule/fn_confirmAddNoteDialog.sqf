#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Confirms the Add Note dynamic dialog.
 *
 * Arguments:
 * 0: Dynamic dialog display <DISPLAY>
 * 1: Parsed field values <ARRAY>
 * 2: Dialog arguments <ANY>
 *
 * Return Value:
 * Confirmed <BOOL>
 */

params ["_display", "_values", "_arguments"];

private _getValue = {
	params ["_key", "_default"];
	private _index = _values findIf {(_x select 0) isEqualTo _key};
	if (_index < 0) exitWith {_default};
	(_values select _index) select 3
};

private _title = ["title", "Personal Note"] call _getValue;
private _body = ["body", ""] call _getValue;
private _selected = (_display getVariable [QGVAR(userCheckboxes), []]) select {cbChecked (_x select 1)};

if (_selected isEqualTo []) exitWith {
	[objNull, "NO USERS SELECTED"] call BIS_fnc_showCuratorFeedbackMessage;
	false
};

{
	private _computer = _x;
	{
		[_computer, _title, _body, (_x select 0)] remoteExecCall [QFUNC(addNote), 2];
	} forEach _selected;
} forEach ([] call FUNC(getRegisteredComputers));

[objNull, "NOTE ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
true
