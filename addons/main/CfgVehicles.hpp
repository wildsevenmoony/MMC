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
		displayName = "Computer: Layout";
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
			description = "Sync this module to one or more Register Computer modules or registered computers to set their pre-login layout/background.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise one or more Register Computer modules or registered MMC computer objects."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {QGVAR(registerComputer), "AnyStaticObject", "AnyVehicle"};
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
				tooltip = "Structured text is supported, including tags such as <br/> and image tags. Use \\n for line breaks.";
				typeName = "STRING";
				control = "EditMulti5";
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
			description = "Sync Add User modules to add an email to user inboxes or outboxes. Matching sender, recipient, and CC users receive mirrored mail copies.";
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
			description = "Sync Register Computer modules to change computer default Desktop text, or Add User modules to change that user's Desktop text. Direct computer object sync remains as a fallback.";
			sync[] = {"LocationArea_F"};

			class LocationArea_F {
				description[] = {"Synchronise any Register Computer module, Add User module, or registered MMC computer object fallback."};
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 1;
				synced[] = {QGVAR(registerComputer), QGVAR(addUser), "AnyStaticObject", "AnyVehicle"};
			};
		};
	};
};
