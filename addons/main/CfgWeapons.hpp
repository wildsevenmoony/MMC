/*
 * Author: Moony
 * Adds handheld MMC device inventory items.
 */

class CfgWeapons {
	class ACE_ItemCore;
	class CBA_MiscItem_ItemInfo;

	class GVAR(hackingTool): ACE_ItemCore {
		author = "Moony";
		displayName = "Intrusion Tool";
		descriptionShort = "Compact MMC security bypass device used for hacking computers and mobile devices.";
		model = "\A3\Structures_F_Heli\Items\Electronics\Tablet_01_F.p3d";
		picture = PATHTOF(img\icon_tablet.paa);
		scope = 2;

		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 6;
		};
	};

	class GVAR(smartphone): ACE_ItemCore {
		author = "Moony";
		displayName = "Smartphone";
		descriptionShort = "Handheld MMC mobile computer access device.";
		model = "\A3\Structures_F\Items\Electronics\MobilePhone_smart_F.p3d";
		picture = PATHTOF(img\icon_smartphone.paa);
		scope = 2;

		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 2;
		};
	};

	class GVAR(ruggedTabletBlack): ACE_ItemCore {
		author = "Moony";
		displayName = "Rugged Tablet (Black)";
		descriptionShort = "Rugged MMC mobile computer access tablet.";
		model = "\A3\Props_F_Exp_A\Military\Equipment\Tablet_02_F.p3d";
		picture = PATHTOF(img\icon_rugged_tablet_black.paa);
		hiddenSelections[] = {"Camo_1", "Camo_2"};
		hiddenSelectionsTextures[] = {
			"\A3\Structures_F_Heli\Items\Electronics\Data\Tablet_Screen_CO.paa",
			"\A3\Props_F_Enoch\Military\Camps\data\RuggedTablet_black_CO.paa"
		};
		hiddenSelectionsMaterials[] = {"\A3\Data_F\Lights\Lamp_lcd2.rvmat"};
		scope = 2;

		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 12;
		};
	};

	class GVAR(ruggedTabletGreen): ACE_ItemCore {
		author = "Moony";
		displayName = "Rugged Tablet (Green)";
		descriptionShort = "Rugged MMC mobile computer access tablet.";
		model = "\A3\Props_F_Exp_A\Military\Equipment\Tablet_02_F.p3d";
		picture = PATHTOF(img\icon_rugged_tablet_green.paa);
		hiddenSelections[] = {"Camo_1", "Camo_2"};
		hiddenSelectionsTextures[] = {
			"\A3\Structures_F_Heli\Items\Electronics\Data\Tablet_Screen_CO.paa",
			"\A3\Props_F_Exp_A\Military\Equipment\data\RuggedTablet_CO.paa"
		};
		hiddenSelectionsMaterials[] = {"\A3\Data_F\Lights\Lamp_lcd2.rvmat"};
		scope = 2;

		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 12;
		};
	};

	class GVAR(ruggedTabletSand): ACE_ItemCore {
		author = "Moony";
		displayName = "Rugged Tablet (Sand)";
		descriptionShort = "Rugged MMC mobile computer access tablet.";
		model = "\A3\Props_F_Exp_A\Military\Equipment\Tablet_02_F.p3d";
		picture = PATHTOF(img\icon_rugged_tablet_sand.paa);
		hiddenSelections[] = {"Camo_1", "Camo_2"};
		hiddenSelectionsTextures[] = {
			"\A3\Structures_F_Heli\Items\Electronics\Data\Tablet_Screen_CO.paa",
			"\A3\Props_F_Enoch\Military\Camps\data\RuggedTablet_Sand_CO.paa"
		};
		hiddenSelectionsMaterials[] = {"\A3\Data_F\Lights\Lamp_lcd2.rvmat"};
		scope = 2;

		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 12;
		};
	};

	class GVAR(tablet): ACE_ItemCore {
		author = "Moony";
		displayName = "Tablet";
		descriptionShort = "Tablet MMC mobile computer access device.";
		model = "\A3\Structures_F_Heli\Items\Electronics\Tablet_01_F.p3d";
		picture = PATHTOF(img\icon_tablet.paa);
		scope = 2;

		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 8;
		};
	};

	#include "CfgMobileDeviceIds.hpp"
};
