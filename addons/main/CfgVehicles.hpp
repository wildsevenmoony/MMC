/*
 * Author: Moony
 * Eden and Zeus module classes for configuring MMC computers.
 */

#define MMC_DEVICE_ATTRIBUTES(DEFAULT_SYSTEM,DEFAULT_USER,DEFAULT_EMAIL) \
	class Attributes { \
		class GVAR(poweredOn) { \
			property = QGVAR(poweredOn); \
			displayName = "Starts Powered On"; \
			control = "Checkbox"; \
			typeName = "BOOL"; \
			defaultValue = "true"; \
			expression = "_this setVariable ['%s', _value, true];"; \
		}; \
		class GVAR(loginRequired) { \
			property = QGVAR(loginRequired); \
			displayName = "Login Screen"; \
			tooltip = "If disabled, this device opens directly to the desktop of the configured user."; \
			control = "Checkbox"; \
			typeName = "BOOL"; \
			defaultValue = "false"; \
			expression = "_this setVariable ['%s', _value, true];"; \
		}; \
		class GVAR(closedSystem) { \
			property = QGVAR(closedSystem); \
			displayName = "Closed System"; \
			tooltip = "Closed systems only allow users explicitly configured on this device."; \
			control = "Checkbox"; \
			typeName = "BOOL"; \
			defaultValue = "true"; \
			expression = "_this setVariable ['%s', _value, true];"; \
		}; \
		class GVAR(systemName) { \
			property = QGVAR(systemName); \
			displayName = "System Name"; \
			control = "Edit"; \
			typeName = "STRING"; \
			defaultValue = DEFAULT_SYSTEM; \
			expression = "_this setVariable ['%s', _value, true];"; \
		}; \
		class GVAR(userName) { \
			property = QGVAR(userName); \
			displayName = "Username"; \
			control = "Edit"; \
			typeName = "STRING"; \
			defaultValue = DEFAULT_USER; \
			expression = "_this setVariable ['%s', _value, true];"; \
		}; \
		class GVAR(userPassword) { \
			property = QGVAR(userPassword); \
			displayName = "Password"; \
			tooltip = "Leave empty to allow login with an empty password field."; \
			control = "Edit"; \
			typeName = "STRING"; \
			defaultValue = "''"; \
			expression = "_this setVariable ['%s', _value, true];"; \
		}; \
		class GVAR(mobileLockCode) { \
			property = QGVAR(mobileLockCode); \
			displayName = "Lock Code"; \
			tooltip = "Numeric code required on the mobile lock screen. Leave empty to let any entry, including no entry, unlock the device."; \
			control = "Edit"; \
			typeName = "STRING"; \
			defaultValue = "''"; \
			expression = "_this setVariable ['%s', _value, true];"; \
		}; \
		class GVAR(userEmail) { \
			property = QGVAR(userEmail); \
			displayName = "E-Mail Address"; \
			tooltip = "Mail addressed to this value appears in this device user's inbox."; \
			control = "Edit"; \
			typeName = "STRING"; \
			defaultValue = DEFAULT_EMAIL; \
			expression = "_this setVariable ['%s', _value, true];"; \
		}; \
		class GVAR(messengerName) { \
			property = QGVAR(messengerName); \
			displayName = "Messenger Username"; \
			tooltip = "Display name shown in the Messenger app. Leave empty to use the configured username."; \
			control = "Edit"; \
			typeName = "STRING"; \
			defaultValue = "''"; \
			expression = "_this setVariable ['%s', _value, true];"; \
		}; \
		class GVAR(messengerSide) { \
			property = QGVAR(messengerSide); \
			displayName = "Messenger Side"; \
			tooltip = "Side used by the Messenger app when listing devices. Leave on None to hide this placed device from side-filtered contact lists."; \
			control = "Combo"; \
			typeName = "STRING"; \
			defaultValue = "''"; \
			expression = "_this setVariable ['%s', _value, true];"; \
			class Values { \
				class None {name = "None"; value = "";}; \
				class BLUFOR {name = "BLUFOR"; value = "west";}; \
				class OPFOR {name = "OPFOR"; value = "east";}; \
				class Independent {name = "Independent"; value = "guer";}; \
				class Civilian {name = "Civilian"; value = "civ";}; \
			}; \
		}; \
		class GVAR(userTheme) { \
			property = QGVAR(userTheme); \
			displayName = "Theme"; \
			tooltip = "Preset layout and desktop background for this device user. Default uses the client's CBA Default Theme."; \
			control = "Combo"; \
			typeName = "STRING"; \
			defaultValue = "'default'"; \
			expression = "_this setVariable ['%s', _value, true];"; \
			class Values { \
				class Default {name = "Default"; value = "default";}; \
				class NATO {name = "NATO"; value = "nato";}; \
				class CSAT {name = "CSAT"; value = "csat";}; \
				class AAF {name = "AAF"; value = "aaf";}; \
			}; \
		}; \
		class GVAR(appFilesEnabled) { \
			property = QGVAR(appFilesEnabled); \
			displayName = "Files App"; \
			tooltip = "If disabled, the Files app is hidden on this device."; \
			control = "Checkbox"; \
			typeName = "BOOL"; \
			defaultValue = "true"; \
			expression = "_this setVariable ['%s', _value, true];"; \
		}; \
		class GVAR(appMailEnabled) { \
			property = QGVAR(appMailEnabled); \
			displayName = "Mail App"; \
			tooltip = "If disabled, the Mail app is hidden on this device."; \
			control = "Checkbox"; \
			typeName = "BOOL"; \
			defaultValue = "true"; \
			expression = "_this setVariable ['%s', _value, true];"; \
		}; \
		class GVAR(appMessagesEnabled) { \
			property = QGVAR(appMessagesEnabled); \
			displayName = "Messenger App"; \
			tooltip = "If disabled, the Messenger app is hidden on this device."; \
			control = "Checkbox"; \
			typeName = "BOOL"; \
			defaultValue = "true"; \
			expression = "_this setVariable ['%s', _value, true];"; \
		}; \
		class GVAR(appNotesEnabled) { \
			property = QGVAR(appNotesEnabled); \
			displayName = "Notes App"; \
			tooltip = "If disabled, the Notes app is hidden on this device."; \
			control = "Checkbox"; \
			typeName = "BOOL"; \
			defaultValue = "true"; \
			expression = "_this setVariable ['%s', _value, true];"; \
		}; \
	}

