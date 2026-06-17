#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Converts an MMC theme or layout preset into a Messenger side string.
 *
 * Arguments:
 * 0: Theme or preset name <STRING>
 * 1: Optional layout config used when theme is "default" <HASHMAP, default: createHashMap>
 *
 * Return Value:
 * Messenger side string ("west", "east", "guer", "civ", "hidden" or "") <STRING>
 */

params [
	["_theme", "", [""]],
	["_layout", createHashMap, [createHashMap]]
];

private _themeKey = toLowerANSI _theme;
if (_themeKey in ["", "default"] && {count _layout > 0}) then {
	_themeKey = toLowerANSI (_layout getOrDefault ["preset", ""]);
};

switch (_themeKey) do {
	case "nato";
	case "blufor": {"west"};
	case "csat";
	case "opfor": {"east"};
	case "aaf";
	case "independent": {"guer"};
	case "civilian";
	case "civ": {"civ"};
	case "hidden": {"hidden"};
	default {""};
}
