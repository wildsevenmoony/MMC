#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Makes a user's email unique by transforming only the local part before @.
 *
 * Arguments:
 * 0: Requested email address <STRING>
 * 1: Username allowed to keep the same address while updating <STRING>
 *
 * Return Value:
 * Unique email address <STRING>
 */

params [
	["_email", "", [""]],
	["_username", "", [""]]
];

if (_email isEqualTo "") exitWith {""};

private _parts = _email splitString "@";
if ((count _parts) < 2) exitWith {_email};

private _local = _parts select 0;
private _domain = (_parts select [1]) joinString "@";
private _usernameLookup = toLowerANSI _username;
private _used = [];

{
	if (toLowerANSI (_x getOrDefault ["username", ""]) isNotEqualTo _usernameLookup) then {
		private _existing = toLowerANSI (_x getOrDefault ["email", ""]);
		if (_existing isNotEqualTo "") then {
			_used pushBackUnique _existing;
		};
	};
} forEach (GVAR(registeredUsers) select {_x isEqualType createHashMap});

private _candidate = _email;
private _suffix = 1;
while {toLowerANSI _candidate in _used && {_suffix < 100}} do {
	_suffix = _suffix + 1;
	private _pattern = _suffix mod 3;
	_candidate = switch (_pattern) do {
		case 0: {format ["%1%2@%3", _local, _suffix, _domain]};
		case 1: {format ["%1.%2@%3", _local, _suffix, _domain]};
		default {format ["%1_%2@%3", _local, _suffix, _domain]};
	};
};

_candidate
