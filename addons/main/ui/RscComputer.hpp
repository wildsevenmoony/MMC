class RscText;
class RscStructuredText;
class RscButton;
class RscListbox;
class RscPicture;

class GVAR(RscComputer) {
	idd = IDD_MMC_COMPUTER;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "_this call MMC_fnc_initDisplay";
	onUnload = "uiNamespace setVariable ['MMC_main_display', displayNull]";

	class ControlsBackground {
		class DesktopBackground: RscText {
			idc = IDC_MMC_DESKTOP_BG;
			x = "safeZoneX";
			y = "safeZoneY";
			w = "safeZoneW";
			h = "safeZoneH";
			colorBackground[] = {0.035, 0.075, 0.115, 1};
		};

		class DesktopTint: RscText {
			idc = IDC_MMC_DESKTOP_TINT;
			x = "safeZoneX";
			y = "safeZoneY";
			w = "safeZoneW";
			h = "safeZoneH";
			colorBackground[] = {0, 0, 0, 0.18};
		};

		class DesktopImage: RscPicture {
			idc = IDC_MMC_DESKTOP_IMAGE;
			text = "";
			x = "safeZoneX";
			y = "safeZoneY";
			w = "safeZoneW";
			h = "safeZoneH";
			colorText[] = {1, 1, 1, 0.25};
		};

		class Taskbar: RscText {
			idc = IDC_MMC_TASKBAR;
			x = "safeZoneX";
			y = "safeZoneY + safeZoneH - 0.055";
			w = "safeZoneW";
			h = 0.055;
			colorBackground[] = {0.015, 0.018, 0.024, 0.95};
		};
	};

	class Controls {
		class FilesButton: RscButton {
			idc = IDC_MMC_BTN_FILES;
			text = "Files";
			x = "safeZoneX + 0.035";
			y = "safeZoneY + 0.06";
			w = 0.105;
			h = 0.05;
			action = "['files'] call MMC_fnc_renderApp";
		};

		class MailButton: FilesButton {
			idc = IDC_MMC_BTN_MAIL;
			text = "Mail";
			y = "safeZoneY + 0.125";
			action = "['mail'] call MMC_fnc_renderApp";
		};

		class MessagesButton: FilesButton {
			idc = IDC_MMC_BTN_MESSAGES;
			text = "Messenger";
			y = "safeZoneY + 0.19";
			action = "['messages'] call MMC_fnc_renderApp";
		};

		class NotesButton: FilesButton {
			idc = IDC_MMC_BTN_NOTES;
			text = "Notes";
			y = "safeZoneY + 0.255";
			action = "['notes'] call MMC_fnc_renderApp";
		};

		class AppTitle: RscText {
			idc = IDC_MMC_APP_TITLE;
			text = "Desktop";
			x = "safeZoneX + 0.18";
			y = "safeZoneY + 0.09";
			w = "safeZoneW - 0.36";
			h = 0.04;
			colorBackground[] = {0.02, 0.025, 0.035, 0.96};
		};

		class CloseApp: RscButton {
			idc = IDC_MMC_BTN_CLOSE_APP;
			text = "X";
			x = "safeZoneX + safeZoneW - 0.222";
			y = "safeZoneY + 0.09";
			w = 0.042;
			h = 0.04;
			action = "['desktop'] call MMC_fnc_renderApp";
		};

		class AppList: RscListbox {
			idc = IDC_MMC_APP_LIST;
			x = "safeZoneX + 0.18";
			y = "safeZoneY + 0.135";
			w = 0.24;
			h = "safeZoneH - 0.245";
			colorBackground[] = {0.02, 0.025, 0.035, 0.88};
			onLBSelChanged = "['select', _this] call MMC_fnc_renderApp";
		};

		class AppBody: RscStructuredText {
			idc = IDC_MMC_APP_BODY;
			x = "safeZoneX + 0.43";
			y = "safeZoneY + 0.135";
			w = "safeZoneW - 0.61";
			h = "safeZoneH - 0.245";
			colorBackground[] = {0.03, 0.035, 0.045, 0.9};
		};

		class StartButton: RscButton {
			idc = IDC_MMC_START_BUTTON;
			text = "Start";
			x = "safeZoneX + 0.012";
			y = "safeZoneY + safeZoneH - 0.046";
			w = 0.08;
			h = 0.037;
			action = "call MMC_fnc_toggleStartMenu";
		};

		class UserName: RscText {
			idc = IDC_MMC_USER;
			text = "";
			x = "safeZoneX + 0.105";
			y = "safeZoneY + safeZoneH - 0.046";
			w = 0.35;
			h = 0.037;
			colorBackground[] = {0, 0, 0, 0};
		};

		class Clock: RscText {
			idc = IDC_MMC_CLOCK;
			text = "";
			x = "safeZoneX + safeZoneW - 0.23";
			y = "safeZoneY + safeZoneH - 0.046";
			w = 0.215;
			h = 0.037;
			style = 1;
			colorBackground[] = {0, 0, 0, 0};
		};

		class StartMenu: RscText {
			idc = IDC_MMC_START_MENU;
			x = "safeZoneX + 0.012";
			y = "safeZoneY + safeZoneH - 0.202";
			w = 0.19;
			h = 0.148;
			colorBackground[] = {0.018, 0.022, 0.03, 0.98};
		};

		class StartBoot: RscButton {
			idc = IDC_MMC_START_BOOT;
			text = "Turn On";
			x = "safeZoneX + 0.022";
			y = "safeZoneY + safeZoneH - 0.185";
			w = 0.17;
			h = 0.04;
			action = "call MMC_fnc_startup";
		};

		class StartShutdown: RscButton {
			idc = IDC_MMC_START_SHUTDOWN;
			text = "Shut Down";
			x = "safeZoneX + 0.022";
			y = "safeZoneY + safeZoneH - 0.136";
			w = 0.17;
			h = 0.04;
			action = "call MMC_fnc_shutdown";
		};

		class PowerScreen: RscStructuredText {
			idc = IDC_MMC_POWER_SCREEN;
			x = "safeZoneX";
			y = "safeZoneY";
			w = "safeZoneW";
			h = "safeZoneH";
			colorBackground[] = {0, 0, 0, 0.96};
		};
	};
};

