/*
 * Author: Moony
 * Eden and Zeus module classes for configuring MMC computers.
 */

class CfgVehicles {
	class Logic;
	class Sound;
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

			class GVAR(userEmail): Edit {
				property = QGVAR(userEmail);
				displayName = "E-Mail Address";
				tooltip = "Mail addressed to this value appears in this user's inbox.";
				typeName = "STRING";
				defaultValue = "'operator@mmcsystems.com'";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(userBackground): Combo {
				property = QGVAR(userBackground);
				displayName = "Background";
				tooltip = "Preset desktop background for this user. Ignored if Custom Background Texture is filled.";
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

			class GVAR(userBackgroundCustom): Edit {
				property = QGVAR(userBackgroundCustom);
				displayName = "Custom Background Texture";
				tooltip = "Optional texture path. If filled, this overrides the Background selection above.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";
			};

			class GVAR(userForceTheme): Combo {
				property = QGVAR(userForceTheme);
				displayName = "Force Layout";
				tooltip = "Optional layout override for this user. If set, it ignores the player's CBA Theme setting while this user is logged in.";
				typeName = "STRING";
				defaultValue = "''";
				expression = "_this setVariable ['%s', _value, true];";

				class Values {
					class None {name = "None"; value = "";};
					class Dark {name = "Dark"; value = "dark";};
					class Light {name = "Light"; value = "light";};
					class User {name = "User"; value = "user";};
					class BLUFOR {name = "BLUFOR"; value = "blufor";};
					class OPFOR {name = "OPFOR"; value = "opfor";};
					class Independent {name = "Independent"; value = "independent";};
					class Civilian {name = "Civilian"; value = "civilian";};
				};
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Sync an MMC computer object to add a login user to that computer.";
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

	class GVAR(addTextFile): Module_F {
		category = QGVAR(Modules);
		displayName = "Computer: Add Text File";
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

	class GVAR(addPicture): Module_F {
		category = QGVAR(Modules);
		displayName = "Computer: Add Picture";
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
			description = "Sync an MMC computer object or Add User module to add a picture to the file browser.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise any registered MMC computer object or Add User module."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {"AnyStaticObject", "AnyVehicle", QGVAR(addUser)};
			};
		};
	};

	class GVAR(addMail): Module_F {
		category = QGVAR(Modules);
		displayName = "Computer: Add Mail";
		function = QFUNC(addMailModule);
		functionPriority = 30;
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

	class GVAR(sound_testaudio): Sound {
		scope = 1;
		side = -1;
		sound = QGVAR(testaudio);
	};

	class GVAR(modifyDesktop): Module_F {
		category = QGVAR(Modules);
		displayName = "Computer: Modify Desktop";
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

			class GVAR(desktopContent): Edit {
				property = QGVAR(desktopContent);
				displayName = "Desktop Text";
				tooltip = "Structured text is supported, including tags such as <br/> and image tags.";
				typeName = "STRING";
				defaultValue = "'Select an app on the left.'";
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

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Sync Add User modules to set that user's Desktop text. If synced to a computer, this changes the computer default Desktop text.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise any Add User module or registered MMC computer object."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {"AnyStaticObject", "AnyVehicle", QGVAR(addUser)};
			};
		};
	};
};
