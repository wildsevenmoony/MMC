/*
 * Author: Moony
 * Registers CBA extended event handlers for MMC.
 */

class Extended_PreInit_EventHandlers {
	class ADDON {
		init = "call compile preprocessFileLineNumbers '\z\mmc\addons\main\XEH_preInit.sqf'";
	};
};

class Extended_PostInit_EventHandlers {
	class ADDON {
		init = "call compile preprocessFileLineNumbers '\z\mmc\addons\main\XEH_postInit.sqf'";
	};
};
