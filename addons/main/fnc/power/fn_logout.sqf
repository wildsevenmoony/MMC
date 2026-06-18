#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Logs the active user out of an MMC computer.
 */

params [["_object", objNull, [objNull]]];

if (isNull _object) exitWith {false};
private _data = _object getVariable [QGVAR(data), createHashMap];
if !(_data getOrDefault ["loginRequired", true]) exitWith {
	[_object] call FUNC(ensureAutoLoginUser);
	true
};

_object setVariable [QGVAR(activeUser), createHashMap, true];
true