class CfgVehicles {
	class Land_MobilePhone_smart_F;
	class Land_Tablet_01_F;
	class Land_Tablet_02_F;
	class Land_Tablet_02_black_F;
	class Land_Tablet_02_sand_F;
	class Logic;
	class Module_F: Logic {
		class AttributesBase {
			class Checkbox;
			class Combo;
			class Edit;
			class ModuleDescription;
		};
		class ModuleDescription;
	};

	class GVAR(deviceSmartphone): Land_MobilePhone_smart_F {
		author = "Moony";
		displayName = "MMC Smartphone";
		editorCategory = "EdCat_Things";
		editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\Land_MobilePhone_smart_F.jpg";
		editorSubcategory = QGVAR(Devices);
		scope = 2;
		scopeCurator = 2;
		vehicleClass = "Items";

		MMC_DEVICE_ATTRIBUTES("'MMC Smartphone'","'operator'","'operator@mmcsystems.com'");
	};

	class GVAR(deviceRuggedTabletBlack): Land_Tablet_02_black_F {
		author = "Moony";
		displayName = "MMC Rugged Tablet (Black)";
		editorCategory = "EdCat_Things";
		editorPreview = "\A3\EditorPreviews_F_Enoch\Data\CfgVehicles\Land_Tablet_02_black_F.jpg";
		editorSubcategory = QGVAR(Devices);
		scope = 2;
		scopeCurator = 2;
		vehicleClass = "Items";

		MMC_DEVICE_ATTRIBUTES("'MMC Rugged Tablet'","'operator'","'operator@mmcsystems.com'");
	};

	class GVAR(deviceRuggedTabletGreen): Land_Tablet_02_F {
		author = "Moony";
		displayName = "MMC Rugged Tablet (Green)";
		editorCategory = "EdCat_Things";
		editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\Land_Tablet_02_F.jpg";
		editorSubcategory = QGVAR(Devices);
		scope = 2;
		scopeCurator = 2;
		vehicleClass = "Items";

		MMC_DEVICE_ATTRIBUTES("'MMC Rugged Tablet'","'operator'","'operator@mmcsystems.com'");
	};

	class GVAR(deviceRuggedTabletSand): Land_Tablet_02_sand_F {
		author = "Moony";
		displayName = "MMC Rugged Tablet (Sand)";
		editorCategory = "EdCat_Things";
		editorPreview = "\A3\EditorPreviews_F_Enoch\Data\CfgVehicles\Land_Tablet_02_sand_F.jpg";
		editorSubcategory = QGVAR(Devices);
		scope = 2;
		scopeCurator = 2;
		vehicleClass = "Items";

		MMC_DEVICE_ATTRIBUTES("'MMC Rugged Tablet'","'operator'","'operator@mmcsystems.com'");
	};

	class GVAR(deviceTablet): Land_Tablet_01_F {
		author = "Moony";
		displayName = "MMC Tablet";
		editorCategory = "EdCat_Things";
		editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\Land_Tablet_01_F.jpg";
		editorSubcategory = QGVAR(Devices);
		scope = 2;
		scopeCurator = 2;
		vehicleClass = "Items";

		MMC_DEVICE_ATTRIBUTES("'MMC Tablet'","'operator'","'operator@mmcsystems.com'");
	};

	class GVAR(registerComputer): Module_F {
		category = QGVAR(Modules);
		displayName = "Register Computer";
		function = QFUNC(registerComputerModule);
		functionPriority = 10;
		isDisposable = 0;
		is3DEN = 1;
		isGlobal = 0;
		isTriggerActivated = 0;
		scope = 2;

		class Attributes: AttributesBase {
			class GVAR(poweredOn): Checkbox {
				property = QGVAR(poweredOn);
				displayName = "Starts Powered On";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(loginRequired): Checkbox {
				property = QGVAR(loginRequired);
				displayName = "Login Screen";
				tooltip = "If disabled, the computer automatically opens the desktop of the first directly synced Add User module. Additional direct users are ignored for this computer.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(closedSystem): Checkbox {
				property = QGVAR(closedSystem);
				displayName = "Closed System";
				tooltip = "Closed systems only allow users explicitly added to this computer. Open systems can use globally registered mission users.";
				typeName = "BOOL";
				defaultValue = "false";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(systemName): Edit {
				property = QGVAR(systemName);
				displayName = "System Name";
				typeName = "STRING";
				defaultValue = "'MMC Workstation'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appFilesEnabled): Checkbox {
				property = QGVAR(appFilesEnabled);
				displayName = "Files App";
				tooltip = "If disabled, the Files app is hidden for every user on this computer.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appMailEnabled): Checkbox {
				property = QGVAR(appMailEnabled);
				displayName = "Mail App";
				tooltip = "If disabled, the Mail app is hidden for every user on this computer.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appMessagesEnabled): Checkbox {
				property = QGVAR(appMessagesEnabled);
				displayName = "Messenger App";
				tooltip = "If disabled, the Messenger app is hidden for every user on this computer.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appNotesEnabled): Checkbox {
				property = QGVAR(appNotesEnabled);
				displayName = "Notes App";
				tooltip = "If disabled, the Notes app is hidden for every user on this computer.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Sync any object to this module to make it an MMC computer. Optionally sync Add User modules for direct computer users.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise any laptop, PC, object, or Add User module to this module."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {"AnyStaticObject", "AnyVehicle", QGVAR(addUser)};
			};
		};
	};

