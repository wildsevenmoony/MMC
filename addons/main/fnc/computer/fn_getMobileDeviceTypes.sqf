#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Returns all predefined MMC mobile device item/object mappings.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Device definitions <ARRAY>
 */

[
	createHashMapFromArray [
		["id", "smartphone"],
		["itemClass", QGVAR(smartphone)],
		["objectClass", QGVAR(deviceSmartphone)],
		["label", "Smartphone"],
		["orientation", "vertical"],
		["icon", PATHTOF(img\icon_smartphone.paa)]
	],
	createHashMapFromArray [
		["id", "ruggedTabletBlack"],
		["itemClass", QGVAR(ruggedTabletBlack)],
		["objectClass", QGVAR(deviceRuggedTabletBlack)],
		["label", "Rugged Tablet (Black)"],
		["orientation", "horizontal"],
		["icon", PATHTOF(img\icon_rugged_tablet_black.paa)]
	],
	createHashMapFromArray [
		["id", "ruggedTabletGreen"],
		["itemClass", QGVAR(ruggedTabletGreen)],
		["objectClass", QGVAR(deviceRuggedTabletGreen)],
		["label", "Rugged Tablet (Green)"],
		["orientation", "horizontal"],
		["icon", PATHTOF(img\icon_rugged_tablet_green.paa)]
	],
	createHashMapFromArray [
		["id", "ruggedTabletSand"],
		["itemClass", QGVAR(ruggedTabletSand)],
		["objectClass", QGVAR(deviceRuggedTabletSand)],
		["label", "Rugged Tablet (Sand)"],
		["orientation", "horizontal"],
		["icon", PATHTOF(img\icon_rugged_tablet_sand.paa)]
	],
	createHashMapFromArray [
		["id", "tablet"],
		["itemClass", QGVAR(tablet)],
		["objectClass", QGVAR(deviceTablet)],
		["label", "Tablet"],
		["orientation", "horizontal"],
		["icon", PATHTOF(img\icon_tablet.paa)]
	]
]
