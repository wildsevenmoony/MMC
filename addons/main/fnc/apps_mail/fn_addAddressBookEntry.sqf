#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds or updates an address book entry on a user hashmap.
 *
 * Arguments:
 * 0: User <HASHMAP>
 * 1: Display name <STRING>
 * 2: E-mail address <STRING>
 *
 * Return Value:
 * Added <BOOL>
 */

params [
	["_user", createHashMap, [createHashMap]],
	["_name", "", [""]],
	["_email", "", [""]]
];

_name = [_name] call CBA_fnc_trim;
_email = [_email] call CBA_fnc_trim;
if (_email isEqualTo "" || {_email find "@" < 0}) exitWith {false};
if (_name isEqualTo "") then {
	_name = (_email splitString "@") param [0, _email];
};

private _entries = [_user getOrDefault ["addressBook", []]] call FUNC(normalizeAddressBook);
private _lookup = toLowerANSI _email;
private _entry = createHashMapFromArray [
	["name", _name],
	["email", _email]
];
private _index = _entries findIf {toLowerANSI (_x getOrDefault ["email", ""]) isEqualTo _lookup};
if (_index < 0) then {
	_entries pushBack _entry;
} else {
	_entries set [_index, _entry];
};
_user set ["addressBook", _entries];

true
