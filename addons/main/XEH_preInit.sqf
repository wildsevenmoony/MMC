#include "script_component.hpp"

/*
 * Author: Moony
 * Initializes CBA settings and shared state before mission start.
 */

GVAR(registeredComputers) = [];

[
	QGVAR(profileLoginName),
	"EDITBOX",
	["Login Name", "Default login name shown inside MMC computers."],
	["Moony's Magnificent Computers", "Player Profile"],
	profileName,
	0
] call CBA_fnc_addSetting;

[
	QGVAR(profilePassword),
	"EDITBOX",
	["Password", "Default password for future login screens. The current desktop shell does not enforce this yet."],
	["Moony's Magnificent Computers", "Player Profile"],
	"",
	0
] call CBA_fnc_addSetting;

[
	QGVAR(profileTheme),
	"LIST",
	["Theme", "Client-side MMC desktop theme."],
	["Moony's Magnificent Computers", "Player Profile"],
	[
		["dark", "light", "user"],
		["Dark", "Light", "User"],
		0
	],
	0
] call CBA_fnc_addSetting;

[
	QGVAR(profileBackground),
	"LIST",
	["Desktop Background", "Client-side preferred MMC desktop background."],
	["Moony's Magnificent Computers", "Player Profile"],
	[
		["default_dark", "default_light", "nato", "csat", "aaf", "fia"],
		["Default Dark", "Default Light", "NATO", "CSAT", "AAF", "FIA"],
		0
	],
	0
] call CBA_fnc_addSetting;