	class GVAR(mobileProfile): Module_F {
		category = QGVAR(Modules);
		displayName = "Mobile: Profile";
		function = QFUNC(mobileProfileModule);
		functionPriority = 20;
		isDisposable = 0;
		is3DEN = 1;
		isGlobal = 0;
		isTriggerActivated = 0;
		scope = 2;

		class Attributes: AttributesBase {
			class GVAR(mobileProfileMatchingCategory) {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = "Profile Matching";
				description = "";
			};

			class GVAR(mobileProfileId): Edit {
				property = QGVAR(mobileProfileId);
				displayName = "Profile ID";
				tooltip = "Unique script-safe profile id. If another profile uses the same id, the later one replaces it.";
				typeName = "STRING";
				defaultValue = "'mobile_profile'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileProfilePriority): Edit {
				property = QGVAR(mobileProfilePriority);
				displayName = "Priority";
				tooltip = "Profiles stack from low to high priority. Use higher values for more specific role or UID profiles.";
				typeName = "NUMBER";
				defaultValue = "0";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileProfileSource): Combo {
				property = QGVAR(mobileProfileSource);
				displayName = "Device Source";
				tooltip = "Personal means arsenal/inventory devices. Picked Up means physical MMC devices picked up from the world. For PvP, Personal is usually safest.";
				typeName = "STRING";
				defaultValue = "'personal'";
				expression = "_this setVariable ['%s', _value, true];";

				class Values {
					class Personal {name = "Personal / Arsenal"; value = "personal";};
					class Picked {name = "Picked Up Placed Device"; value = "picked";};
					class Both {name = "Both"; value = "both";};
				};
			};

			class GVAR(mobileProfileSide): Combo {
				property = QGVAR(mobileProfileSide);
				displayName = "Side";
				tooltip = "Optional side selector. Leave on Any to allow all sides that match the other selector fields.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";

				class Values {
					class Any {name = "Any"; value = "";};
					class BLUFOR {name = "BLUFOR"; value = "west";};
					class OPFOR {name = "OPFOR"; value = "east";};
					class Independent {name = "Independent"; value = "guer";};
					class Civilian {name = "Civilian"; value = "civ";};
				};
			};

			class GVAR(mobileProfileIdentityCategory) {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = "Identity";
				description = "";
			};

			class GVAR(mobileProfileTheme): Combo {
				property = QGVAR(mobileProfileTheme);
				displayName = "Theme";
				tooltip = "Preset theme for users matching this mobile profile. A synced Layout module can override this with custom colors/background.";
				typeName = "STRING";
				defaultValue = "'default'";
				expression = "_this setVariable ['%s', _value, true];";

				class Values {
					class Default {name = "Default"; value = "default";};
					class NATO {name = "NATO"; value = "nato";};
					class CSAT {name = "CSAT"; value = "csat";};
					class AAF {name = "AAF"; value = "aaf";};
				};
			};

			class GVAR(mobileProfileAliases): Edit {
				property = QGVAR(mobileProfileAliases);
				displayName = "E-Mail Aliases";
				tooltip = "Optional comma-separated e-mail addresses added to the matching player's mobile account.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileProfileEmailDomain): Edit {
				property = QGVAR(mobileProfileEmailDomain);
				displayName = "Player E-Mail Domain";
				tooltip = "Optional domain used when a matching player's primary e-mail is generated automatically, e.g. @aaf.ass or ion.com. Explicit e-mail addresses still override this.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileLockCode): Edit {
				property = QGVAR(mobileLockCode);
				displayName = "Lock Code";
				tooltip = "Numeric code required on the mobile lock screen for devices matching this profile. Leave empty to let any entry, including no entry, unlock the device.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(messengerName): Edit {
				property = QGVAR(messengerName);
				displayName = "Messenger Username";
				tooltip = "Display name shown in Messenger for devices using this profile. Leave empty to use the player or synced unit name.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileProfileSelectorsCategory) {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = "Selectors";
				description = "";
			};

			class GVAR(mobileProfileItemClasses): Edit {
				property = QGVAR(mobileProfileItemClasses);
				displayName = "Item Classes";
				tooltip = "Optional comma-separated MMC inventory item classes, e.g. MMC_main_ruggedTabletGreen. Leave empty for any MMC mobile item.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileProfileDeviceIds): Edit {
				property = QGVAR(mobileProfileDeviceIds);
				displayName = "Device IDs";
				tooltip = "Optional comma-separated MMC device ids: smartphone, ruggedTabletBlack, ruggedTabletGreen, ruggedTabletSand, tablet.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileProfileUIDs): Edit {
				property = QGVAR(mobileProfileUIDs);
				displayName = "Player UIDs";
				tooltip = "Optional comma-separated Steam UIDs. Useful for very specific device profiles.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileProfilePlayerNames): Edit {
				property = QGVAR(mobileProfilePlayerNames);
				displayName = "Player Names";
				tooltip = "Optional comma-separated player profile names. UIDs or unit variable names are usually safer for dedicated servers.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileProfileUnitVars): Edit {
				property = QGVAR(mobileProfileUnitVars);
				displayName = "Unit Variable Names";
				tooltip = "Optional comma-separated unit variable names, e.g. bravo_1_4, aaf_drone_operator.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileProfileUnitClasses): Edit {
				property = QGVAR(mobileProfileUnitClasses);
				displayName = "Unit Classes";
				tooltip = "Optional comma-separated unit class names.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileProfileFactions): Edit {
				property = QGVAR(mobileProfileFactions);
				displayName = "Factions";
				tooltip = "Optional comma-separated faction class names.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileProfileGroups): Edit {
				property = QGVAR(mobileProfileGroups);
				displayName = "Group IDs";
				tooltip = "Optional comma-separated group IDs as returned by groupId.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileProfileAppsCategory) {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = "Apps";
				description = "";
			};

