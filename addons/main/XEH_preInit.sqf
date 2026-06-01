#include "script_component.hpp"

/*
 * Author: Moony
 * Initializes CBA settings and shared state before mission start.
 */

GVAR(registeredComputers) = [];

[
	QGVAR(profileLoginName),
	"EDITBOX",
	["Username", "Default MMC username. This defaults to your Arma profile name."],
	["Moony's Magnificent Computers", "Player Profile"],
	profileName,
	0
] call CBA_fnc_addSetting;

[
	QGVAR(profilePassword),
	"EDITBOX",
	["Password", "Default MMC password. Leave empty to log in with an empty password field."],
	["Moony's Magnificent Computers", "Player Profile"],
	"",
	0
] call CBA_fnc_addSetting;

[
	QGVAR(profileEmail),
	"EDITBOX",
	["E-Mail Address", "Default MMC email address for your user account."],
	["Moony's Magnificent Computers", "Player Profile"],
	format ["%1@mccsystems.com", profileName],
	0
] call CBA_fnc_addSetting;

[
	QGVAR(logoutOnClose),
	"CHECKBOX",
	["Logout When Closed", "If enabled, closing the computer dialog logs the current user out of that computer."],
	["Moony's Magnificent Computers", "Player Profile"],
	false,
	0
] call CBA_fnc_addSetting;

[
	QGVAR(profileTheme),
	"LIST",
	["Theme", "Client-side MMC desktop theme."],
	["Moony's Magnificent Computers", "Player Profile"],
	[
		["dark", "light", "user", "blufor", "opfor", "independent", "civilian"],
		["Dark", "Light", "User", "BLUFOR", "OPFOR", "Independent", "Civilian"],
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
