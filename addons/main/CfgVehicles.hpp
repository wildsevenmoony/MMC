/*
 * Author: Moony
 * Eden and Zeus module classes for configuring MMC computers.
 */

class CfgVehicles {
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

			class GVAR(background): Combo {
				property = QGVAR(background);
				displayName = "Background";
				tooltip = "Preset desktop background. Ignored if Custom Background Texture is filled.";
				typeName = "STRING";
				defaultValue = "'default_dark'";
				expression = "_this setVariable ['%s', _value, true];";

				class Values {
					class DefaultDark {name = "Default Dark"; value = "default_dark";};
					class DefaultLight {name = "Default Light"; value = "default_light";};
					class NATO {name = "NATO"; value = "nato";};
					class CSAT {name = "CSAT"; value = "csat";};
					class AAF {name = "AAF"; value = "aaf";};
					class FIA {name = "FIA"; value = "fia";};
				};
			};

			class GVAR(backgroundCustom): Edit {
				property = QGVAR(backgroundCustom);
				displayName = "Custom Background Texture";
				tooltip = "Optional texture path. If filled, this overrides the Background selection above.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(systemName): Edit {
				property = QGVAR(systemName);
				displayName = "System Name";
				typeName = "STRING";
				defaultValue = "'MMC Workstation'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Sync any object to this module to make it an MMC computer.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise any laptop, PC, or object to this module."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {"AnyStaticObject", "AnyVehicle"};
			};
		};
	};

	class GVAR(addTextFile): Module_F {
		category = QGVAR(Modules);
		displayName = "Computer: Add Text File";
		function = QFUNC(addTextFileModule);
		functionPriority = 10;
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
				typeName = "STRING";
				defaultValue = "'Mission intel goes here.'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Sync an MMC computer object to add a text file to its file browser.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise any registered MMC computer object."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {"AnyStaticObject", "AnyVehicle"};
			};
		};
	};

	class GVAR(addMail): Module_F {
		category = QGVAR(Modules);
		displayName = "Computer: Add Mail";
		function = QFUNC(addMailModule);
		functionPriority = 10;
		isDisposable = 0;
		is3DEN = 1;
		isGlobal = 0;
		isTriggerActivated = 0;
		scope = 2;

		class Attributes: AttributesBase {
			class GVAR(mailFrom): Edit {
				property = QGVAR(mailFrom);
				displayName = "From";
				typeName = "STRING";
				defaultValue = "'sender@mmc.local'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mailTo): Edit {
				property = QGVAR(mailTo);
				displayName = "To";
				typeName = "STRING";
				defaultValue = "'operator@mmc.local'";
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
				typeName = "STRING";
				defaultValue = "'Mail body goes here.'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(mailDate): Edit {
				property = QGVAR(mailDate);
				displayName = "Date";
				typeName = "STRING";
				defaultValue = "'2035-06-01 08:00'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Sync an MMC computer object to add an email to its inbox.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise any registered MMC computer object."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {"AnyStaticObject", "AnyVehicle"};
			};
		};
	};
};