			class GVAR(mobileProfileAppScripts): Edit {
				property = QGVAR(mobileProfileAppScripts);
				displayName = "Custom App Script Files";
				tooltip = "Optional comma-separated mission or mod SQF files. Scripts are called locally with params ['_device', '_player', '_profile'] and should add custom apps with MMC_fnc_addApp.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appFilesEnabled): Checkbox {
				property = QGVAR(appFilesEnabled);
				displayName = "Files App";
				tooltip = "If disabled, the Files app is hidden for players matching this profile.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appMailEnabled): Checkbox {
				property = QGVAR(appMailEnabled);
				displayName = "Mail App";
				tooltip = "If disabled, the Mail app is hidden for players matching this profile.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appMessagesEnabled): Checkbox {
				property = QGVAR(appMessagesEnabled);
				displayName = "Messenger App";
				tooltip = "If disabled, the Messenger app is hidden for players matching this profile.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appNotesEnabled): Checkbox {
				property = QGVAR(appNotesEnabled);
				displayName = "Notes App";
				tooltip = "If disabled, the Notes app is hidden for players matching this profile.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Registers a PvP-safe mobile profile for arsenal/personal or picked-up MMC mobile devices. Sync Layout, Modify Desktop, Add Text File, Add Picture, or Add Mail modules to enrich this profile.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Optionally synchronise Layout, Modify Desktop, Add Text File, Add Picture, or Add Mail modules to this module."};
				position = 0;
				direction = 0;
				optional = 1;
				duplicate = 1;
				synced[] = {QGVAR(customLayout), QGVAR(modifyDesktop), QGVAR(addTextFile), QGVAR(addPicture), QGVAR(addMail)};
			};
		};
	};

	class GVAR(assignMobileProfile): Module_F {
		category = QGVAR(Modules);
		displayName = "Mobile: Assign Profile";
		function = QFUNC(assignMobileProfileModule);
		functionPriority = 20;
		isDisposable = 0;
		is3DEN = 1;
		isGlobal = 0;
		isTriggerActivated = 0;
		scope = 2;

		class Attributes: AttributesBase {
			class GVAR(assignMobileProfileDeviceCategory) {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = "Device";
				description = "";
			};

			class GVAR(assignMobileProfileGiveDevice): Checkbox {
				property = QGVAR(assignMobileProfileGiveDevice);
				displayName = "Add Device";
				tooltip = "If enabled, the selected synced units receive the chosen MMC mobile device item at mission start.";
				typeName = "BOOL";
				defaultValue = "false";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(assignMobileProfileDevice): Combo {
				property = QGVAR(assignMobileProfileDevice);
				displayName = "Device";
				tooltip = "Device item to add when Add Device is enabled. The assigned profile applies to personal MMC mobile devices the synced unit carries, including devices taken from an arsenal later.";
				typeName = "STRING";
				defaultValue = "'MMC_main_smartphone'";
				expression = "_this setVariable ['%s', _value, true];";

				class Values {
					class Smartphone {name = "Smartphone"; value = QGVAR(smartphone);};
					class RuggedBlack {name = "Rugged Tablet (Black)"; value = QGVAR(ruggedTabletBlack);};
					class RuggedGreen {name = "Rugged Tablet (Green)"; value = QGVAR(ruggedTabletGreen);};
					class RuggedSand {name = "Rugged Tablet (Sand)"; value = QGVAR(ruggedTabletSand);};
					class Tablet {name = "Tablet"; value = QGVAR(tablet);};
				};
			};

			class GVAR(assignMobileProfileIdentityCategory) {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = "Identity and Mail";
				description = "";
			};

			class GVAR(assignMobileProfileEmail): Edit {
				property = QGVAR(assignMobileProfileEmail);
				displayName = "E-Mail Address";
				tooltip = "Primary mobile e-mail address for the synced unit. Leave empty to use PLAYERNAME@mmcsystems.com or the configured Player E-Mail Domain.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileProfileEmailDomain): Edit {
				property = QGVAR(mobileProfileEmailDomain);
				displayName = "Player E-Mail Domain";
				tooltip = "Optional domain used when the E-Mail Address is empty, e.g. @aaf.ass or ion.com. The actual address becomes PLAYERNAME@domain.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileProfileAliases): Edit {
				property = QGVAR(mobileProfileAliases);
				displayName = "Link E-Mail to Profile";
				tooltip = "Optional comma-separated e-mail addresses linked to the same mobile profile, e.g. overlord@mmcsystems.com,bravo1-4@aaf.ass.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mobileLockCode): Edit {
				property = QGVAR(mobileLockCode);
				displayName = "Lock Code";
				tooltip = "Numeric code required on the mobile lock screen for this assigned profile. Leave empty to let any entry, including no entry, unlock the device.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(messengerName): Edit {
				property = QGVAR(messengerName);
				displayName = "Messenger Username";
				tooltip = "Display name shown in Messenger for this assigned mobile profile. Leave empty to use the synced unit's name.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(assignMobileProfileAppearanceCategory) {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = "Appearance";
				description = "";
			};

