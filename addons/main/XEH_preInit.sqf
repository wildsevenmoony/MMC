#include "script_component.hpp"

/*
 * Author: Moony
 * Initializes CBA settings and shared state before mission start.
 */

GVAR(registeredComputers) = [];
GVAR(registeredUsers) = [];
GVAR(pendingGlobalUsers) = [];

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
	["Default Theme", "Used when a mission/user layout is set to Default."],
	["Moony's Magnificent Computers", "Player Profile"],
	[
		["dark", "light"],
		["Dark", "Light"],
		0
	],
	0
] call CBA_fnc_addSetting;
