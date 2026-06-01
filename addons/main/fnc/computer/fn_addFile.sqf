#include "..\..\script_component.hpp"

params [
	["_object", objNull, [objNull]],
	["_name", "new_file.txt", [""]],
	["_content", "", [""]],
	["_type", "text", [""]],
	["_path", "", [""]]
];

if (isNull _object) exitWith {false};

private _data = _object getVariable [QGVAR(data), [createHashMap] call FUNC(createDefaultData)];
private _files = _data getOrDefault ["files", []];
_files pushBack (createHashMapFromArray [
	["name", _name],
	["type", _type],
	["path", _path],
	["content", _content]
]);
_data set ["files", _files];
_object setVariable [QGVAR(data), _data, true];
true
