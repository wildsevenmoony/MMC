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
_display setVariable [QGVAR(computer), _computer];
_display setVariable [QGVAR(data), _data];
_display setVariable [QGVAR(currentApp), "desktop"];
_display setVariable [QGVAR(startMenuOpen), false];

private _activeUser = [_computer] call FUNC(getActiveUser);
_display setVariable [QGVAR(activeUser), _activeUser];

private _background = _data getOrDefault ["background", ""];
if (count _activeUser > 0) then {
	_background = _activeUser getOrDefault ["background", _background];
};
_background = [_background] call FUNC(getBackgroundPath);
(_display displayCtrl IDC_MMC_DESKTOP_IMAGE) ctrlSetText _background;

[_display] call FUNC(applyTheme);

{
	(_display displayCtrl _x) ctrlShow false;
} forEach [
	IDC_MMC_START_MENU,
	IDC_MMC_START_BOOT,
	IDC_MMC_START_SHUTDOWN,
	IDC_MMC_LOGIN_PANEL,
	IDC_MMC_LOGIN_TITLE,
	IDC_MMC_LOGIN_USERNAME_LABEL,
	IDC_MMC_LOGIN_USERNAME,
	IDC_MMC_LOGIN_PASSWORD_LABEL,
	IDC_MMC_LOGIN_PASSWORD,
	IDC_MMC_LOGIN_BUTTON,
	IDC_MMC_LOGIN_ERROR
];

[] call FUNC(updateClock);

if (count _activeUser == 0) then {
	[_display] call FUNC(showLogin);
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
