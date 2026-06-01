/*
 * Author: Moony
 * Declares the main MMC addon patch, dependencies, and metadata.
 */

class CfgPatches {
	class ADDON {
		name = "Moonys Magnificent Computer";
		author = "Moony";
		requiredAddons[] = {
			"ace_interact_menu",
			"CBA_Main",
			"cba_events",
			"cba_jr",
			"cba_settings",
			"cba_ui"
		};
		requiredVersion = 1.56;
		units[] = {};
		weapons[] = {};
	};
};
