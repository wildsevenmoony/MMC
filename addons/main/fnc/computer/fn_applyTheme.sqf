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

private _theme = GVAR(profileTheme);
private _isLight = _theme isEqualTo "light";
private _isUser = _theme isEqualTo "user";
private _accent = [
	profileNamespace getVariable ["GUI_BCG_RGB_R", 0.13],
	profileNamespace getVariable ["GUI_BCG_RGB_G", 0.54],
	profileNamespace getVariable ["GUI_BCG_RGB_B", 0.21],
	profileNamespace getVariable ["GUI_BCG_RGB_A", 0.8]
];

private _desktop = [0.035, 0.075, 0.115, 1];
private _panel = [0.02, 0.025, 0.035, 0.94];
private _panelStrong = [0.015, 0.018, 0.024, 0.98];
private _text = [0.92, 0.94, 0.97, 1];
private _tint = [0, 0, 0, 0];
private _button = [0.028, 0.032, 0.042, 0.98];

if (_isLight) then {
	_desktop = [0.9, 0.92, 0.94, 1];
	_panel = [0.98, 0.985, 0.99, 0.94];
	_panelStrong = [0.84, 0.86, 0.88, 0.98];
	_text = [0.035, 0.04, 0.05, 1];
	_tint = [0, 0, 0, 0];
	_button = [0.88, 0.895, 0.91, 0.98];
};

if (_isUser) then {
	_desktop = [0.035, 0.075, 0.115, 1];
	_panel = [0.02, 0.025, 0.035, 0.94];
	_panelStrong = [0.015, 0.018, 0.024, 0.98];
	_text = [0.92, 0.94, 0.97, 1];
	_tint = [0, 0, 0, 0];
	_button = _accent;
};

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
