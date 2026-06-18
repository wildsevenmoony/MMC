#include "..\..\script_component.hpp"

params [
	["_object", objNull, [objNull]],
	["_from", "Unknown", [""]],
	["_body", "", [""]],
	["_date", "", [""]]
];

if (isNull _object) exitWith {false};

private _data = _object getVariable [QGVAR(data), [createHashMap] call FUNC(createDefaultData)];
private _messages = _data getOrDefault ["messages", []];
_messages pushBack (createHashMapFromArray [
	["from", _from],
	["body", _body],
	["date", _date]
]);
_data set ["messages", _messages];
_object setVariable [QGVAR(data), _data, true];
true
