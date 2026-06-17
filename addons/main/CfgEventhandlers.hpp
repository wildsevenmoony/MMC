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

class Extended_Init_EventHandlers {
	class GVAR(deviceSmartphone) {
		class ADDON {
			init = "call MMC_fnc_registerDeviceObject";
		};
	};

	class GVAR(deviceRuggedTabletBlack) {
		class ADDON {
			init = "call MMC_fnc_registerDeviceObject";
		};
	};

	class GVAR(deviceRuggedTabletGreen) {
		class ADDON {
			init = "call MMC_fnc_registerDeviceObject";
		};
	};

	class GVAR(deviceRuggedTabletSand) {
		class ADDON {
			init = "call MMC_fnc_registerDeviceObject";
		};
	};

	class GVAR(deviceTablet) {
		class ADDON {
			init = "call MMC_fnc_registerDeviceObject";
		};
	};
};
