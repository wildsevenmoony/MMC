class RscText;
class RscStructuredText;
class RscButton;
class RscEdit;
class RscListbox;
class RscPicture;
class MMB_main_RscBaseDisplay;

class GVAR(RscComputerButton): RscButton {
	shadow = 0;
	colorShadow[] = {0, 0, 0, 0};
	colorFocused[] = {0.07, 0.078, 0.096, 0.98};
	colorBackground2[] = {0.07, 0.078, 0.096, 0.98};
	colorBackgroundActive[] = {0.07, 0.078, 0.096, 0.98};
	colorDisabled[] = {1, 1, 1, 0.35};
	borderSize = 0.0012;
	colorBorder[] = {0, 0, 0, 0.8};
	offsetX = 0;
	offsetY = 0;
	offsetPressedX = 0;
	offsetPressedY = 0;
	onMouseEnter = "_this params ['_ctrl']; [_ctrl, true] call MMC_fnc_setButtonHover";
	onMouseExit = "_this params ['_ctrl']; [_ctrl, false] call MMC_fnc_setButtonHover";
};

class GVAR(RscComputerFrame): RscText {
	shadow = 0;
	style = 64;
	text = "";
	colorText[] = {0, 0, 0, 0.85};
	colorBackground[] = {0, 0, 0, 0};
};

class GVAR(RscComputer) {
	idd = IDD_MMC_COMPUTER;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "_this call MMC_fnc_initDisplay";
	onUnload = "_this call MMC_fnc_handleDisplayUnload";
	onKeyDown = "if ((_this select 1) in [28, 156]) then {call MMC_fnc_login; true} else {false}";

	class ControlsBackground {
		class DesktopBackground: RscText {
			idc = IDC_MMC_DESKTOP_BG;
			shadow = 0;
			x = "safeZoneX";
			y = "safeZoneY";
			w = "safeZoneW";
			h = "safeZoneH";
			colorBackground[] = {0.035, 0.075, 0.115, 1};
		};

		class DesktopTint: RscText {
			idc = IDC_MMC_DESKTOP_TINT;
			shadow = 0;
			x = "safeZoneX";
			y = "safeZoneY";
			w = "safeZoneW";
			h = "safeZoneH";
			colorBackground[] = {0, 0, 0, 0};
		};

		class DesktopImage: RscPicture {
			idc = IDC_MMC_DESKTOP_IMAGE;
			text = "";
			x = "safeZoneX";
			y = "safeZoneY";
			w = "safeZoneW";
			h = "safeZoneH";
			colorText[] = {1, 1, 1, 1};
		};

		class Taskbar: RscText {
			idc = IDC_MMC_TASKBAR;
			shadow = 0;
			x = "safeZoneX";
			y = "safeZoneY + safeZoneH - 0.055";
			w = "safeZoneW";
			h = 0.055;
			colorBackground[] = {0.015, 0.018, 0.024, 0.95};
		};
	};

	class Controls {
		class FilesButton: GVAR(RscComputerButton) {
			idc = IDC_MMC_BTN_FILES;
			text = "Files";
			x = "safeZoneX + 0.035";
			y = "safeZoneY + 0.09";
			w = 0.105;
			h = 0.05;
			action = "['files'] call MMC_fnc_renderApp";
		};

		class MailButton: FilesButton {
			idc = IDC_MMC_BTN_MAIL;
			text = "Mail";
			y = "safeZoneY + 0.145";
			action = "['mail'] call MMC_fnc_renderApp";
		};

		class MessagesButton: FilesButton {
			idc = IDC_MMC_BTN_MESSAGES;
			text = "Messenger";
			y = "safeZoneY + 0.2";
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
			shadow = 0;
			text = "Desktop";
			x = "safeZoneX + 0.18";
			y = "safeZoneY + 0.09";
			w = "safeZoneW - 0.36";
			h = 0.04;
			colorBackground[] = {0.02, 0.025, 0.035, 0.96};
		};

		class CloseApp: GVAR(RscComputerButton) {
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
			shadow = 0;
			x = "safeZoneX + 0.18";
			y = "safeZoneY + 0.135";
			w = 0.24;
			h = "safeZoneH - 0.245";
			colorBackground[] = {0.02, 0.025, 0.035, 0.88};
			onLBSelChanged = "['select', _this] call MMC_fnc_renderApp";
		};

