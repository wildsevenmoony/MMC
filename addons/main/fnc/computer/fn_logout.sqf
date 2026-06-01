#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Logs the active user out of an MMC computer.
 */

params [["_object", objNull, [objNull]]];

if (isNull _object) exitWith {false};
_object setVariable [QGVAR(activeUser), createHashMap, true];
true
