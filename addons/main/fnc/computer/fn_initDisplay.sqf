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

private _user = _display displayCtrl IDC_MMC_USER;
_user ctrlSetText format ["%1  |  %2", GVAR(profileLoginName), _data getOrDefault ["systemName", "MMC Workstation"]];

private _background = _data getOrDefault ["background", ""];
_background = [_background] call FUNC(getBackgroundPath);
(_display displayCtrl IDC_MMC_DESKTOP_IMAGE) ctrlSetText _background;

[_display] call FUNC(applyTheme);

{
	(_display displayCtrl _x) ctrlShow false;
} forEach [IDC_MMC_START_MENU, IDC_MMC_START_BOOT, IDC_MMC_START_SHUTDOWN];

[] call FUNC(updateClock);
["desktop"] call FUNC(renderApp);

[_display] spawn {
	params ["_display"];
	while {!isNull _display} do {
		[] call MMC_fnc_updateClock;
		uiSleep 15;
	};
};