		class AppBody: RscStructuredText {
			idc = IDC_MMC_APP_BODY;
			shadow = 0;
			x = "safeZoneX + 0.43";
			y = "safeZoneY + 0.135";
			w = "safeZoneW - 0.61";
			h = "safeZoneH - 0.315";
			colorBackground[] = {0.03, 0.035, 0.045, 0.9};
		};

		class FilePreviewImage: RscPicture {
			idc = IDC_MMC_FILE_PREVIEW_IMAGE;
			text = "";
			x = "safeZoneX + 0.565";
			y = "safeZoneY + 0.2";
			w = 0.18;
			h = 0.135;
			colorText[] = {1, 1, 1, 1};
		};

		class MailHeader: RscText {
			idc = IDC_MMC_MAIL_HEADER;
			shadow = 0;
			text = "";
			x = "safeZoneX + 0.445";
			y = "safeZoneY + 0.148";
			w = "safeZoneW - 0.64";
			h = 0.035;
			sizeEx = 0.026;
			font = "EtelkaMonospacePro";
			colorBackground[] = {0, 0, 0, 0};
		};

		class MailTable: RscListbox {
			idc = IDC_MMC_MAIL_TABLE;
			shadow = 0;
			x = "safeZoneX + 0.445";
			y = "safeZoneY + 0.19";
			w = "safeZoneW - 0.64";
			h = "safeZoneH - 0.37";
			font = "EtelkaMonospacePro";
			colorBackground[] = {0.02, 0.025, 0.035, 0.72};
			onLBSelChanged = "call MMC_fnc_mailSelect";
		};

		class MailReply: GVAR(RscComputerButton) {
			idc = IDC_MMC_MAIL_REPLY;
			text = "Answer";
			tooltip = "Answer this mail.";
			x = "safeZoneX + 0.445";
			y = "safeZoneY + 0.148";
			w = 0.075;
			h = 0.035;
			action = "['reply'] call MMC_fnc_mailCompose";
		};

		class MailForward: MailReply {
			idc = IDC_MMC_MAIL_FORWARD;
			text = "Forward";
			tooltip = "Forward this mail.";
			x = "safeZoneX + 0.525";
			action = "['forward'] call MMC_fnc_mailCompose";
		};

		class MailRecipientLabel: RscText {
			idc = IDC_MMC_MAIL_RECIPIENT_LABEL;
			shadow = 0;
			text = "Recipient";
			x = "safeZoneX + 0.445";
			y = "safeZoneY + 0.155";
			w = 0.11;
			h = 0.032;
			colorBackground[] = {0, 0, 0, 0};
		};

		class MailRecipient: RscEdit {
			idc = IDC_MMC_MAIL_RECIPIENT;
			shadow = 0;
			x = "safeZoneX + 0.56";
			y = "safeZoneY + 0.155";
			w = "safeZoneW - 0.835";
			h = 0.036;
			colorBackground[] = {1, 1, 1, 0.08};
		};

		class MailSubjectLabel: MailRecipientLabel {
			idc = IDC_MMC_MAIL_SUBJECT_LABEL;
			text = "Subject";
			y = "safeZoneY + 0.197";
		};

		class MailSubject: MailRecipient {
			idc = IDC_MMC_MAIL_SUBJECT;
			y = "safeZoneY + 0.197";
		};

		class MailAttachmentLabel: MailRecipientLabel {
			idc = IDC_MMC_MAIL_ATTACHMENT_LABEL;
			text = "Attachment";
			y = "safeZoneY + safeZoneH - 0.207";
		};

		class MailAttachment: MailRecipient {
			idc = IDC_MMC_MAIL_ATTACHMENT;
			x = "safeZoneX + 0.56";
			y = "safeZoneY + safeZoneH - 0.207";
			w = "safeZoneW - 0.835";
			tooltip = "Optional picture texture path, e.g. mission folder path or mod texture path. If set, the recipient receives it as a picture file.";
		};

		class MailBodyLabel: MailRecipientLabel {
			idc = IDC_MMC_MAIL_BODY_LABEL;
			text = "Text";
			y = "safeZoneY + 0.239";
		};

		class MailBody: MailRecipient {
			idc = IDC_MMC_MAIL_BODY;
			style = 16;
			x = "safeZoneX + 0.445";
			y = "safeZoneY + 0.274";
			w = "safeZoneW - 0.64";
			h = "safeZoneH - 0.49";
			lineSpacing = 1;
		};

