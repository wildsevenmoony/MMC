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
	["_theme", "default", [""]],
	["_customLayout", createHashMap, [createHashMap]],
	["_scope", "global", [""]]
];

if (isNull _object) exitWith {false};
if (_username isEqualTo "") exitWith {false};

private _disabledAppsProvided = (count _this) > 7;
private _disabledApps = if (_disabledAppsProvided) then {
	[_this select 7] call FUNC(normalizeStandardAppIds)
} else {
	[]
};
private _metadata = if ((count _this) > 8 && {(_this select 8) isEqualType createHashMap}) then {
	_this select 8
} else {
	createHashMap
};

if (_email isEqualTo "") then {
	_email = format ["%1@mmcsystems.com", _username];
};
_email = [_email, _username] call FUNC(makeUniqueEmail);

private _data = _object getVariable [QGVAR(data), [createHashMap] call FUNC(createDefaultData)];
private _loginRequired = _data getOrDefault ["loginRequired", true];
private _autoLoginUsername = _data getOrDefault ["autoLoginUsername", ""];
private _allowed = true;

if (_data getOrDefault ["closedSystem", false] && {_scope isNotEqualTo "direct"}) then {
	_allowed = false;
};

if (!_loginRequired) then {
	if (_scope isNotEqualTo "direct") then {
		_allowed = false;
	} else {
		if (_autoLoginUsername isEqualTo "") then {
			_autoLoginUsername = _username;
			_data set ["autoLoginUsername", _autoLoginUsername];
		} else {
			if (toLowerANSI _autoLoginUsername isNotEqualTo toLowerANSI _username) then {
				_allowed = false;
			};
		};
	};
};

if (!_allowed) exitWith {
	["User", "Rejected computer user", createHashMapFromArray [
		["object", _object],
		["username", _username],
		["email", _email],
		["scope", _scope],
		["loginRequired", _loginRequired],
		["closedSystem", _data getOrDefault ["closedSystem", false]],
		["autoLoginUsername", _autoLoginUsername]
	]] call FUNC(debugLog);
	false
};

private _users = _data getOrDefault ["users", []];
private _lookup = toLowerANSI _username;
private _user = createHashMapFromArray [
	["username", _username],
	["password", _password],
	["email", _email],
	["theme", _theme],
	["scope", _scope],
	["disabledApps", _disabledApps],
	["displayName", _metadata getOrDefault ["displayName", _username]],
	["messengerName", _metadata getOrDefault ["messengerName", _metadata getOrDefault ["displayName", _username]]],
	["side", _metadata getOrDefault ["side", ""]],
	["messengerSide", _metadata getOrDefault ["messengerSide", _metadata getOrDefault ["side", ""]]],
	["files", []],
	["mail", []],
	["notes", []],
	["source", "module"]
];

if (count _customLayout > 0) then {
	_user set ["customLayout", _customLayout];
};

private _index = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
if (_index < 0) then {
	_users pushBack _user;
} else {
	private _existing = _users select _index;
	_user set ["files", _existing getOrDefault ["files", []]];
	_user set ["mail", _existing getOrDefault ["mail", []]];
	_user set ["outbox", _existing getOrDefault ["outbox", []]];
	_user set ["messages", _existing getOrDefault ["messages", []]];
	_user set ["notes", _existing getOrDefault ["notes", []]];
	_user set ["displayName", _existing getOrDefault ["displayName", _user getOrDefault ["displayName", ""]]];
	_user set ["messengerName", _existing getOrDefault ["messengerName", _user getOrDefault ["messengerName", ""]]];
	_user set ["side", _existing getOrDefault ["side", _user getOrDefault ["side", ""]]];
	_user set ["messengerSide", _existing getOrDefault ["messengerSide", _user getOrDefault ["messengerSide", ""]]];
	_user set ["emailAliases", _existing getOrDefault ["emailAliases", _user getOrDefault ["emailAliases", []]]];
	_user set ["desktopTitle", _existing getOrDefault ["desktopTitle", _user getOrDefault ["desktopTitle", ""]]];
	_user set ["desktopContent", _existing getOrDefault ["desktopContent", _user getOrDefault ["desktopContent", ""]]];
	_user set ["desktopAlign", _existing getOrDefault ["desktopAlign", _user getOrDefault ["desktopAlign", "left"]]];
	if (!_disabledAppsProvided) then {
		_user set ["disabledApps", _existing getOrDefault ["disabledApps", []]];
	};
	if (count _customLayout == 0 && {_existing getOrDefault ["customLayout", createHashMap] isEqualType createHashMap}) then {
		private _existingLayout = _existing getOrDefault ["customLayout", createHashMap];
		if (count _existingLayout > 0) then {
			_user set ["customLayout", _existingLayout];
		};
	};
	_users set [_index, _user];
};

_data set ["users", _users];
_object setVariable [QGVAR(data), _data, true];
[_object] call FUNC(ensureAutoLoginUser);

if (!_loginRequired && {_object getVariable [QGVAR(poweredOn), true]}) then {
	[_object, "desktop"] call FUNC(setScreenState);
};

if !(GVAR(registeredUsers) isEqualType []) then {
	GVAR(registeredUsers) = [];
};

private _globalIndex = GVAR(registeredUsers) findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
if (_globalIndex < 0) then {
	GVAR(registeredUsers) pushBack _user;
} else {
	GVAR(registeredUsers) set [_globalIndex, _user];
};

["User", "Added or updated computer user", createHashMapFromArray [
	["object", _object],
	["username", _username],
	["email", _email],
	["theme", _theme],
	["scope", _scope],
	["disabledApps", _disabledApps],
	["userCountOnObject", count _users],
	["globalUserCount", count GVAR(registeredUsers)]
]] call FUNC(debugLog);

true
