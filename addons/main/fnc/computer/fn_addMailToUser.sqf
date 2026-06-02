#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds an email to a mission-defined user account on a computer.
 */

params [
	["_object", objNull, [objNull]],
	["_username", "", [""]],
	["_from", "unknown@mmc.local", [""]],
	["_to", "", [""]],
	["_subject", "No subject", [""]],
	["_body", "", [""]],
	["_date", "", [""]]
];

if (isNull _object || {_username isEqualTo ""}) exitWith {false};

private _data = _object getVariable [QGVAR(data), [createHashMap] call FUNC(createDefaultData)];
private _users = _data getOrDefault ["users", []];
private _lookup = toLowerANSI _username;
private _index = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
if (_index < 0) exitWith {false};

private _user = _users select _index;
if (_to isEqualTo "") then {
	_to = _user getOrDefault ["email", ""];
};

private _mail = _user getOrDefault ["mail", []];
private _dateParts = _date splitString " ";
private _dateOnly = _dateParts param [0, _date, [""]];
private _timeOnly = _dateParts param [1, "", [""]];
_mail pushBack (createHashMapFromArray [
	["from", _from],
	["to", _to],
	["subject", _subject],
	["body", _body],
	["date", _dateOnly],
	["time", _timeOnly],
	["cc", ""],
	["read", false]
]);
_user set ["mail", _mail];
_users set [_index, _user];
_data set ["users", _users];
_object setVariable [QGVAR(data), _data, true];
true