		class MailSend: GVAR(RscComputerButton) {
			idc = IDC_MMC_MAIL_SEND;
			text = "Send";
			x = "safeZoneX + safeZoneW - 0.34";
			y = "safeZoneY + 0.153";
			w = 0.06;
			h = 0.036;
			action = "call MMC_fnc_mailSendFromComposer";
		};

		class MailCancel: MailSend {
			idc = IDC_MMC_MAIL_CANCEL;
			text = "Cancel";
			x = "safeZoneX + safeZoneW - 0.275";
			action = "['table'] call MMC_fnc_renderMail";
		};

		class MailError: RscText {
			idc = IDC_MMC_MAIL_ERROR;
			shadow = 0;
			text = "";
			x = "safeZoneX + 0.445";
			y = "safeZoneY + safeZoneH - 0.16";
			w = "safeZoneW - 0.64";
			h = 0.032;
			sizeEx = 0.026;
			colorBackground[] = {0, 0, 0, 0};
			colorText[] = {1, 0.25, 0.25, 1};
		};

		class MediaBar: RscText {
			idc = IDC_MMC_MEDIA_BAR;
			shadow = 0;
			x = "safeZoneX + 0.43";
			y = "safeZoneY + safeZoneH - 0.175";
			w = "safeZoneW - 0.61";
			h = 0.055;
			colorBackground[] = {0.02, 0.025, 0.035, 0.96};
		};

		class MediaPrevious: GVAR(RscComputerButton) {
			idc = IDC_MMC_MEDIA_PREV;
			text = "<";
			tooltip = "Play previous media file.";
			x = "safeZoneX + 0.442";
			y = "safeZoneY + safeZoneH - 0.166";
			w = 0.04;
			h = 0.037;
			action = "[-1] call MMC_fnc_mediaNavigate";
		};

		class MediaPlay: MediaPrevious {
			idc = IDC_MMC_MEDIA_PLAY;
			text = "Play";
			tooltip = "Play selected audio.";
			x = "safeZoneX + 0.487";
			w = 0.055;
			action = "call MMC_fnc_mediaPlaySelected";
		};

		class MediaStop: MediaPlay {
			idc = IDC_MMC_MEDIA_STOP;
			text = "Stop";
			tooltip = "Stop media playback.";
			x = "safeZoneX + 0.547";
			action = "call MMC_fnc_mediaStop";
		};

		class MediaNext: MediaPrevious {
			idc = IDC_MMC_MEDIA_NEXT;
			text = ">";
			tooltip = "Play next media file.";
			x = "safeZoneX + 0.607";
			action = "[1] call MMC_fnc_mediaNavigate";
		};

		class MediaStatus: RscText {
			idc = IDC_MMC_MEDIA_STATUS;
			shadow = 0;
			text = "";
			x = "safeZoneX + 0.66";
			y = "safeZoneY + safeZoneH - 0.166";
			w = "safeZoneW - 0.85";
			h = 0.037;
			sizeEx = 0.026;
			colorBackground[] = {0, 0, 0, 0};
		};

		class StartButton: GVAR(RscComputerButton) {
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
			shadow = 0;
			text = "";
			x = "safeZoneX + 0.105";
			y = "safeZoneY + safeZoneH - 0.046";
			w = "safeZoneW - 0.35";
			h = 0.037;
			sizeEx = 0.027;
			colorBackground[] = {0, 0, 0, 0};
		};

		class Clock: RscText {
			idc = IDC_MMC_CLOCK;
			shadow = 0;
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
			shadow = 0;
			x = "safeZoneX + 0.012";
			y = "safeZoneY + safeZoneH - 0.153";
			w = 0.19;
			h = 0.098;
			colorBackground[] = {0.018, 0.022, 0.03, 0.98};
		};

		class StartBoot: GVAR(RscComputerButton) {
			idc = IDC_MMC_START_BOOT;
			text = "Turn On";
			x = "safeZoneX + 0.022";
			y = "safeZoneY + safeZoneH - 0.1";
			w = 0.17;
			h = 0.04;
			action = "call MMC_fnc_startup";
		};

		class StartLogout: GVAR(RscComputerButton) {
			idc = IDC_MMC_START_LOGOUT;
			text = "Log Out";
			x = "safeZoneX + 0.022";
			y = "safeZoneY + safeZoneH - 0.145";
			w = 0.17;
			h = 0.04;
			action = "call MMC_fnc_logoutCurrent";
		};

