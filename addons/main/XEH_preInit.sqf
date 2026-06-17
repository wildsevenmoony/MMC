#include "script_component.hpp"

/*
 * Author: Moony
 * Initializes CBA settings and shared state before mission start.
 */

GVAR(registeredComputers) = [];
GVAR(registeredUsers) = [];
GVAR(pendingGlobalUsers) = [];
GVAR(mobileDevices) = createHashMap;
GVAR(mobileProfiles) = [];
GVAR(messengerMessages) = [];
GVAR(mobileOrientation) = "horizontal";
GVAR(mobileUniqueCounters) = createHashMap;
GVAR(debugEnabled) = false;

[
	QGVAR(debugEnabled),
	"CHECKBOX",
	["Debug Logging", "Writes detailed MMC diagnostics to the RPT. Enable this while testing module syncs, mobile profiles, mail delivery, or custom apps."],
	["Moony's Magnificent Computers", "Debug"],
	false,
	0
] call CBA_fnc_addSetting;

[
	QGVAR(messengerScope),
	"LIST",
	["Messenger Device Scope", "Controls which devices are listed in the Messenger app. Own side lists only matching-side devices; friendly sides also includes allied sides."],
	["Moony's Magnificent Computers", "Messenger"],
	[
		["ownSide", "friendly"],
		["Own Side", "Friendly Sides"],
		0
	],
	1
] call CBA_fnc_addSetting;

[
	QGVAR(messengerExcludeCivilians),
	"CHECKBOX",
	["Messenger Exclude Civilians", "When Messenger is allowed to show friendly-side devices, civilian devices are hidden from the contact list."],
	["Moony's Magnificent Computers", "Messenger"],
	true,
	1
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
	["Default Theme", "Used when a mission/user layout is set to Default."],
	["Moony's Magnificent Computers", "Player Profile"],
	[
		["dark", "light"],
		["Dark", "Light"],
		0
	],
	0
] call CBA_fnc_addSetting;
