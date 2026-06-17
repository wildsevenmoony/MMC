#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds or replaces e-mail aliases on a user stored on a computer object.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: Username <STRING>
 * 2: Aliases <ARRAY>
 * 3: Replace existing aliases <BOOL, default: false>
 *
 * Return Value:
 * Updated <BOOL>
 */

params [
	["_computer", objNull, [objNull]],
	["_username", "", [""]],
	["_aliases", [], [[]]],
	["_replace", false, [false]]
];

if (isNull _computer || {_username isEqualTo ""}) exitWith {false};

private _normalizedAliases = [];
{
	private _alias = [_x] call CBA_fnc_trim;
	if (_alias isNotEqualTo "") then {
		_normalizedAliases pushBackUnique _alias;
	};
} forEach _aliases;

private _data = _computer getVariable [QGVAR(data), createHashMap];
private _users = _data getOrDefault ["users", []];
private _lookup = toLowerANSI _username;
private _index = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
if (_index < 0) exitWith {false};

private _user = _users select _index;
private _existing = if (_replace) then {[]} else {_user getOrDefault ["emailAliases", []]};
{
	_existing pushBackUnique _x;
} forEach _normalizedAliases;
_user set ["emailAliases", _existing];
_users set [_index, _user];
_data set ["users", _users];
_computer setVariable [QGVAR(data), _data, true];

private _registeredIndex = GVAR(registeredUsers) findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
if (_registeredIndex >= 0) then {
	GVAR(registeredUsers) set [_registeredIndex, _user];
};

true
