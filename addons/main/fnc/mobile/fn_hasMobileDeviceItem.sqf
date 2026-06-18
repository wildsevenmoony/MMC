#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Checks whether the local player may open their MMC mobile device.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Can open mobile device <BOOL>
 */

if (!hasInterface || {isNull player}) exitWith {false};

([] call FUNC(getMobileInventoryDevices)) isNotEqualTo []
