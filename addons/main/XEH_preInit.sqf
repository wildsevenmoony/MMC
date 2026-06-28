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
GVAR(notificationSoundEnabled) = true;
GVAR(notesAutosaveEnabled) = true;
GVAR(mailAddressBookIncludeFriendlySides) = true;
GVAR(mailAddressBookExcludeCivilians) = true;
GVAR(hackingEnabled) = true;
GVAR(hackingRequiredItem) = QGVAR(hackingTool);
GVAR(hackingDuration) = 60;
GVAR(hackingAttempts) = 4;
GVAR(hackingWordCount) = 21;

[
	QGVAR(debugEnabled),
	"CHECKBOX",
	["Debug Logging", "Writes detailed MMC diagnostics to the RPT. Enable this while testing module syncs, mobile profiles, mail delivery, or custom apps."],
	["Moony's Magnificent Computers", "Debug"],
	false,
	0
] call CBA_fnc_addSetting;

[
	QGVAR(hackingEnabled),
	"CHECKBOX",
	["Enable Hacking", "Allows players carrying the required intrusion item to attempt hacking on MMC login and mobile lock screens."],
	["Moony's Magnificent Computers", "Hacking"],
	true,
	1
] call CBA_fnc_addSetting;

[
	QGVAR(hackingRequiredItem),
	"EDITBOX",
	["Required Hacking Item", "Inventory class required to start a hacking attempt. Leave empty to allow hacking without a special item."],
	["Moony's Magnificent Computers", "Hacking"],
	QGVAR(hackingTool),
	1
] call CBA_fnc_addSetting;

[
	QGVAR(hackingDuration),
	"SLIDER",
	["Hacking Duration", "Seconds spent running the security bypass before the word puzzle opens."],
	["Moony's Magnificent Computers", "Hacking"],
	[5, 300, 60, 0],
	1
] call CBA_fnc_addSetting;

[
	QGVAR(hackingAttempts),
	"SLIDER",
	["Hacking Attempts", "How many wrong word guesses are allowed before the hacking attempt fails."],
	["Moony's Magnificent Computers", "Hacking"],
	[1, 10, 4, 0],
	1
] call CBA_fnc_addSetting;

[
	QGVAR(hackingWordCount),
	"SLIDER",
	["Hacking Word Count", "How many candidate words are shown in the hacking puzzle."],
	["Moony's Magnificent Computers", "Hacking"],
	[6, 36, 21, 0],
	1
] call CBA_fnc_addSetting;

[
	QGVAR(mobileLockCode),
	"EDITBOX",
	["Mobile Lock Code", "Numeric unlock code used for personal inventory or arsenal mobile devices when no mission mobile profile sets one. Leave empty to let any entry, including no entry, unlock the device."],
	["Moony's Magnificent Computers", "Mobile Devices"],
	"",
	0
] call CBA_fnc_addSetting;

[
	QGVAR(notesAutosaveEnabled),
	"CHECKBOX",
	["Notes Autosave", "Automatically saves the currently edited note shortly after typing. Disable this if notes should only be saved when pressing Save."],
	["Moony's Magnificent Computers", "Notes"],
	true,
	0
] call CBA_fnc_addSetting;

[
	QGVAR(notificationSoundEnabled),
	"CHECKBOX",
	["Notification Sound", "Play MMC notification sounds when mail or Messenger messages arrive. ACE text notifications still appear when this is disabled."],
	["Moony's Magnificent Computers", "Notifications"],
	true,
	0
] call CBA_fnc_addSetting;

[
	QGVAR(mailAddressBookIncludeFriendlySides),
	"CHECKBOX",
	["Address Book Include Friendly Sides", "Automatically list player mail addresses from friendly sides in the Mail address book. Matching-side players are always listed."],
	["Moony's Magnificent Computers", "Mail"],
	true,
	1
] call CBA_fnc_addSetting;

[
	QGVAR(mailAddressBookExcludeCivilians),
	"CHECKBOX",
	["Address Book Exclude Civilians", "Hide civilian player mail addresses when the current user is not civilian."],
	["Moony's Magnificent Computers", "Mail"],
	true,
	1
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
