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
	QGVAR(profileBackground),
	"EDITBOX",
	["Background Texture", "Optional texture path for the player's preferred MMC desktop background."],
	["Moony's Magnificent Computer", "Player Profile"],
	"",
	0
] call CBA_fnc_addSetting;
