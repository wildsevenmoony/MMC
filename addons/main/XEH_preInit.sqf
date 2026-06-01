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
	["Moony's Magnificent Computer", "Player Profile"],
	profileName,
	0
] call CBA_fnc_addSetting;

[
	QGVAR(profilePassword),
	"EDITBOX",
	["Password", "Default password for future login screens. The current desktop shell does not enforce this yet."],
	["Moony's Magnificent Computer", "Player Profile"],
	"",
	0
] call CBA_fnc_addSetting;

[
	QGVAR(profileTheme),
	"LIST",
	["Theme", "Client-side MMC desktop theme."],
	["Moony's Magnificent Computer", "Player Profile"],
	[
		["dark", "light"],
		["Dark", "Light"],
		0
	],
	0
] call CBA_fnc_addSetting;

[
	QGVAR(useLayoutColors),
	"CHECKBOX",
	["Use Layout Colors", "Use your Arma interface color for MMC highlights and buttons."],
	["Moony's Magnificent Computer", "Player Profile"],
	true,
	0
] call CBA_fnc_addSetting;

[
	QGVAR(profileBackground),
	"LIST",
	["Desktop Background", "Client-side preferred MMC desktop background."],
	["Moony's Magnificent Computer", "Player Profile"],
	[
		["default_dark", "default_light", "nato", "csat", "aaf", "fia", "custom"],
		["Default Dark", "Default Light", "NATO", "CSAT", "AAF", "FIA", "Custom Texture Path"],
		0
	],
	0
] call CBA_fnc_addSetting;

[
	QGVAR(profileBackgroundCustom),
	"EDITBOX",
	["Custom Background Texture", "Optional texture path used when Desktop Background is set to Custom, or when a computer defines no background."],
	["Moony's Magnificent Computer", "Player Profile"],
	"",
	0
] call CBA_fnc_addSetting;
