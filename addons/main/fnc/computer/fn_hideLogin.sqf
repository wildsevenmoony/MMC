#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Hides the login controls and restores the desktop shell.
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {};

{
	(_display displayCtrl _x) ctrlShow false;
} forEach [
	IDC_MMC_LOGIN_PANEL,
	IDC_MMC_LOGIN_TITLE,
	IDC_MMC_LOGIN_USERNAME_LABEL,
	IDC_MMC_LOGIN_USERNAME,
	IDC_MMC_LOGIN_PASSWORD_LABEL,
	IDC_MMC_LOGIN_PASSWORD,
	IDC_MMC_LOGIN_PASSWORD_VISIBLE,
	IDC_MMC_FRAME_LOGIN_PASSWORD,
	IDC_MMC_LOGIN_PASSWORD_TOGGLE,
	IDC_MMC_FRAME_LOGIN_PASSWORD_TOGGLE,
	IDC_MMC_LOGIN_BUTTON,
	IDC_MMC_FRAME_LOGIN_BUTTON,
	IDC_MMC_LOGIN_ERROR,
	IDC_MMC_FRAME_LOGIN_PANEL,
	IDC_MMC_FRAME_LOGIN_USERNAME
];

private _computer = _display getVariable [QGVAR(computer), objNull];
[_computer, "desktop"] call FUNC(setScreenState);

private _data = _display getVariable [QGVAR(data), createHashMap];
private _activeUser = [_computer] call FUNC(getActiveUser);
private _systemName = _data getOrDefault ["systemName", "MMC Workstation"];
private _username = _activeUser getOrDefault ["username", GVAR(profileLoginName)];

(_display displayCtrl IDC_MMC_USER) ctrlSetText format ["%1  |  %2", _username, _systemName];

private _background = _activeUser getOrDefault ["background", ""];
if (_background isEqualTo "") then {
	_background = _data getOrDefault ["background", ""];
};
(_display displayCtrl IDC_MMC_DESKTOP_IMAGE) ctrlSetText ([_background] call FUNC(getBackgroundPath));

[_display] call FUNC(applyTheme);

{
	(_display displayCtrl _x) ctrlShow true;
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
	IDC_MMC_FRAME_TASKBAR,
	IDC_MMC_FRAME_BTN_FILES,
	IDC_MMC_FRAME_BTN_MAIL,
	IDC_MMC_FRAME_BTN_MESSAGES,
	IDC_MMC_FRAME_BTN_NOTES,
	IDC_MMC_FRAME_APP_TITLE,
	IDC_MMC_FRAME_CLOSE_APP,
	IDC_MMC_FRAME_APP_LIST,
	IDC_MMC_FRAME_APP_BODY,
	IDC_MMC_FRAME_START_BUTTON
];
