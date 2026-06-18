#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Returns predefined item classnames that grant access to the MMC mobile device.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Mobile access item classnames <ARRAY>
 */

([] call FUNC(getMobileDeviceTypes)) apply {_x getOrDefault ["itemClass", ""]}