			class GVAR(mobileProfileTheme): Combo {
				property = QGVAR(mobileProfileTheme);
				displayName = "Theme";
				tooltip = "Preset theme for this assigned mobile profile. A synced Layout module can override this with custom colors/background.";
				typeName = "STRING";
				defaultValue = "'default'";
				expression = "_this setVariable ['%s', _value, true];";

				class Values {
					class Default {name = "Default"; value = "default";};
					class NATO {name = "NATO"; value = "nato";};
					class CSAT {name = "CSAT"; value = "csat";};
					class AAF {name = "AAF"; value = "aaf";};
				};
			};

			class GVAR(assignMobileProfileAppsCategory) {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = "Apps";
				description = "";
			};

			class GVAR(mobileProfileAppScripts): Edit {
				property = QGVAR(mobileProfileAppScripts);
				displayName = "Custom App Script Files";
				tooltip = "Optional comma-separated mission or mod SQF files. Scripts are called locally with params ['_device', '_player', '_profile'] and should add custom apps with MMC_fnc_addApp.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appFilesEnabled): Checkbox {
				property = QGVAR(appFilesEnabled);
				displayName = "Files App";
				tooltip = "If disabled, the Files app is hidden for players matching this profile.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appMailEnabled): Checkbox {
				property = QGVAR(appMailEnabled);
				displayName = "Mail App";
				tooltip = "If disabled, the Mail app is hidden for players matching this profile.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appMessagesEnabled): Checkbox {
				property = QGVAR(appMessagesEnabled);
				displayName = "Messenger App";
				tooltip = "If disabled, the Messenger app is hidden for players matching this profile.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appNotesEnabled): Checkbox {
				property = QGVAR(appNotesEnabled);
				displayName = "Notes App";
				tooltip = "If disabled, the Notes app is hidden for players matching this profile.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(assignMobileProfileAdvancedCategory) {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = "Advanced";
				description = "";
			};

			class GVAR(assignMobileProfilePriority): Edit {
				property = QGVAR(assignMobileProfilePriority);
				displayName = "Priority";
				tooltip = "Optional override priority. Higher values are applied after broad Mobile Profile modules.";
				typeName = "NUMBER";
				defaultValue = "100";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(assignMobileProfileId): Edit {
				property = QGVAR(assignMobileProfileId);
				displayName = "Profile ID";
				tooltip = "Optional unique profile id. Leave empty unless another script needs a stable id.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Sync playable or AI units to assign their personal MMC mobile profile. Sync Layout, Modify Desktop, Add Text File, Add Picture, or Add Mail modules to enrich that profile.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise playable or AI units. Optional content modules can be synced to this module."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {"AnyBrain", QGVAR(customLayout), QGVAR(modifyDesktop), QGVAR(addTextFile), QGVAR(addPicture), QGVAR(addMail)};
			};
		};
	};

	class GVAR(addUser): Module_F {
		category = QGVAR(Modules);
		displayName = "Computer: Add User";
		function = QFUNC(addUserModule);
		functionPriority = 20;
		isDisposable = 0;
		is3DEN = 1;
		isGlobal = 0;
		isTriggerActivated = 0;
		scope = 2;

		class Attributes: AttributesBase {
			class GVAR(addUserLoginCategory) {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = "Login";
				description = "";
			};

			class GVAR(userName): Edit {
				property = QGVAR(userName);
				displayName = "Username";
				typeName = "STRING";
				defaultValue = "'operator'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(userPassword): Edit {
				property = QGVAR(userPassword);
				displayName = "Password";
				tooltip = "Leave empty to allow login with an empty password field.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(addUserMailCategory) {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = "Mail and Messenger";
				description = "";
			};

			class GVAR(userEmail): Edit {
				property = QGVAR(userEmail);
				displayName = "E-Mail Address";
				tooltip = "Mail addressed to this value appears in this user's inbox.";
				typeName = "STRING";
				defaultValue = "'operator@mmcsystems.com'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(addressBook): Edit {
				property = QGVAR(addressBook);
				displayName = "Address Book";
				tooltip = "Optional mission-made address book entries. Use comma or semicolon separated e-mail addresses, optionally as Name <address@example.com>.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(messengerName): Edit {
				property = QGVAR(messengerName);
				displayName = "Messenger Username";
				tooltip = "Display name shown in Messenger while this user is logged in. Leave empty to use Username.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(messengerSide): Combo {
				property = QGVAR(messengerSide);
				displayName = "Messenger Side";
				tooltip = "Side used by Messenger while this user is logged in. Auto derives the side from the selected theme. Use Hidden to keep this user out of contact lists.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";

				class Values {
					class Auto {name = "Auto (Theme)"; value = "";};
					class BLUFOR {name = "BLUFOR"; value = "west";};
					class OPFOR {name = "OPFOR"; value = "east";};
					class Independent {name = "Independent"; value = "guer";};
					class Civilian {name = "Civilian"; value = "civ";};
					class Hidden {name = "Hidden"; value = "hidden";};
				};
			};

			class GVAR(addUserAppearanceCategory) {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = "Appearance";
				description = "";
			};

