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
			"A3_Props_F_Enoch_Military_Camps",
			"A3_Props_F_Exp_A_Military_Equipment",
			"A3_Structures_F_Heli_Items_Electronics",
			"A3_Structures_F_Items_Electronics",
			"ace_common",
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
			QGVAR(mobileProfile),
			QGVAR(assignMobileProfile),
			QGVAR(addUser),
			QGVAR(customLayout),
			QGVAR(addTextFile),
			QGVAR(addPicture),
			QGVAR(addAudio),
			QGVAR(modifyDesktop),
			QGVAR(addMail),
			QGVAR(deviceSmartphone),
			QGVAR(deviceRuggedTabletBlack),
			QGVAR(deviceRuggedTabletGreen),
			QGVAR(deviceRuggedTabletSand),
			QGVAR(deviceTablet)
		};
		weapons[] = {
			QGVAR(hackingTool),
			QGVAR(smartphone),
			QGVAR(ruggedTabletBlack),
			QGVAR(ruggedTabletGreen),
			QGVAR(ruggedTabletSand),
			QGVAR(tablet)
		};
	};
};
