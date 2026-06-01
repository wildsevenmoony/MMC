#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Confirms the Add Mail dynamic dialog.
 */

params ["_display", "_values", "_arguments"];

private _getValue = {
	params ["_key", "_default"];
	private _index = _values findIf {(_x select 0) isEqualTo _key};
	if (_index < 0) exitWith {_default};
	(_values select _index) select 3
};

private _from = ["from", "sender@mmc.local"] call _getValue;
private _to = ["to", ""] call _getValue;
private _subject = ["subject", "Mission Update"] call _getValue;
private _body = ["body", "Mail body goes here."] call _getValue;
private _date = ["date", "2035-06-01 08:00"] call _getValue;
private _selected = (_display getVariable [QGVAR(userCheckboxes), []]) select {cbChecked (_x select 1)};

if (_selected isEqualTo []) exitWith {
	[objNull, "NO USERS SELECTED"] call BIS_fnc_showCuratorFeedbackMessage;
	false
};

{
	private _computer = _x;
	{
		[_computer, _x select 0, _from, _to, _subject, _body, _date] remoteExecCall [QFUNC(addMailToUser), 0, true];
	} forEach _selected;
} forEach GVAR(registeredComputers);

[objNull, "MAIL ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
true
