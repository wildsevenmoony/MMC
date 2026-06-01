#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Shows or hides the fullscreen boot/shutdown overlay and desktop chrome.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Show overlay <BOOL>
 * 2: Overlay text data <STRING or ARRAY [title,status,stage], default: "">
 * 3: Progress value 0..1, negative hides boot bar <NUMBER, default: -1>
 *
 * Return Value:
 * None
 */

params [
	["_display", displayNull, [displayNull]],
	["_show", false, [false]],
	["_text", "", ["", []]],
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

private _loginControls = [
	IDC_MMC_LOGIN_PANEL,
	IDC_MMC_LOGIN_TITLE,
	IDC_MMC_LOGIN_USERNAME_LABEL,
	IDC_MMC_LOGIN_USERNAME,
	IDC_MMC_LOGIN_PASSWORD_LABEL,
	IDC_MMC_LOGIN_PASSWORD,
	IDC_MMC_LOGIN_BUTTON,
	IDC_MMC_LOGIN_ERROR
];

{
	(_display displayCtrl _x) ctrlShow !_show;
} forEach _desktopControls;

if (_show) then {
	{
		(_display displayCtrl _x) ctrlShow false;
	} forEach ([IDC_MMC_START_MENU, IDC_MMC_START_BOOT, IDC_MMC_START_SHUTDOWN] + _loginControls);
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
private _title = _display displayCtrl IDC_MMC_BOOT_TITLE;
private _status = _display displayCtrl IDC_MMC_BOOT_STATUS;
private _stage = _display displayCtrl IDC_MMC_BOOT_STAGE;
private _theme = GVAR(profileTheme);
private _isLight = _theme isEqualTo "light";

_powerScreen ctrlShow _show;
_barBg ctrlShow (_show && {_progress >= 0});
_barFill ctrlShow (_show && {_progress >= 0});
_title ctrlShow _show;
_status ctrlShow _show;
_stage ctrlShow _show;

if (_show) then {
	private _textColor = if (_isLight) then {[0.035, 0.04, 0.05, 1]} else {[0.92, 0.94, 0.97, 1]};
	private _overlayColor = if (_isLight) then {[0.9, 0.92, 0.94, 0.96]} else {[0, 0, 0, 0.96]};
	private _barBackground = if (_isLight) then {[0.08, 0.1, 0.12, 0.22]} else {[1, 1, 1, 0.22]};
	private _barColor = if (_isLight) then {[0.18, 0.24, 0.32, 0.98]} else {[0.13, 0.54, 0.21, 0.95]};

	switch (_theme) do {
		case "user": {
			_barColor = [
				profileNamespace getVariable ["GUI_BCG_RGB_R", 0.13],
				profileNamespace getVariable ["GUI_BCG_RGB_G", 0.54],
				profileNamespace getVariable ["GUI_BCG_RGB_B", 0.21],
				profileNamespace getVariable ["GUI_BCG_RGB_A", 0.8]
			];
		};
		case "blufor": {_barColor = [0, 0.333, 0.706, 0.95]};
		case "opfor": {_barColor = [0.886, 0, 0, 0.95]};
		case "independent": {_barColor = [0, 0.561, 0, 0.95]};
		case "civilian": {_barColor = [0.631, 0, 0.706, 0.95]};
	};

	_powerScreen ctrlSetBackgroundColor _overlayColor;
	_barBg ctrlSetBackgroundColor _barBackground;
	_barFill ctrlSetBackgroundColor _barColor;
	{
		_x ctrlSetTextColor _textColor;
	} forEach [_title, _status, _stage];

	private _titleText = "MMC";
	private _statusText = "";
	private _stageText = "";

	if (_text isEqualType []) then {
		_titleText = _text param [0, "MMC", [""]];
		_statusText = _text param [1, "", [""]];
		_stageText = _text param [2, "", [""]];
	} else {
		_statusText = _text;
	};

	_powerScreen ctrlSetText "";
	_title ctrlSetText _titleText;
	_status ctrlSetText _statusText;
	_stage ctrlSetText _stageText;

	if (_progress >= 0) then {
		private _safeProgress = 0 max _progress min 1;
		_barFill ctrlSetPositionW (safeZoneW * 0.3 * _safeProgress);
		_barFill ctrlCommit 0.15;
	};
} else {
	_title ctrlSetText "";
	_status ctrlSetText "";
	_stage ctrlSetText "";
};
