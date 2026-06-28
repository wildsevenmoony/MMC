#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Starts the word puzzle against one discovered desktop account.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: User account <HASHMAP>
 *
 * Return Value:
 * Puzzle started <BOOL>
 */

params [
	["_display", displayNull, [displayNull]],
	["_user", createHashMap, [createHashMap]]
];

if (isNull _display || {count _user == 0}) exitWith {false};

private _computer = _display getVariable [QGVAR(computer), objNull];
if (isNull _computer) exitWith {false};

private _username = _user getOrDefault ["username", ""];
if (_username isEqualTo "") exitWith {false};

["Hacking", "Starting account crack", createHashMapFromArray [
	["username", _username]
]] call FUNC(debugLog);

[_display, "account", _user] call FUNC(hackingStart)
