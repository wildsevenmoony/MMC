#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Ensures a no-login computer uses its configured single direct user.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 *
 * Return Value:
 * Active auto-login user, or empty hashmap <HASHMAP>
 */

params [["_object", objNull, [objNull]]];

if (isNull _object) exitWith {createHashMap};

private _data = _object getVariable [QGVAR(data), createHashMap];
if (_data getOrDefault ["loginRequired", true]) exitWith {
	_object getVariable [QGVAR(activeUser), createHashMap]
};

private _users = (_data getOrDefault ["users", []]) select {_x isEqualType createHashMap};
private _preferredUsername = toLowerANSI (_data getOrDefault ["autoLoginUsername", ""]);
private _user = createHashMap;

if (_preferredUsername isNotEqualTo "") then {
	private _index = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _preferredUsername};
	if (_index >= 0) then {
		_user = _users select _index;
	};
};

if (count _user == 0) then {
	private _directUsers = _users select {(_x getOrDefault ["scope", "global"]) isEqualTo "direct"};
	if (_directUsers isNotEqualTo []) then {
		_user = _directUsers select 0;
		_data set ["autoLoginUsername", _user getOrDefault ["username", ""]];
		_object setVariable [QGVAR(data), _data, true];
	};
};

_object setVariable [QGVAR(activeUser), _user, true];
_user
