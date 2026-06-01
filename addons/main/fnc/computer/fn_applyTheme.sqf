#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Applies the client's MMC theme and optional Arma layout color to the display.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {};

private _isLight = GVAR(profileTheme) isEqualTo "light";
private _accent = [
	profileNamespace getVariable ["GUI_BCG_RGB_R", 0.13],
	profileNamespace getVariable ["GUI_BCG_RGB_G", 0.54],
	profileNamespace getVariable ["GUI_BCG_RGB_B", 0.21],
	profileNamespace getVariable ["GUI_BCG_RGB_A", 0.8]
];

private _desktop = if (_isLight) then {[0.82, 0.86, 0.88, 1]} else {[0.035, 0.075, 0.115, 1]};
private _panel = if (_isLight) then {[0.93, 0.94, 0.95, 0.94]} else {[0.02, 0.025, 0.035, 0.94]};
private _panelStrong = if (_isLight) then {[0.86, 0.88, 0.9, 0.98]} else {[0.015, 0.018, 0.024, 0.98]};
private _text = if (_isLight) then {[0.04, 0.05, 0.06, 1]} else {[0.92, 0.94, 0.97, 1]};
private _tint = if (_isLight) then {[1, 1, 1, 0.08]} else {[0, 0, 0, 0.18]};
private _button = [_panelStrong, _accent] select GVAR(useLayoutColors);

(_display displayCtrl IDC_MMC_DESKTOP_BG) ctrlSetBackgroundColor _desktop;
(_display displayCtrl IDC_MMC_DESKTOP_TINT) ctrlSetBackgroundColor _tint;
(_display displayCtrl IDC_MMC_TASKBAR) ctrlSetBackgroundColor _panelStrong;
(_display displayCtrl IDC_MMC_APP_TITLE) ctrlSetBackgroundColor _panelStrong;
(_display displayCtrl IDC_MMC_APP_TITLE) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_APP_LIST) ctrlSetBackgroundColor _panel;
(_display displayCtrl IDC_MMC_APP_LIST) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_APP_BODY) ctrlSetBackgroundColor _panel;
(_display displayCtrl IDC_MMC_APP_BODY) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_USER) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_CLOCK) ctrlSetTextColor _text;
(_display displayCtrl IDC_MMC_START_MENU) ctrlSetBackgroundColor _panelStrong;

{
	private _ctrl = _display displayCtrl _x;
	_ctrl ctrlSetBackgroundColor _button;
	_ctrl ctrlSetTextColor _text;
} forEach [
	IDC_MMC_BTN_FILES,
	IDC_MMC_BTN_MAIL,
	IDC_MMC_BTN_MESSAGES,
	IDC_MMC_BTN_NOTES,
	IDC_MMC_BTN_CLOSE_APP,
	IDC_MMC_START_BUTTON,
	IDC_MMC_START_BOOT,
	IDC_MMC_START_SHUTDOWN
];

private _powerBackground = if (_isLight) then {[0.9, 0.92, 0.94, 0.96]} else {[0, 0, 0, 0.96]};
(_display displayCtrl IDC_MMC_POWER_SCREEN) ctrlSetBackgroundColor _powerBackground;