			class GVAR(userTheme): Combo {
				property = QGVAR(userTheme);
				displayName = "Theme";
				tooltip = "Preset layout and desktop background for this user. Default uses the client's CBA Default Theme.";
				typeName = "STRING";
				defaultValue = "'default'";
				expression = "_this setVariable ['%s', _value, true];";

				class Values {
					class Default {name = "Default"; value = "default";};
					class NATO {name = "NATO"; value = "nato";};
					class CSAT {name = "CSAT"; value = "csat";};
					class AAF {name = "AAF"; value = "aaf";};
				};
			};

			class GVAR(addUserAppsCategory) {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = "Apps";
				description = "";
			};

			class GVAR(appFilesEnabled): Checkbox {
				property = QGVAR(appFilesEnabled);
				displayName = "Files App";
				tooltip = "If disabled, the Files app is hidden while this user is logged in.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appMailEnabled): Checkbox {
				property = QGVAR(appMailEnabled);
				displayName = "Mail App";
				tooltip = "If disabled, the Mail app is hidden while this user is logged in.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appMessagesEnabled): Checkbox {
				property = QGVAR(appMessagesEnabled);
				displayName = "Messenger App";
				tooltip = "If disabled, the Messenger app is hidden while this user is logged in.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(appNotesEnabled): Checkbox {
				property = QGVAR(appNotesEnabled);
				displayName = "Notes App";
				tooltip = "If disabled, the Notes app is hidden while this user is logged in.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Sync an MMC computer object or Register Computer module to add a login user to that computer. If no target is synced, the user is added to all registered MMC computers.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise any registered MMC computer object or Register Computer module."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {"AnyStaticObject", "AnyVehicle", QGVAR(registerComputer)};
			};
		};
	};

	class GVAR(customLayout): Module_F {
		category = QGVAR(Modules);
		displayName = "MMC: Layout";
		function = QFUNC(customLayoutModule);
		functionPriority = 25;
		isDisposable = 0;
		is3DEN = 1;
		isGlobal = 0;
		isTriggerActivated = 0;
		scope = 2;

		class Attributes: AttributesBase {
			class GVAR(customLayoutPreset): Combo {
				property = QGVAR(customLayoutPreset);
				displayName = "Preset";
				tooltip = "Base layout and desktop background preset for the computer. Default uses the client's CBA Default Theme.";
				typeName = "STRING";
				defaultValue = "'default'";
				expression = "_this setVariable ['%s', _value, true];";

				class Values {
					class Default {name = "Default"; value = "default";};
					class NATO {name = "NATO"; value = "nato";};
					class CSAT {name = "CSAT"; value = "csat";};
					class AAF {name = "AAF"; value = "aaf";};
				};
			};

			class GVAR(customLayoutApplyScreenTextures): Checkbox {
				property = QGVAR(customLayoutApplyScreenTextures);
				displayName = "Apply Screen Textures";
				tooltip = "If disabled, MMC will not use setObjectTextureGlobal for this layout. Use this for objects that have no usable screen texture selection.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutScreenSelections): Edit {
				property = QGVAR(customLayoutScreenSelections);
				displayName = "Screen Texture Selections";
				tooltip = "Optional comma-separated setObjectTexture selections, e.g. 0 or 0,1. Leave empty to use MMC's built-in device detection. Unsupported objects are ignored unless this field is filled.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutUseCustomColors): Checkbox {
				property = QGVAR(customLayoutUseCustomColors);
				displayName = "Custom Color Scheme";
				tooltip = "If enabled, the Preset color scheme is ignored and the custom color fields below are used. Empty or invalid fields fall back to a readable dark base.";
				typeName = "BOOL";
				defaultValue = "false";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutDesktopColor): Edit {
				property = QGVAR(customLayoutDesktopColor);
				displayName = "Desktop Color";
				tooltip = "Hex color, e.g. 0B1320 or #0B1320. Used when Custom Color Scheme is enabled.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutPanelColor): Edit {
				property = QGVAR(customLayoutPanelColor);
				displayName = "Window Color";
				tooltip = "Hex color for content boxes and lists.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutPanelStrongColor): Edit {
				property = QGVAR(customLayoutPanelStrongColor);
				displayName = "Menu Bar Color";
				tooltip = "Hex color for task bars, title bars, and strong panels.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutButtonColor): Edit {
				property = QGVAR(customLayoutButtonColor);
				displayName = "Button Color";
				tooltip = "Hex color for buttons.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutButtonHoverColor): Edit {
				property = QGVAR(customLayoutButtonHoverColor);
				displayName = "Button Hover Color";
				tooltip = "Hex color for hovered buttons.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutAccentColor): Edit {
				property = QGVAR(customLayoutAccentColor);
				displayName = "Accent Color";
				tooltip = "Hex color for progress bars and small highlight elements.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutTextColor): Edit {
				property = QGVAR(customLayoutTextColor);
				displayName = "Text Color";
				tooltip = "Hex color for readable UI text.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutBorderColor): Edit {
				property = QGVAR(customLayoutBorderColor);
				displayName = "Border Color";
				tooltip = "Hex color for button and window outlines.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutBackground): Edit {
				property = QGVAR(customLayoutBackground);
				displayName = "Custom Desktop Picture";
				tooltip = "Optional texture path. If filled, this overrides the Preset desktop background while keeping either preset or custom colors.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutScreen1x1Login): Edit {
				property = QGVAR(customLayoutScreen1x1Login);
				displayName = "Screen 1x1 Login";
				tooltip = "Optional 1024x1024 in-world screen texture for the login state. Leave empty to use the Preset image.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutScreen1x1Desktop): Edit {
				property = QGVAR(customLayoutScreen1x1Desktop);
				displayName = "Screen 1x1 Desktop";
				tooltip = "Optional 1024x1024 in-world screen texture for the desktop state. Leave empty to use the Preset image.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutScreen1x1Startup): Edit {
				property = QGVAR(customLayoutScreen1x1Startup);
				displayName = "Screen 1x1 Startup";
				tooltip = "Optional 1024x1024 in-world screen texture for the startup state. Leave empty to use the Preset image.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutScreen1x1Shutdown): Edit {
				property = QGVAR(customLayoutScreen1x1Shutdown);
				displayName = "Screen 1x1 Shutdown";
				tooltip = "Optional 1024x1024 in-world screen texture for powered-off and shutdown states. Leave empty to use the Preset image.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutScreen2x1Login): Edit {
				property = QGVAR(customLayoutScreen2x1Login);
				displayName = "Screen 2x1 Login";
				tooltip = "Optional 1024x512 in-world screen texture for the login state. Leave empty to use the Preset image.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutScreen2x1Desktop): Edit {
				property = QGVAR(customLayoutScreen2x1Desktop);
				displayName = "Screen 2x1 Desktop";
				tooltip = "Optional 1024x512 in-world screen texture for the desktop state. Leave empty to use the Preset image.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutScreen2x1Startup): Edit {
				property = QGVAR(customLayoutScreen2x1Startup);
				displayName = "Screen 2x1 Startup";
				tooltip = "Optional 1024x512 in-world screen texture for the startup state. Leave empty to use the Preset image.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(customLayoutScreen2x1Shutdown): Edit {
				property = QGVAR(customLayoutScreen2x1Shutdown);
				displayName = "Screen 2x1 Shutdown";
				tooltip = "Optional 1024x512 in-world screen texture for powered-off and shutdown states. Leave empty to use the Preset image.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Sync this module to one or more Register Computer modules, registered computers, or Mobile Profile modules to set their layout/background.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise one or more Register Computer modules, registered MMC computer objects, or Mobile Profile modules."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {QGVAR(registerComputer), "AnyStaticObject", "AnyVehicle", QGVAR(mobileProfile), QGVAR(assignMobileProfile)};
			};
		};
	};

