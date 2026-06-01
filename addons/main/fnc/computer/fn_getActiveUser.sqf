#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Returns the currently logged-in user for an MMC computer.
 */

params [["_object", objNull, [objNull]]];

if (isNull _object) exitWith {createHashMap};

private _user = _object getVariable [QGVAR(activeUser), createHashMap];
if !(_user isEqualType createHashMap) exitWith {createHashMap};
_user
