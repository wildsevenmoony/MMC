#include "..\..\script_component.hpp"

params [
	["_object", objNull, [objNull]],
	["_title", "Untitled note", [""]],
	["_body", "", [""]]
];

if (isNull _object) exitWith {false};

private _data = _object getVariable [QGVAR(data), [createHashMap] call FUNC(createDefaultData)];
private _notes = _data getOrDefault ["notes", []];
_notes pushBack (createHashMapFromArray [
	["title", _title],
	["body", _body]
]);
_data set ["notes", _notes];
_object setVariable [QGVAR(data), _data, true];
true
