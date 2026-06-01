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
	["source", "module"]
];

private _index = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
if (_index < 0) then {
	_users pushBack _user;
} else {
	_users set [_index, _user];
};

_data set ["users", _users];
_object setVariable [QGVAR(data), _data, true];
true
