#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Returns the currently logged-in user for an MMC computer.
 */

params [["_object", objNull, [objNull]]];

if (isNull _object) exitWith {createHashMap};

private _user = _object getVariable [QGVAR(activeUser), createHashMap];
if !(_user isEqualType createHashMap) exitWith {createHashMap};

private _data = _object getVariable [QGVAR(data), createHashMap];

private _username = _user getOrDefault ["username", ""];
if (_username isNotEqualTo "") then {
	private _users = _data getOrDefault ["users", []];
	private _index = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username};
	if (_index >= 0) then {
		_user = _users select _index;
		_object setVariable [QGVAR(activeUser), _user, true];
	};
};

if ((_user getOrDefault ["username", ""]) isEqualTo "" && {!(_data getOrDefault ["loginRequired", true])}) then {
	_user = [_object] call FUNC(ensureAutoLoginUser);
};

_user
