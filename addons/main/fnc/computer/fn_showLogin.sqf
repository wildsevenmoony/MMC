#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Shows the login screen and hides the desktop shell.
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {};

[_display, false] call FUNC(setSystemOverlay);
_display setVariable [QGVAR(startMenuOpen), false];

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
	IDC_MMC_START_MENU,
	IDC_MMC_START_BOOT,
	IDC_MMC_START_SHUTDOWN
];

{
	(_display displayCtrl _x) ctrlShow true;
} forEach [
	IDC_MMC_LOGIN_PANEL,
	IDC_MMC_LOGIN_TITLE,
	IDC_MMC_LOGIN_USERNAME_LABEL,
	IDC_MMC_LOGIN_USERNAME,
	IDC_MMC_LOGIN_PASSWORD_LABEL,
	IDC_MMC_LOGIN_PASSWORD,
	IDC_MMC_LOGIN_BUTTON,
	IDC_MMC_LOGIN_ERROR
];

(_display displayCtrl IDC_MMC_LOGIN_USERNAME) ctrlSetText GVAR(profileLoginName);
(_display displayCtrl IDC_MMC_LOGIN_PASSWORD) ctrlSetText "";
(_display displayCtrl IDC_MMC_LOGIN_ERROR) ctrlSetText "";
ctrlSetFocus (_display displayCtrl IDC_MMC_LOGIN_USERNAME);
