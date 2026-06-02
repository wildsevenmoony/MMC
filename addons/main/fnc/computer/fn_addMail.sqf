#include "..\..\script_component.hpp"

params [
	["_object", objNull, [objNull]],
	["_from", "unknown@mmc.local", [""]],
	["_to", "", [""]],
	["_subject", "No subject", [""]],
	["_body", "", [""]],
	["_date", "", [""]]
];

if (isNull _object) exitWith {false};

private _data = _object getVariable [QGVAR(data), [createHashMap] call FUNC(createDefaultData)];
private _mail = _data getOrDefault ["mail", []];
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
_data set ["mail", _mail];
_object setVariable [QGVAR(data), _data, true];
true
