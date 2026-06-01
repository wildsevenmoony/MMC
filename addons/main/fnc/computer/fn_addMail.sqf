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
_mail pushBack (createHashMapFromArray [
	["from", _from],
	["to", _to],
	["subject", _subject],
	["body", _body],
	["date", _date]
]);
_data set ["mail", _mail];
_object setVariable [QGVAR(data), _data, true];
true
