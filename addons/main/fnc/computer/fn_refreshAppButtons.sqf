#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Rebuilds dynamic program buttons for scripted mission apps.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {};

[_display, true, false] call FUNC(clearCustomControls);

private _computer = _display getVariable [QGVAR(computer), objNull];
if (isNull _computer) exitWith {};

private _apps = _computer getVariable [QGVAR(customApps), []];
if !(_apps isEqualType []) exitWith {};

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _button = _themeConfig getOrDefault ["button", [0.028, 0.032, 0.042, 0.98]];
private _buttonText = _themeConfig getOrDefault ["buttonText", [0.92, 0.94, 0.97, 1]];
private _border = _themeConfig getOrDefault ["border", [0, 0, 0, 0.85]];

private _controls = [];
private _step = 0.055;
private _standardCount = _display getVariable [QGVAR(standardAppButtonCount), 4];
private _startY = safeZoneY + 0.09 + (_standardCount * _step);
private _maxButtons = 8;

{
	if (_forEachIndex < _maxButtons) then {
		private _id = _x getOrDefault ["id", ""];
		if (_id isNotEqualTo "") then {
			private _y = _startY + (_forEachIndex * _step);
			private _buttonCtrl = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
			_buttonCtrl ctrlSetPosition [safeZoneX + 0.035, _y, 0.105, 0.05];
			_buttonCtrl ctrlSetText (_x getOrDefault ["label", _id]);
			_buttonCtrl ctrlSetTooltip (_x getOrDefault ["tooltip", format ["Open %1.", _x getOrDefault ["label", _id]]]);
			_buttonCtrl ctrlSetBackgroundColor _button;
			_buttonCtrl ctrlSetTextColor _buttonText;
			_buttonCtrl ctrlSetActiveColor _buttonText;
			_buttonCtrl setVariable [QGVAR(appId), _id];
			_buttonCtrl ctrlAddEventHandler ["ButtonClick", {
				params ["_control"];
				[format ["custom:%1", _control getVariable [QGVAR(appId), ""]]] call MMC_fnc_renderApp;
			}];
			_buttonCtrl ctrlCommit 0;

			private _borderControls = [_display, controlNull, [safeZoneX + 0.035, _y, 0.107, 0.05], _border] call FUNC(createAppBorder);

			_controls pushBack _buttonCtrl;
			_controls append _borderControls;
		};
	};
} forEach _apps;

_display setVariable [QGVAR(customAppControls), _controls];
