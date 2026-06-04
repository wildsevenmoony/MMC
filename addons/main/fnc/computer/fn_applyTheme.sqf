#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Applies the resolved MMC layout colors to the display.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {};

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _isLight = _themeConfig getOrDefault ["isLight", false];
private _desktop = _themeConfig getOrDefault ["desktop", [0.035, 0.075, 0.115, 1]];
private _panel = _themeConfig getOrDefault ["panel", [0.02, 0.025, 0.035, 0.94]];
private _panelStrong = _themeConfig getOrDefault ["panelStrong", [0.015, 0.018, 0.024, 0.98]];
private _text = _themeConfig getOrDefault ["text", [0.92, 0.94, 0.97, 1]];
private _tint = _themeConfig getOrDefault ["tint", [0, 0, 0, 0]];
private _button = _themeConfig getOrDefault ["button", [0.028, 0.032, 0.042, 0.98]];
private _buttonText = _themeConfig getOrDefault ["buttonText", _text];
private _bootAccent = _themeConfig getOrDefault ["bootAccent", [0.13, 0.54, 0.21, 0.95]];
private _border = _themeConfig getOrDefault ["border", [0, 0, 0, 0.85]];
private _bootBarBg = _themeConfig getOrDefault ["bootBarBg", [1, 1, 1, 0.22]];

(_display displayCtrl IDC_MMC_DESKTOP_BG) ctrlSetBackgroundColor _desktop;
(_display displayCtrl IDC_MMC_DESKTOP_TINT) ctrlSetBackgroundColor _tint;
(_display displayCtrl IDC_MMC_TASKBAR) ctrlSetBackgroundColor _panelStrong;
(_display displayCtrl IDC_MMC_APP_TITLE) ctrlSetBackgroundColor _panelStrong;
(_display displayCtrl IDC_MMC_APP_TITLE) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_APP_LIST) ctrlSetBackgroundColor _panel;
(_display displayCtrl IDC_MMC_APP_LIST) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_APP_BODY) ctrlSetBackgroundColor _panel;
(_display displayCtrl IDC_MMC_APP_BODY) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_DESKTOP_CONTENT_BODY) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_FILE_DESCRIPTION_BODY) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_TABLE) ctrlSetBackgroundColor _panel;
(_display displayCtrl IDC_MMC_MAIL_TABLE) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_HEADER) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_RECIPIENT_LABEL) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_CC_LABEL) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_SUBJECT_LABEL) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_ATTACHMENT_LABEL) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_ATTACHMENT_DESC_LABEL) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_BODY_LABEL) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_BODY_HINT) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_RECIPIENT) ctrlSetBackgroundColor _panel;
(_display displayCtrl IDC_MMC_MAIL_RECIPIENT) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_CC) ctrlSetBackgroundColor _panel;
(_display displayCtrl IDC_MMC_MAIL_CC) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_SUBJECT) ctrlSetBackgroundColor _panel;
(_display displayCtrl IDC_MMC_MAIL_SUBJECT) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_ATTACHMENT) ctrlSetBackgroundColor _panel;
(_display displayCtrl IDC_MMC_MAIL_ATTACHMENT) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_ATTACHMENT_DESC) ctrlSetBackgroundColor _panel;
(_display displayCtrl IDC_MMC_MAIL_ATTACHMENT_DESC) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_BODY) ctrlSetBackgroundColor _panel;
(_display displayCtrl IDC_MMC_MAIL_BODY) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_READ_META) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MAIL_READ_BODY) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_MEDIA_BAR) ctrlSetBackgroundColor _panelStrong;
(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_USER) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_CLOCK) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_START_MENU) ctrlSetBackgroundColor _panelStrong;
(_display displayCtrl IDC_MMC_LOGIN_PANEL) ctrlSetBackgroundColor _panelStrong;
(_display displayCtrl IDC_MMC_LOGIN_TITLE) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_LOGIN_USERNAME_LABEL) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_LOGIN_PASSWORD_LABEL) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_LOGIN_USERNAME) ctrlSetBackgroundColor _panel;
(_display displayCtrl IDC_MMC_LOGIN_USERNAME) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_LOGIN_PASSWORD) ctrlSetBackgroundColor _panel;
(_display displayCtrl IDC_MMC_LOGIN_PASSWORD) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_LOGIN_PASSWORD_VISIBLE) ctrlSetBackgroundColor _panel;
(_display displayCtrl IDC_MMC_LOGIN_PASSWORD_VISIBLE) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_LOGIN_ERROR) ctrlSetTextColor [1, 0.25, 0.25, 1];

{
	(_display displayCtrl _x) ctrlSetTextColor _text;
} forEach [
	IDC_MMC_BOOT_TITLE,
	IDC_MMC_BOOT_STATUS,
	IDC_MMC_BOOT_STAGE
];

