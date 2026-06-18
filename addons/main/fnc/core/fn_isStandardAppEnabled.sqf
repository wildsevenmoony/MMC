#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Checks whether a standard app is available for the computer and active user.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: App id <STRING>
 * 2: User <HASHMAP, default: active user>
 *
 * Return Value:
 * Enabled <BOOL>
 */

params [
	["_computer", objNull, [objNull]],
	["_app", "", [""]],
	["_user", createHashMap, [createHashMap]]
];

if (isNull _computer) exitWith {false};

private _ids = [_app] call FUNC(normalizeStandardAppIds);
if (_ids isEqualTo []) exitWith {true};
private _id = _ids select 0;

private _data = _computer getVariable [QGVAR(data), createHashMap];
private _computerDisabled = [_data getOrDefault ["disabledApps", []]] call FUNC(normalizeStandardAppIds);
if (_id in _computerDisabled) exitWith {false};

if (count _user == 0) then {
	_user = [_computer] call FUNC(getActiveUser);
};

private _userDisabled = [_user getOrDefault ["disabledApps", []]] call FUNC(normalizeStandardAppIds);
!(_id in _userDisabled)