	class GVAR(addTextFile): Module_F {
		category = QGVAR(Modules);
		displayName = "MMC: Add Text File";
		function = QFUNC(addTextFileModule);
		functionPriority = 30;
		isDisposable = 0;
		is3DEN = 1;
		isGlobal = 0;
		isTriggerActivated = 0;
		scope = 2;

		class Attributes: AttributesBase {
			class GVAR(fileName): Edit {
				property = QGVAR(fileName);
				displayName = "File Name";
				typeName = "STRING";
				defaultValue = "'intel.txt'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(filePath): Edit {
				property = QGVAR(filePath);
				displayName = "File Path";
				typeName = "STRING";
				defaultValue = "'\\Desktop\\intel.txt'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(fileContent): Edit {
				property = QGVAR(fileContent);
				displayName = "File Content";
				tooltip = "Structured text is supported, including tags such as <br/> and image tags. Use \\n for line breaks.";
				typeName = "STRING";
				control = "EditMulti5";
				defaultValue = "'Mission intel goes here.'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Sync an MMC computer object, Register Computer module, Add User module, or Mobile Profile module to add a text file.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise any registered MMC computer object, Register Computer module, Add User module, or Mobile Profile module."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {QGVAR(registerComputer), "AnyStaticObject", "AnyVehicle", QGVAR(addUser), QGVAR(mobileProfile), QGVAR(assignMobileProfile)};
			};
		};
	};

	class GVAR(addPicture): Module_F {
		category = QGVAR(Modules);
		displayName = "MMC: Add Picture";
		function = QFUNC(addPictureModule);
		functionPriority = 30;
		isDisposable = 0;
		is3DEN = 1;
		isGlobal = 0;
		isTriggerActivated = 0;
		scope = 2;

		class Attributes: AttributesBase {
			class GVAR(fileName): Edit {
				property = QGVAR(fileName);
				displayName = "Picture Name";
				typeName = "STRING";
				defaultValue = "'picture.paa'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(filePath): Edit {
				property = QGVAR(filePath);
				displayName = "File Path";
				tooltip = "Path shown inside the computer's file system. This is not the picture texture path from the mission folder.";
				typeName = "STRING";
				defaultValue = "'\\Pictures\\picture.paa'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(fileTexture): Edit {
				property = QGVAR(fileTexture);
				displayName = "Picture Texture";
				tooltip = "Texture path for the picture, e.g. a mission or mod .paa.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(fileDescription): Edit {
				property = QGVAR(fileDescription);
				displayName = "Picture Description";
				tooltip = "Description shown under the picture in the Files app.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Sync an MMC computer object, Register Computer module, Add User module, or Mobile Profile module to add a picture to the file browser.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise any registered MMC computer object, Register Computer module, Add User module, or Mobile Profile module."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {QGVAR(registerComputer), "AnyStaticObject", "AnyVehicle", QGVAR(addUser), QGVAR(mobileProfile), QGVAR(assignMobileProfile)};
			};
		};
	};

	class GVAR(addMail): Module_F {
		category = QGVAR(Modules);
		displayName = "MMC: Add Mail";
		function = QFUNC(addMailModule);
		functionPriority = 30;
		isDisposable = 0;
		is3DEN = 1;
		isGlobal = 0;
		isTriggerActivated = 0;
		scope = 2;

