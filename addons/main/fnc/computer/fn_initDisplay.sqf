#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Initializes the MMC computer dialog.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {};

uiNamespace setVariable [QGVAR(display), _display];

private _computer = GVAR(activeComputer);
private _data = _computer getVariable [QGVAR(data), [createHashMap] call FUNC(createDefaultData)];
private _loginRequired = _data getOrDefault ["loginRequired", true];
_display setVariable [QGVAR(computer), _computer];
_display setVariable [QGVAR(data), _data];
_display setVariable [QGVAR(currentApp), "desktop"];
_display setVariable [QGVAR(startMenuOpen), false];

private _activeUser = [_computer] call FUNC(getActiveUser);
_display setVariable [QGVAR(activeUser), _activeUser];

private _themeConfig = [_display] call FUNC(getThemeConfig);
(_display displayCtrl IDC_MMC_DESKTOP_IMAGE) ctrlSetText (_themeConfig getOrDefault ["backgroundTexture", PATHTOF(img\desktop_default_dark.paa)]);

[_display] call FUNC(applyTheme);

{
	(_display displayCtrl _x) ctrlShow false;
} forEach [
	IDC_MMC_START_MENU,
	IDC_MMC_FRAME_START_MENU,
	IDC_MMC_START_BOOT,
	IDC_MMC_FRAME_START_BOOT,
	IDC_MMC_START_LOGOUT,
	IDC_MMC_FRAME_START_LOGOUT,
	IDC_MMC_START_SHUTDOWN,
	IDC_MMC_FRAME_START_SHUTDOWN,
	IDC_MMC_MEDIA_BAR,
	IDC_MMC_MEDIA_PREV,
	IDC_MMC_MEDIA_PLAY,
	IDC_MMC_MEDIA_STOP,
	IDC_MMC_MEDIA_NEXT,
	IDC_MMC_MEDIA_STATUS,
	IDC_MMC_FRAME_MEDIA_BAR,
	IDC_MMC_FRAME_MEDIA_PREV,
	IDC_MMC_FRAME_MEDIA_PLAY,
	IDC_MMC_FRAME_MEDIA_STOP,
	IDC_MMC_FRAME_MEDIA_NEXT,
	IDC_MMC_DESKTOP_CONTENT_GROUP,
	IDC_MMC_FILE_PREVIEW_IMAGE,
	IDC_MMC_FRAME_FILE_PREVIEW_IMAGE,
	IDC_MMC_FILE_DESCRIPTION_GROUP,
	IDC_MMC_FRAME_FILE_DESCRIPTION,
	IDC_MMC_MAIL_HEADER,
	IDC_MMC_MAIL_TABLE,
	IDC_MMC_FRAME_MAIL_TABLE,
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
	IDC_MMC_LOGIN_PANEL,
	IDC_MMC_FRAME_LOGIN_PANEL,
	IDC_MMC_LOGIN_TITLE,
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
	IDC_MMC_FRAME_LOGIN_BUTTON,
	IDC_MMC_LOGIN_SHUTDOWN,
	IDC_MMC_FRAME_LOGIN_SHUTDOWN,
	IDC_MMC_LOGIN_ERROR
];

[] call FUNC(updateClock);

if (_computer getVariable [QGVAR(booting), false]) exitWith {
	[_display, true, ["MMC", "Starting system...", "Powering hardware interfaces"], 0.08] call FUNC(setSystemOverlay);
};

if (count _activeUser == 0) then {
	if (_loginRequired) then {
		[_display] call FUNC(showLogin);
	} else {
		[_display] call FUNC(showNoUser);
	};
} else {
	[_display] call FUNC(hideLogin);
	["desktop"] call FUNC(renderApp);
};

[_display] spawn {
	params ["_display"];
	while {!isNull _display} do {
		[] call MMC_fnc_updateClock;
		uiSleep 15;
	};
};