{
	private _ctrl = _display displayCtrl _x;
	_ctrl ctrlSetBackgroundColor _button;
	_ctrl ctrlSetTextColor _buttonText;
	_ctrl ctrlSetActiveColor _buttonText;
} forEach [
	IDC_MMC_BTN_FILES,
	IDC_MMC_BTN_MAIL,
	IDC_MMC_BTN_MESSAGES,
	IDC_MMC_BTN_NOTES,
	IDC_MMC_BTN_CLOSE_APP,
	IDC_MMC_MEDIA_PREV,
	IDC_MMC_MEDIA_PLAY,
	IDC_MMC_MEDIA_STOP,
	IDC_MMC_MEDIA_NEXT,
	IDC_MMC_MAIL_REPLY,
	IDC_MMC_MAIL_FORWARD,
	IDC_MMC_MAIL_SEND,
	IDC_MMC_MAIL_CANCEL,
	IDC_MMC_START_BUTTON,
	IDC_MMC_START_BOOT,
	IDC_MMC_START_LOGOUT,
	IDC_MMC_START_SHUTDOWN,
	IDC_MMC_LOGIN_PASSWORD_TOGGLE,
	IDC_MMC_LOGIN_BUTTON,
	IDC_MMC_LOGIN_SHUTDOWN
];

private _powerBackground = _themeConfig getOrDefault ["powerBackground", if (_isLight) then {[0.9, 0.92, 0.94, 0.96]} else {[0, 0, 0, 0.96]}];
(_display displayCtrl IDC_MMC_POWER_SCREEN) ctrlSetBackgroundColor _powerBackground;
(_display displayCtrl IDC_MMC_BOOT_BAR_BG) ctrlSetBackgroundColor _bootBarBg;
(_display displayCtrl IDC_MMC_BOOT_BAR_FILL) ctrlSetBackgroundColor _bootAccent;

{
	(_display displayCtrl _x) ctrlSetForegroundColor _border;
} forEach [
	IDC_MMC_TASKBAR,
	IDC_MMC_APP_TITLE,
	IDC_MMC_APP_LIST,
	IDC_MMC_APP_BODY,
	IDC_MMC_MEDIA_BAR,
	IDC_MMC_MEDIA_PREV,
	IDC_MMC_MEDIA_PLAY,
	IDC_MMC_MEDIA_STOP,
	IDC_MMC_MEDIA_NEXT,
	IDC_MMC_START_MENU,
	IDC_MMC_BTN_FILES,
	IDC_MMC_BTN_MAIL,
	IDC_MMC_BTN_MESSAGES,
	IDC_MMC_BTN_NOTES,
	IDC_MMC_BTN_CLOSE_APP,
	IDC_MMC_START_BUTTON,
	IDC_MMC_START_BOOT,
	IDC_MMC_START_LOGOUT,
	IDC_MMC_START_SHUTDOWN,
	IDC_MMC_BOOT_BAR_BG,
	IDC_MMC_LOGIN_PANEL,
	IDC_MMC_LOGIN_USERNAME,
	IDC_MMC_LOGIN_PASSWORD,
	IDC_MMC_LOGIN_PASSWORD_VISIBLE,
	IDC_MMC_LOGIN_PASSWORD_TOGGLE,
	IDC_MMC_LOGIN_BUTTON,
	IDC_MMC_LOGIN_SHUTDOWN
];

{
	(_display displayCtrl _x) ctrlSetTextColor _border;
} forEach [
	IDC_MMC_FRAME_TASKBAR,
	IDC_MMC_FRAME_BTN_FILES,
	IDC_MMC_FRAME_BTN_MAIL,
	IDC_MMC_FRAME_BTN_MESSAGES,
	IDC_MMC_FRAME_BTN_NOTES,
	IDC_MMC_FRAME_APP_TITLE,
	IDC_MMC_FRAME_CLOSE_APP,
	IDC_MMC_FRAME_APP_LIST,
	IDC_MMC_FRAME_APP_BODY,
	IDC_MMC_FRAME_FILE_PREVIEW_IMAGE,
	IDC_MMC_FRAME_FILE_DESCRIPTION,
	IDC_MMC_FRAME_MAIL_TABLE,
	IDC_MMC_FRAME_MEDIA_BAR,
	IDC_MMC_FRAME_MEDIA_PREV,
	IDC_MMC_FRAME_MEDIA_PLAY,
	IDC_MMC_FRAME_MEDIA_STOP,
	IDC_MMC_FRAME_MEDIA_NEXT,
	IDC_MMC_FRAME_START_BUTTON,
	IDC_MMC_FRAME_START_MENU,
	IDC_MMC_FRAME_START_BOOT,
	IDC_MMC_FRAME_START_LOGOUT,
	IDC_MMC_FRAME_START_SHUTDOWN,
	IDC_MMC_FRAME_LOGIN_PANEL,
	IDC_MMC_FRAME_LOGIN_USERNAME,
	IDC_MMC_FRAME_LOGIN_PASSWORD,
	IDC_MMC_FRAME_LOGIN_PASSWORD_TOGGLE,
	IDC_MMC_FRAME_LOGIN_BUTTON,
	IDC_MMC_FRAME_LOGIN_SHUTDOWN
];
