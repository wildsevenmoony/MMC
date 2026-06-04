#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Shows a login-style notice for no-login computers without a configured user.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {};

[_display] call FUNC(clearCustomControls);
[_display, false] call FUNC(setSystemOverlay);
_display setVariable [QGVAR(startMenuOpen), false];

private _computer = _display getVariable [QGVAR(computer), objNull];
[_computer, "login"] call FUNC(setScreenState);

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _textColor = _themeConfig getOrDefault ["text", [0.92, 0.94, 0.97, 1]];
(_display displayCtrl IDC_MMC_DESKTOP_IMAGE) ctrlSetText (_themeConfig getOrDefault ["backgroundTexture", PATHTOF(img\desktop_default_dark.paa)]);
[_display] call FUNC(applyTheme);

{
	(_display displayCtrl _x) ctrlShow false;
} forEach [
	IDC_MMC_TASKBAR,
	IDC_MMC_START_BUTTON,
	IDC_MMC_USER,
	IDC_MMC_CLOCK,
	IDC_MMC_BTN_FILES,
	IDC_MMC_BTN_MAIL,
	IDC_MMC_BTN_MESSAGES,
	IDC_MMC_BTN_NOTES,
	IDC_MMC_APP_TITLE,
	IDC_MMC_BTN_CLOSE_APP,
	IDC_MMC_APP_LIST,
	IDC_MMC_APP_BODY,
	IDC_MMC_MEDIA_BAR,
	IDC_MMC_MEDIA_PREV,
	IDC_MMC_MEDIA_PLAY,
	IDC_MMC_MEDIA_STOP,
	IDC_MMC_MEDIA_NEXT,
	IDC_MMC_MEDIA_STATUS,
	IDC_MMC_DESKTOP_CONTENT_GROUP,
	IDC_MMC_FILE_PREVIEW_IMAGE,
	IDC_MMC_FILE_DESCRIPTION_GROUP,
	IDC_MMC_MAIL_HEADER,
	IDC_MMC_MAIL_TABLE,
	IDC_MMC_MAIL_REPLY,
	IDC_MMC_MAIL_FORWARD,
	IDC_MMC_MAIL_RECIPIENT_LABEL,
	IDC_MMC_MAIL_RECIPIENT,
	IDC_MMC_MAIL_CC_LABEL,
	IDC_MMC_MAIL_CC,
	IDC_MMC_MAIL_SUBJECT_LABEL,
	IDC_MMC_MAIL_SUBJECT,
	IDC_MMC_MAIL_ATTACHMENT_LABEL,
	IDC_MMC_MAIL_ATTACHMENT,
	IDC_MMC_MAIL_ATTACHMENT_DESC_LABEL,
	IDC_MMC_MAIL_ATTACHMENT_DESC,
	IDC_MMC_MAIL_BODY_LABEL,
	IDC_MMC_MAIL_BODY_HINT,
	IDC_MMC_MAIL_BODY_GROUP,
	IDC_MMC_MAIL_BODY,
	IDC_MMC_MAIL_READ_META,
	IDC_MMC_MAIL_READ_GROUP,
	IDC_MMC_MAIL_SEND,
	IDC_MMC_MAIL_CANCEL,
	IDC_MMC_MAIL_ERROR,
	IDC_MMC_START_MENU,
	IDC_MMC_FRAME_START_MENU,
	IDC_MMC_START_BOOT,
	IDC_MMC_FRAME_START_BOOT,
	IDC_MMC_START_LOGOUT,
	IDC_MMC_FRAME_START_LOGOUT,
	IDC_MMC_START_SHUTDOWN,
	IDC_MMC_FRAME_START_SHUTDOWN,
	IDC_MMC_FRAME_TASKBAR,
	IDC_MMC_FRAME_BTN_FILES,
	IDC_MMC_FRAME_BTN_MAIL,
	IDC_MMC_FRAME_BTN_MESSAGES,
	IDC_MMC_FRAME_BTN_NOTES,
	IDC_MMC_FRAME_APP_TITLE,
	IDC_MMC_FRAME_CLOSE_APP,
	IDC_MMC_FRAME_APP_LIST,
	IDC_MMC_FRAME_APP_BODY,
	IDC_MMC_FRAME_MEDIA_BAR,
	IDC_MMC_FRAME_MEDIA_PREV,
	IDC_MMC_FRAME_MEDIA_PLAY,
	IDC_MMC_FRAME_MEDIA_STOP,
	IDC_MMC_FRAME_MEDIA_NEXT,
	IDC_MMC_FRAME_FILE_PREVIEW_IMAGE,
	IDC_MMC_FRAME_FILE_DESCRIPTION,
	IDC_MMC_FRAME_MAIL_TABLE,
	IDC_MMC_FRAME_START_BUTTON,
	IDC_MMC_LOGIN_USERNAME_LABEL,
	IDC_MMC_LOGIN_USERNAME,
	IDC_MMC_FRAME_LOGIN_USERNAME,
	IDC_MMC_LOGIN_PASSWORD_LABEL,
	IDC_MMC_LOGIN_PASSWORD,
	IDC_MMC_LOGIN_PASSWORD_VISIBLE,
	IDC_MMC_FRAME_LOGIN_PASSWORD,
	IDC_MMC_LOGIN_PASSWORD_TOGGLE,
	IDC_MMC_FRAME_LOGIN_PASSWORD_TOGGLE,
	IDC_MMC_LOGIN_BUTTON,
	IDC_MMC_FRAME_LOGIN_BUTTON
];

{
	(_display displayCtrl _x) ctrlShow true;
} forEach [
	IDC_MMC_LOGIN_PANEL,
	IDC_MMC_FRAME_LOGIN_PANEL,
	IDC_MMC_LOGIN_TITLE,
	IDC_MMC_LOGIN_ERROR,
	IDC_MMC_LOGIN_SHUTDOWN,
	IDC_MMC_FRAME_LOGIN_SHUTDOWN
];

private _title = _display displayCtrl IDC_MMC_LOGIN_TITLE;
private _message = _display displayCtrl IDC_MMC_LOGIN_ERROR;
private _shutdown = _display displayCtrl IDC_MMC_LOGIN_SHUTDOWN;
private _shutdownFrame = _display displayCtrl IDC_MMC_FRAME_LOGIN_SHUTDOWN;

_title ctrlSetText "No user configured";
_message ctrlSetTextColor _textColor;
_message ctrlSetStructuredText parseText "<t align='center' size='1.08'>This computer has no login screen and needs one directly synced Add User module.</t>";

_message ctrlSetPosition [
	safeZoneX + safeZoneW * 0.39,
	safeZoneY + safeZoneH * 0.41,
	safeZoneW * 0.22,
	0.085
];
_message ctrlCommit 0;

{
	_x ctrlSetPosition [
		safeZoneX + safeZoneW * 0.455,
		safeZoneY + safeZoneH * 0.52,
		safeZoneW * 0.09,
		0.052
	];
	_x ctrlCommit 0;
} forEach [_shutdown, _shutdownFrame];

_shutdown ctrlSetText "Shut Down";
ctrlSetFocus _shutdown;
