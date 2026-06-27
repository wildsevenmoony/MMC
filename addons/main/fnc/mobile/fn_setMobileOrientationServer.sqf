#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Stores the last used mobile display orientation on the server-owned device.
 *
 * Arguments:
 * 0: Mobile computer logic <OBJECT>
 * 1: Orientation ("horizontal" or "vertical") <STRING>
 *
 * Return Value:
 * Orientation stored <BOOL>
 */

params [
	["_device", objNull, [objNull]],
	["_orientation", "horizontal", [""]]
];

if (!isServer || {isNull _device}) exitWith {false};
if !(_orientation in ["horizontal", "vertical"]) exitWith {false};

_device setVariable [QGVAR(mobileDefaultOrientation), _orientation, true];

true