		class StartShutdown: StartLogout {
			idc = IDC_MMC_START_SHUTDOWN;
			text = "Shut Down";
			y = "safeZoneY + safeZoneH - 0.1";
			action = "call MMC_fnc_shutdown";
		};

		class PowerScreen: RscText {
			idc = IDC_MMC_POWER_SCREEN;
			shadow = 0;
			x = "safeZoneX";
			y = "safeZoneY";
			w = "safeZoneW";
			h = "safeZoneH";
			colorBackground[] = {0, 0, 0, 0.96};
		};

		class BootBarBackground: RscText {
			idc = IDC_MMC_BOOT_BAR_BG;
			shadow = 0;
			x = "safeZoneX + safeZoneW * 0.35";
			y = "safeZoneY + safeZoneH * 0.57";
			w = "safeZoneW * 0.3";
			h = 0.02;
			colorBackground[] = {1, 1, 1, 0.22};
		};

		class BootBarFill: RscText {
			idc = IDC_MMC_BOOT_BAR_FILL;
			shadow = 0;
			x = "safeZoneX + safeZoneW * 0.35";
			y = "safeZoneY + safeZoneH * 0.57";
			w = 0;
			h = 0.02;
			colorBackground[] = {0.13, 0.54, 0.21, 0.95};
		};

		class BootTitle: RscText {
			idc = IDC_MMC_BOOT_TITLE;
			shadow = 0;
			text = "";
			x = "safeZoneX";
			y = "safeZoneY + safeZoneH * 0.36";
			w = "safeZoneW";
			h = 0.08;
			sizeEx = 0.078;
			style = 2;
			colorBackground[] = {0, 0, 0, 0};
		};

		class BootStatus: RscText {
			idc = IDC_MMC_BOOT_STATUS;
			shadow = 0;
			text = "";
			x = "safeZoneX";
			y = "safeZoneY + safeZoneH * 0.445";
			w = "safeZoneW";
			h = 0.045;
			sizeEx = 0.045;
			style = 2;
			colorBackground[] = {0, 0, 0, 0};
		};

		class BootStage: RscText {
			idc = IDC_MMC_BOOT_STAGE;
			shadow = 0;
			text = "";
			x = "safeZoneX";
			y = "safeZoneY + safeZoneH * 0.595";
			w = "safeZoneW";
			h = 0.04;
			sizeEx = 0.036;
			style = 2;
			colorBackground[] = {0, 0, 0, 0};
		};

		class LoginPanel: RscText {
			idc = IDC_MMC_LOGIN_PANEL;
			shadow = 0;
			x = "safeZoneX + safeZoneW * 0.36";
			y = "safeZoneY + safeZoneH * 0.315";
			w = "safeZoneW * 0.28";
			h = "safeZoneH * 0.265";
			colorBackground[] = {0.02, 0.025, 0.035, 0.96};
		};

		class LoginTitle: RscText {
			idc = IDC_MMC_LOGIN_TITLE;
			shadow = 0;
			text = "Sign in";
			x = "safeZoneX + safeZoneW * 0.38";
			y = "safeZoneY + safeZoneH * 0.331";
			w = "safeZoneW * 0.24";
			h = 0.052;
			sizeEx = 0.052;
			style = 2;
			colorBackground[] = {0, 0, 0, 0};
		};

		class LoginUsernameLabel: RscText {
			idc = IDC_MMC_LOGIN_USERNAME_LABEL;
			shadow = 0;
			text = "Username";
			x = "safeZoneX + safeZoneW * 0.39";
			y = "safeZoneY + safeZoneH * 0.392";
			w = "safeZoneW * 0.22";
			h = 0.03;
			colorBackground[] = {0, 0, 0, 0};
		};

		class LoginUsername: RscEdit {
			idc = IDC_MMC_LOGIN_USERNAME;
			shadow = 0;
			x = "safeZoneX + safeZoneW * 0.39";
			y = "safeZoneY + safeZoneH * 0.416";
			w = "safeZoneW * 0.22";
			h = 0.04;
			colorBackground[] = {1, 1, 1, 0.08};
		};

		class LoginPasswordLabel: LoginUsernameLabel {
			idc = IDC_MMC_LOGIN_PASSWORD_LABEL;
			text = "Password";
			y = "safeZoneY + safeZoneH * 0.458";
		};

