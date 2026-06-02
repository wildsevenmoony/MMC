/*
 * Author: Moony
 * Declares the main MMC addon patch, dependencies, and metadata.
 */

class CfgPatches {
	class ADDON {
		name = "Moony's Magnificent Computers";
		author = "Moony";
		requiredAddons[] = {
			"mmb_main",
			"ace_interact_menu",
			"CBA_Main",
			"cba_events",
			"cba_jr",
			"cba_settings",
			"cba_ui",
			"zen_main",
			"zen_modules"
		};
		requiredVersion = 2.14;
		units[] = {
			QGVAR(registerComputer),
			QGVAR(addUser),
			QGVAR(addTextFile),
			QGVAR(addPicture),
			QGVAR(modifyDesktop),
			QGVAR(addMail)
		};
		weapons[] = {};
	};
};