		class Attributes: AttributesBase {
			class GVAR(mailDirection): Combo {
				property = QGVAR(mailDirection);
				displayName = "Mailbox";
				tooltip = "Inbox means the selected user received this mail. Outbox means the selected user sent this mail.";
				typeName = "STRING";
				defaultValue = "'inbox'";
				expression = "_this setVariable ['%s', _value, true];";

				class Values {
					class Inbox {name = "Inbox"; value = "inbox";};
					class Outbox {name = "Outbox"; value = "outbox";};
				};
			};

			class GVAR(mailDate): Edit {
				property = QGVAR(mailDate);
				displayName = "Date";
				tooltip = "Mail date in YYYY-MM-DD format. Leave empty or enter an invalid value to use the current mission date.";
				typeName = "STRING";
				defaultValue = "'2026-01-01'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mailTime): Edit {
				property = QGVAR(mailTime);
				displayName = "Time";
				tooltip = "Mail time in HH:MM format. Leave empty or enter an invalid value to use the current mission time.";
				typeName = "STRING";
				defaultValue = "'00:00'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mailCounterpart): Edit {
				property = QGVAR(mailCounterpart);
				displayName = "From/To";
				tooltip = "If Mailbox is Inbox, this is the sender. If Mailbox is Outbox, this is the recipient.";
				typeName = "STRING";
				defaultValue = "'sender@mmc.local'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mailCc): Edit {
				property = QGVAR(mailCc);
				displayName = "CC";
				tooltip = "Optional comma-separated CC e-mail addresses. Existing users receive inbox copies.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mailRecipientRead): Checkbox {
				property = QGVAR(mailRecipientRead);
				displayName = "Recipient Read";
				tooltip = "Marks the recipient inbox copy as already read.";
				typeName = "BOOL";
				defaultValue = "false";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mailSenderRead): Checkbox {
				property = QGVAR(mailSenderRead);
				displayName = "Sender Read";
				tooltip = "Marks the sender outbox copy as already read.";
				typeName = "BOOL";
				defaultValue = "true";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mailCcRead): Checkbox {
				property = QGVAR(mailCcRead);
				displayName = "CC Read";
				tooltip = "Marks all matching CC inbox copies as already read.";
				typeName = "BOOL";
				defaultValue = "false";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mailSubject): Edit {
				property = QGVAR(mailSubject);
				displayName = "Subject";
				typeName = "STRING";
				defaultValue = "'Mission Update'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mailBody): Edit {
				property = QGVAR(mailBody);
				displayName = "Body";
				tooltip = "Structured text is supported, including tags such as <br/> and image tags. Use \\n for line breaks.";
				typeName = "STRING";
				control = "EditMulti5";
				defaultValue = "'Mail body goes here.'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mailAttachment): Edit {
				property = QGVAR(mailAttachment);
				displayName = "Attachment Picture";
				tooltip = "Optional picture texture path. If filled, it must exist and is added to recipient and CC file browsers.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mailAttachmentDescription): Edit {
				property = QGVAR(mailAttachmentDescription);
				displayName = "Attachment Description";
				tooltip = "Optional description shown under the attached picture in the Files app.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Sync Add User or Mobile Profile modules to add an email to user inboxes or outboxes. Sync Register Computer modules or computer objects to seed computer-level mail. Matching sender, recipient, and CC users receive mirrored mail copies.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise any Add User module, Mobile Profile module, Register Computer module, or registered MMC computer object."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {QGVAR(registerComputer), "AnyStaticObject", "AnyVehicle", QGVAR(addUser), QGVAR(mobileProfile), QGVAR(assignMobileProfile)};
			};
		};
	};

	class GVAR(modifyDesktop): Module_F {
		category = QGVAR(Modules);
		displayName = "MMC: Modify Desktop";
		function = QFUNC(modifyDesktopModule);
		functionPriority = 30;
		isDisposable = 0;
		is3DEN = 1;
		isGlobal = 0;
		isTriggerActivated = 0;
		scope = 2;

		class Attributes: AttributesBase {
			class GVAR(desktopTitle): Edit {
				property = QGVAR(desktopTitle);
				displayName = "Desktop Title";
				typeName = "STRING";
				defaultValue = "'Welcome'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(desktopAlign): Combo {
				property = QGVAR(desktopAlign);
				displayName = "Text Alignment";
				typeName = "STRING";
				defaultValue = "'left'";
				class Values {
					class Left {
						name = "Left";
						value = "left";
					};
					class Center {
						name = "Center";
						value = "center";
					};
					class Right {
						name = "Right";
						value = "right";
					};
				};
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(desktopContent): Edit {
				property = QGVAR(desktopContent);
				displayName = "Desktop Text";
				tooltip = "Structured text is supported, including tags such as <br/> and image tags. Use \\n for line breaks.";
				typeName = "STRING";
				control = "EditMulti5";
				defaultValue = "'Select an app on the left.'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(desktopScript): Edit {
				property = QGVAR(desktopScript);
				displayName = "Desktop Script File";
				tooltip = "Optional mission or mod script path. If set, the script is called to build the Desktop with MMC_fnc_addAppStructuredText, MMC_fnc_addAppButton, MMC_fnc_addAppLine, MMC_fnc_addAppSpacer, MMC_fnc_addAppBox, and related builder functions.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Sync Register Computer modules to change computer default Desktop text, Add User modules to change that user's Desktop text, or Mobile Profile modules to change matching mobile desktops. Direct computer object sync remains as a fallback.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise any Register Computer module, Add User module, Mobile Profile module, or registered MMC computer object fallback."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {QGVAR(registerComputer), QGVAR(addUser), QGVAR(mobileProfile), QGVAR(assignMobileProfile), "AnyStaticObject", "AnyVehicle"};
			};
		};
	};
};