		class LoginPassword: LoginUsername {
			idc = IDC_MMC_LOGIN_PASSWORD;
			y = "safeZoneY + safeZoneH * 0.482";
			w = "safeZoneW * 0.184";
			onKeyUp = "call MMC_fnc_updatePasswordInput";
		};

		class LoginPasswordVisible: LoginPassword {
			idc = IDC_MMC_LOGIN_PASSWORD_VISIBLE;
			style = 0;
		};

		class LoginPasswordToggle: GVAR(RscComputerButton) {
			idc = IDC_MMC_LOGIN_PASSWORD_TOGGLE;
			text = "Show";
			tooltip = "Show or hide the password.";
			x = "safeZoneX + safeZoneW * 0.579";
			y = "safeZoneY + safeZoneH * 0.482";
			w = "safeZoneW * 0.031";
			h = 0.04;
			sizeEx = 0.022;
			action = "call MMC_fnc_togglePasswordVisibility";
		};

		class LoginButton: GVAR(RscComputerButton) {
			idc = IDC_MMC_LOGIN_BUTTON;
			text = "Login";
			x = "safeZoneX + safeZoneW * 0.448";
			y = "safeZoneY + safeZoneH * 0.545";
			w = "safeZoneW * 0.068";
			h = 0.052;
			sizeEx = 0.029;
			action = "call MMC_fnc_login";
		};

		class LoginShutdown: GVAR(RscComputerButton) {
			idc = IDC_MMC_LOGIN_SHUTDOWN;
			text = "Shut Down";
			tooltip = "Power off this computer.";
			x = "safeZoneX + safeZoneW * 0.548";
			y = "safeZoneY + safeZoneH * 0.545";
			w = "safeZoneW * 0.072";
			h = 0.052;
			sizeEx = 0.027;
			action = "call MMC_fnc_shutdown";
		};

		class LoginError: RscStructuredText {
			idc = IDC_MMC_LOGIN_ERROR;
			shadow = 0;
			text = "";
			x = "safeZoneX + safeZoneW * 0.39";
			y = "safeZoneY + safeZoneH * 0.525";
			w = "safeZoneW * 0.22";
			h = 0.028;
			size = 0.032;
			style = 2;
			colorBackground[] = {0, 0, 0, 0};
			colorText[] = {1, 0.25, 0.25, 1};
		};

		class FrameTaskbar: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_TASKBAR;
			x = "safeZoneX";
			y = "safeZoneY + safeZoneH - 0.055";
			w = "safeZoneW";
			h = 0.055;
		};

