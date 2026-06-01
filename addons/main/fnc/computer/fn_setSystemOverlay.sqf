#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Shows or hides the fullscreen boot/shutdown overlay and desktop chrome.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Show overlay <BOOL>
 * 2: Overlay text <STRING, default: "">
 * 3: Progress value 0..1, negative hides boot bar <NUMBER, default: -1>
 *
 * Return Value:
 * None
 */

params [
	["_display", displayNull, [displayNull]],
	["_show", false, [false]],
	["_text", "", [""]],
	["_progress", -1, [0]]
];

if (isNull _display) exitWith {};

private _desktopControls = [
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
	IDC_MMC_APP_BODY
];

{
	(_display displayCtrl _x) ctrlShow !_show;
} forEach _desktopControls;

if (_show) then {
	{
		(_display displayCtrl _x) ctrlShow false;
	} forEach [IDC_MMC_START_MENU, IDC_MMC_START_BOOT, IDC_MMC_START_SHUTDOWN];
} else {
	private _menuOpen = _display getVariable [QGVAR(startMenuOpen), false];
	private _computer = _display getVariable [QGVAR(computer), objNull];
	private _poweredOn = _computer getVariable [QGVAR(poweredOn), true];
	private _booting = _computer getVariable [QGVAR(booting), false];

	(_display displayCtrl IDC_MMC_START_MENU) ctrlShow _menuOpen;
	(_display displayCtrl IDC_MMC_START_BOOT) ctrlShow (_menuOpen && {!_poweredOn} && {!_booting});
	(_display displayCtrl IDC_MMC_START_SHUTDOWN) ctrlShow (_menuOpen && {_poweredOn});
};

private _powerScreen = _display displayCtrl IDC_MMC_POWER_SCREEN;
private _barBg = _display displayCtrl IDC_MMC_BOOT_BAR_BG;
private _barFill = _display displayCtrl IDC_MMC_BOOT_BAR_FILL;

_powerScreen ctrlShow _show;
_barBg ctrlShow (_show && {_progress >= 0});
_barFill ctrlShow (_show && {_progress >= 0});

if (_show) then {
	_powerScreen ctrlSetStructuredText parseText _text;

	if (_progress >= 0) then {
		private _safeProgress = 0 max _progress min 1;
		_barFill ctrlSetPositionW (safeZoneW * 0.3 * _safeProgress);
		_barFill ctrlCommit 0.15;
	};
};
