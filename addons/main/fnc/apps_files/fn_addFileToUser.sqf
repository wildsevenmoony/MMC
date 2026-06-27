#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a file to a mission-defined user account on a computer.
 */

params [
	["_object", objNull, [objNull]],
	["_username", "", [""]],
	["_name", "new_file.txt", [""]],
	["_content", "", [""]],
	["_type", "text", [""]],
	["_path", "", [""]],
	["_texture", "", [""]],
	["_soundClass", "", [""]]
];

if (isNull _object || {_username isEqualTo ""}) exitWith {false};

private _data = _object getVariable [QGVAR(data), [createHashMap] call FUNC(createDefaultData)];
private _users = _data getOrDefault ["users", []];
private _lookup = toLowerANSI _username;
private _index = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
if (_index < 0) exitWith {
	["Files", "Add file failed because user was not found", createHashMapFromArray [
		["object", _object],
		["username", _username],
		["name", _name],
		["type", _type],
		["knownUsers", _users apply {_x getOrDefault ["username", ""]}]
	]] call FUNC(debugLog);
	false
};

private _user = _users select _index;
private _files = _user getOrDefault ["files", []];
_files pushBack (createHashMapFromArray [
	["name", _name],
	["type", _type],
	["path", _path],
	["content", _content],
	["texture", _texture],
	["soundClass", _soundClass]
]);
_user set ["files", _files];
_users set [_index, _user];
_data set ["users", _users];
_object setVariable [QGVAR(data), _data, true];
["Files", "Added file to user", createHashMapFromArray [
	["object", _object],
	["username", _username],
	["name", _name],
	["type", _type],
	["path", _path],
	["soundClass", _soundClass],
	["fileCount", count _files]
]] call FUNC(debugLog);
true
