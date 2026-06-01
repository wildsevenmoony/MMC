#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds or updates a login user on an MMC computer.
 */

params [
	["_object", objNull, [objNull]],
	["_username", "operator", [""]],
	["_password", "", [""]],
	["_email", "", [""]],
	["_background", "default_dark", [""]]
];

if (isNull _object) exitWith {false};
if (_username isEqualTo "") exitWith {false};

if (_email isEqualTo "") then {
	_email = format ["%1@mccsystems.com", _username];
};

private _data = _object getVariable [QGVAR(data), [createHashMap] call FUNC(createDefaultData)];
private _users = _data getOrDefault ["users", []];
private _lookup = toLowerANSI _username;
private _user = createHashMapFromArray [
	["username", _username],
	["password", _password],
	["email", _email],
	["background", _background],
	["files", []],
	["mail", []],
	["source", "module"]
];

private _index = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
if (_index < 0) then {
	_users pushBack _user;
} else {
	private _existing = _users select _index;
	_user set ["files", _existing getOrDefault ["files", []]];
	_user set ["mail", _existing getOrDefault ["mail", []]];
	_users set [_index, _user];
};

_data set ["users", _users];
_object setVariable [QGVAR(data), _data, true];

if !(GVAR(registeredUsers) isEqualType []) then {
	GVAR(registeredUsers) = [];
};

private _globalIndex = GVAR(registeredUsers) findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
if (_globalIndex < 0) then {
	GVAR(registeredUsers) pushBack _user;
} else {
	GVAR(registeredUsers) set [_globalIndex, _user];
};

true
