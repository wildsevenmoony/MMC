#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Modifies a computer default desktop or one user's desktop text.
 */

params [
	["_object", objNull, [objNull]],
	["_username", "", [""]],
	["_title", "Welcome", [""]],
	["_content", "Select an app on the left.", [""]],
	["_align", "left", [""]],
	["_script", "", [""]]
];

if (isNull _object) exitWith {false};

private _data = _object getVariable [QGVAR(data), [createHashMap] call FUNC(createDefaultData)];

if (_username isEqualTo "") exitWith {
	_data set ["desktopTitle", _title];
	_data set ["desktopContent", _content];
	_data set ["desktopAlign", _align];
	_data set ["desktopScript", _script];
	_object setVariable [QGVAR(data), _data, true];
	true
};

private _users = _data getOrDefault ["users", []];
private _lookup = toLowerANSI _username;
private _index = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
if (_index < 0) exitWith {false};

private _user = _users select _index;
_user set ["desktopTitle", _title];
_user set ["desktopContent", _content];
_user set ["desktopAlign", _align];
_user set ["desktopScript", _script];
_users set [_index, _user];
_data set ["users", _users];
_object setVariable [QGVAR(data), _data, true];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (!isNull _display && {_object isEqualTo (_display getVariable [QGVAR(computer), objNull])}) then {
	_display setVariable [QGVAR(data), _data];
	if ((_object getVariable [QGVAR(activeUser), createHashMap]) getOrDefault ["username", ""] isEqualTo _username) then {
		_object setVariable [QGVAR(activeUser), _user, true];
		_display setVariable [QGVAR(activeUser), _user];
	};
};

true