		class FrameFilesButton: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_BTN_FILES;
			x = "safeZoneX + 0.035";
			y = "safeZoneY + 0.09";
			w = 0.105;
			h = 0.05;
		};

		class FrameMailButton: FrameFilesButton {
			idc = IDC_MMC_FRAME_BTN_MAIL;
			y = "safeZoneY + 0.145";
		};

		class FrameMessagesButton: FrameFilesButton {
			idc = IDC_MMC_FRAME_BTN_MESSAGES;
			y = "safeZoneY + 0.2";
		};

		class FrameNotesButton: FrameFilesButton {
			idc = IDC_MMC_FRAME_BTN_NOTES;
			y = "safeZoneY + 0.255";
		};

		class FrameAppTitle: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_APP_TITLE;
			x = "safeZoneX + 0.18";
			y = "safeZoneY + 0.09";
			w = "safeZoneW - 0.36";
			h = 0.04;
		};

		class FrameCloseApp: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_CLOSE_APP;
			x = "safeZoneX + safeZoneW - 0.222";
			y = "safeZoneY + 0.09";
			w = 0.042;
			h = 0.04;
		};

		class FrameAppList: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_APP_LIST;
			x = "safeZoneX + 0.18";
			y = "safeZoneY + 0.135";
			w = 0.24;
			h = "safeZoneH - 0.245";
		};

		class FrameAppBody: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_APP_BODY;
			x = "safeZoneX + 0.43";
			y = "safeZoneY + 0.135";
			w = "safeZoneW - 0.61";
			h = "safeZoneH - 0.315";
		};

		class FrameFilePreviewImage: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_FILE_PREVIEW_IMAGE;
			x = "safeZoneX + 0.565";
			y = "safeZoneY + 0.2";
			w = 0.18;
			h = 0.135;
		};

		class FrameMailTable: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_MAIL_TABLE;
			x = "safeZoneX + 0.445";
			y = "safeZoneY + 0.19";
			w = "safeZoneW - 0.64";
			h = "safeZoneH - 0.37";
		};

		class FrameMediaBar: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_MEDIA_BAR;
			x = "safeZoneX + 0.43";
			y = "safeZoneY + safeZoneH - 0.175";
			w = "safeZoneW - 0.61";
			h = 0.055;
		};

		class FrameMediaPrevious: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_MEDIA_PREV;
			x = "safeZoneX + 0.442";
			y = "safeZoneY + safeZoneH - 0.166";
			w = 0.04;
			h = 0.037;
		};

		class FrameMediaPlay: FrameMediaPrevious {
			idc = IDC_MMC_FRAME_MEDIA_PLAY;
			x = "safeZoneX + 0.487";
			w = 0.055;
		};

		class FrameMediaStop: FrameMediaPlay {
			idc = IDC_MMC_FRAME_MEDIA_STOP;
			x = "safeZoneX + 0.547";
		};

		class FrameMediaNext: FrameMediaPrevious {
			idc = IDC_MMC_FRAME_MEDIA_NEXT;
			x = "safeZoneX + 0.607";
		};

		class FrameStartButton: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_START_BUTTON;
			x = "safeZoneX + 0.012";
			y = "safeZoneY + safeZoneH - 0.046";
			w = 0.08;
			h = 0.037;
		};

		class FrameStartMenu: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_START_MENU;
			x = "safeZoneX + 0.012";
			y = "safeZoneY + safeZoneH - 0.153";
			w = 0.19;
			h = 0.098;
		};

		class FrameStartBoot: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_START_BOOT;
			x = "safeZoneX + 0.022";
			y = "safeZoneY + safeZoneH - 0.1";
			w = 0.17;
			h = 0.04;
		};

		class FrameStartLogout: FrameStartBoot {
			idc = IDC_MMC_FRAME_START_LOGOUT;
			y = "safeZoneY + safeZoneH - 0.145";
		};

		class FrameStartShutdown: FrameStartBoot {
			idc = IDC_MMC_FRAME_START_SHUTDOWN;
			y = "safeZoneY + safeZoneH - 0.1";
		};

		class FrameLoginPanel: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_LOGIN_PANEL;
			x = "safeZoneX + safeZoneW * 0.36";
			y = "safeZoneY + safeZoneH * 0.315";
			w = "safeZoneW * 0.28";
			h = "safeZoneH * 0.265";
		};

		class FrameLoginUsername: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_LOGIN_USERNAME;
			x = "safeZoneX + safeZoneW * 0.39";
			y = "safeZoneY + safeZoneH * 0.416";
			w = "safeZoneW * 0.22";
			h = 0.04;
		};

		class FrameLoginPassword: FrameLoginUsername {
			idc = IDC_MMC_FRAME_LOGIN_PASSWORD;
			y = "safeZoneY + safeZoneH * 0.482";
			w = "safeZoneW * 0.184";
		};

		class FrameLoginPasswordToggle: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_LOGIN_PASSWORD_TOGGLE;
			x = "safeZoneX + safeZoneW * 0.579";
			y = "safeZoneY + safeZoneH * 0.482";
			w = "safeZoneW * 0.031";
			h = 0.04;
		};

		class FrameLoginButton: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_LOGIN_BUTTON;
			x = "safeZoneX + safeZoneW * 0.448";
			y = "safeZoneY + safeZoneH * 0.545";
			w = "safeZoneW * 0.068";
			h = 0.052;
		};

		class FrameLoginShutdown: GVAR(RscComputerFrame) {
			idc = IDC_MMC_FRAME_LOGIN_SHUTDOWN;
			x = "safeZoneX + safeZoneW * 0.548";
			y = "safeZoneY + safeZoneH * 0.545";
			w = "safeZoneW * 0.072";
			h = 0.052;
		};
	};
};

class GVAR(RscAddTextFileDialog): MMB_main_RscBaseDisplay {
	onLoad = "(_this select 0) setVariable ['MMB_main_populateFunction', 'MMC_fnc_guiAddTextFileDialog']; call MMB_fnc_initDisplay";
};

class GVAR(RscAddMailDialog): MMB_main_RscBaseDisplay {
	onLoad = "(_this select 0) setVariable ['MMB_main_populateFunction', 'MMC_fnc_guiAddMailDialog']; call MMB_fnc_initDisplay";
};
