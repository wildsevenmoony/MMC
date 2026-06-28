#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a hacking entry button to an MMC access screen.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Hacking mode, "login" or "mobile" <STRING>
 *
 * Return Value:
 * Button added <BOOL>
 */

params [
	["_display", displayNull, [displayNull]],
	["_mode", "login", [""]]
];

if (isNull _display) exitWith {false};

[_display, false, true] call FUNC(hackingClose);
if !(missionNamespace getVariable [QGVAR(hackingEnabled), true]) exitWith {false};

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _accent = _themeConfig getOrDefault ["bootAccent", [0.13, 0.54, 0.21, 0.95]];
private _canStart = [_display, _mode] call FUNC(hackingCanStart);
if (!_canStart) exitWith {false};

private _patch = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc)];
private _frame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
private _icon = _display ctrlCreate ["RscPictureKeepAspect", [_display] call FUNC(nextDynamicIdc)];
private _label = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
private _button = _display ctrlCreate [QGVAR(RscComputerInvisibleButton), [_display] call FUNC(nextDynamicIdc)];

private _patchColor = [0.01, 0.012, 0.014, 0.96];
private _frameColor = +_accent;
_frameColor set [3, 0.95];

_patch ctrlSetBackgroundColor _patchColor;
_patch ctrlEnable false;
_frame ctrlSetTextColor _frameColor;
_frame ctrlEnable false;
_icon ctrlSetText PATHTOF(img\hack_white.paa);
_icon ctrlEnable false;
_label ctrlSetStructuredText parseText "";
_label ctrlEnable false;

_button ctrlSetTooltip "Start a timed security bypass.";
_button ctrlEnable true;
_button setVariable [QGVAR(hackingMode), _mode];
_button ctrlAddEventHandler ["ButtonClick", {
	params ["_control"];
	private _display = ctrlParent _control;
	private _mode = _control getVariable [QGVAR(hackingMode), "login"];
	[_display, _mode] call MMC_fnc_hackingStart;
}];

private _pos = switch (_mode) do {
	case "login": {
		private _showButton = _display displayCtrl IDC_MMC_LOGIN_PASSWORD_TOGGLE;
		private _showPos = ctrlPosition _showButton;
		private _size = ((_showPos select 3) * 1.45) max 0.046;
		[
			(_showPos select 0) + ((_showPos select 2) * 0.45),
			(_showPos select 1) - (_size * 0.62),
			_size,
			_size
		]
	};
	default {
		[safeZoneX + safeZoneW * 0.468, safeZoneY + safeZoneH * 0.54, 0.052, 0.052]
	};
};

_patch ctrlSetPosition _pos;
_patch ctrlShow true;
_patch ctrlCommit 0;
_frame ctrlSetPosition _pos;
_frame ctrlShow true;
_frame ctrlCommit 0;
_icon ctrlSetPosition [
	(_pos select 0) + ((_pos select 2) * 0.18),
	(_pos select 1) + ((_pos select 3) * 0.18),
	(_pos select 2) * 0.64,
	(_pos select 3) * 0.64
];
_icon ctrlShow true;
_icon ctrlCommit 0;
_label ctrlSetPosition _pos;
_label ctrlShow false;
_label ctrlCommit 0;
_button ctrlSetPosition _pos;
_button ctrlShow true;
_button ctrlCommit 0;

_display setVariable [QGVAR(hackingEntryControls), [_patch, _frame, _icon, _label, _button]];
true
