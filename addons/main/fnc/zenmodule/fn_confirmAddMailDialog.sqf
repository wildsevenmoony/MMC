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

private _direction = ["direction", "inbox"] call _getValue;
private _counterpart = ["counterpart", "sender@mmc.local"] call _getValue;
private _cc = ["cc", ""] call _getValue;
private _subject = ["subject", "Mission Update"] call _getValue;
private _body = ["body", "Mail body goes here."] call _getValue;
private _date = ["date", ""] call _getValue;
private _time = ["time", ""] call _getValue;
private _attachment = ["attachment", ""] call _getValue;
private _attachmentDescription = ["attachmentDescription", ""] call _getValue;
private _selected = (_display getVariable [QGVAR(userCheckboxes), []]) select {cbChecked (_x select 1)};

if (_selected isEqualTo []) exitWith {
	[objNull, "NO USERS SELECTED"] call BIS_fnc_showCuratorFeedbackMessage;
	false
};

if (_attachment isNotEqualTo "" && {!fileExists _attachment}) exitWith {
	[objNull, "ATTACHMENT NOT FOUND"] call BIS_fnc_showCuratorFeedbackMessage;
	false
};

{
	private _computer = _x;
	{
		[_computer, _x select 0, _direction, _counterpart, _cc, _subject, _body, _date, _time, _attachment, _attachmentDescription] remoteExecCall [QFUNC(seedMail), 0, true];
	} forEach _selected;
} forEach GVAR(registeredComputers);

[objNull, "MAIL ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
true
