#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Finds a registered user by email address.
 */

params [["_email", "", [""]]];

private _lookup = toLowerANSI ([_email] call CBA_fnc_trim);
private _result = createHashMap;
private _registeredUsers = ([] call FUNC(getRegisteredUsers)) select {_x isEqualType createHashMap};
private _debugCandidates = [];

{
	private _primary = toLowerANSI ([(_x getOrDefault ["email", ""])] call CBA_fnc_trim);
	private _aliases = _x getOrDefault ["emailAliases", []];
	if !(_aliases isEqualType []) then {
		_aliases = [];
	};
	_debugCandidates pushBack createHashMapFromArray [
		["username", _x getOrDefault ["username", ""]],
		["email", _primary],
		["aliases", _aliases]
	];
	private _aliasMatch = _aliases findIf {toLowerANSI ([_x] call CBA_fnc_trim) isEqualTo _lookup} >= 0;
	if (_primary isEqualTo _lookup || _aliasMatch) exitWith {
		_result = _x;
	};
} forEach _registeredUsers;

["Mail", "Email lookup", createHashMapFromArray [
	["lookup", _lookup],
	["matched", count _result > 0],
	["matchedUser", _result getOrDefault ["username", ""]],
	["registeredUserCount", count _registeredUsers],
	["candidates", _debugCandidates]
]] call FUNC(debugLog);

_result
