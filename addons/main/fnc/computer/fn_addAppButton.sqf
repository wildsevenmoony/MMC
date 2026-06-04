#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a button to the currently rendering scripted app.
 *
 * Arguments:
 * 0: Button text <STRING>
 * 1: Statement <CODE>
 * 2: Tooltip <STRING> or deactivate callback <CODE, default: "">
 * 3: Condition <CODE, default: {true}>
 * 4: Width <NUMBER, default: 0.16>
 * 5: Value id <STRING, default: "">
 *
 * Return Value:
 * Created button <CONTROL>
 */

private _labelInput = _this param [0, "Button", ["", {}]];
private _statement = _this param [1, {}, [{}]];
private _tooltipOrDeactivate = _this param [2, "", ["", {}]];
private _condition = _this param [3, {true}, [{}]];
private _width = _this param [4, 0.16, [0]];
private _id = _this param [5, "", [""]];
private _tooltip = "";
private _deactivate = {};
private _isToggle = false;

if (_tooltipOrDeactivate isEqualType {}) then {
	_deactivate = _tooltipOrDeactivate;
	_isToggle = true;
} else {
	_tooltip = _tooltipOrDeactivate;
};

private _display = uiNamespace getVariable [QGVAR(appBuilderDisplay), displayNull];
private _group = uiNamespace getVariable [QGVAR(appBuilderGroup), controlNull];
if (isNull _display || {isNull _group}) exitWith {controlNull};

private _computer = uiNamespace getVariable [QGVAR(appBuilderComputer), objNull];
private _activeUser = uiNamespace getVariable [QGVAR(appBuilderUser), createHashMap];
private _app = uiNamespace getVariable [QGVAR(appBuilderApp), createHashMap];
private _label = if (_labelInput isEqualType {}) then {
	[_computer, _activeUser, _app, _display] call _labelInput
} else {
	_labelInput
};
if !(_label isEqualType "") then {
	_label = str _label;
};
private _themeConfig = [_display] call FUNC(getThemeConfig);
private _button = _themeConfig getOrDefault ["button", [0.028, 0.032, 0.042, 0.98]];
private _buttonText = _themeConfig getOrDefault ["buttonText", [0.92, 0.94, 0.97, 1]];
private _border = _themeConfig getOrDefault ["border", [0, 0, 0, 0.85]];
private _enabled = [_computer, _activeUser, _app, _display] call _condition;
private _y = uiNamespace getVariable [QGVAR(appBuilderY), 0.015];

private _buttonCtrl = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc), _group];
_buttonCtrl ctrlSetPosition [0.015, _y, _width, 0.04];
_buttonCtrl ctrlSetText _label;
_buttonCtrl ctrlSetTooltip ([_label, _tooltip] select (_tooltip isNotEqualTo ""));
_buttonCtrl ctrlSetBackgroundColor _button;
_buttonCtrl ctrlSetTextColor _buttonText;
_buttonCtrl ctrlSetActiveColor _buttonText;
_buttonCtrl ctrlEnable _enabled;
_buttonCtrl setVariable [QGVAR(statement), _statement];
_buttonCtrl setVariable [QGVAR(deactivateStatement), _deactivate];
_buttonCtrl setVariable [QGVAR(condition), _condition];
_buttonCtrl setVariable [QGVAR(app), _app];
_buttonCtrl setVariable [QGVAR(toggleButton), _isToggle];
_buttonCtrl setVariable [QGVAR(toggleActive), false];
_buttonCtrl setVariable [QGVAR(valueType), "button"];
_buttonCtrl setVariable [QGVAR(valueId), toLowerANSI _id];
_buttonCtrl ctrlAddEventHandler ["ButtonClick", {
	params ["_control"];

	private _display = ctrlParent _control;
	private _computer = _display getVariable [QGVAR(computer), objNull];
	private _activeUser = [_computer] call MMC_fnc_getActiveUser;
	private _app = _control getVariable [QGVAR(app), createHashMap];
	private _condition = _control getVariable [QGVAR(condition), {true}];
	private _statement = _control getVariable [QGVAR(statement), {}];
	private _deactivate = _control getVariable [QGVAR(deactivateStatement), {}];
	private _isToggle = _control getVariable [QGVAR(toggleButton), false];
	private _isActive = _control getVariable [QGVAR(toggleActive), false];

	if !([_computer, _activeUser, _app, _display, _control] call _condition) exitWith {};
	if (_isToggle && {_isActive}) then {
		[_computer, _activeUser, _app, _display, _control] call _deactivate;
		_control setVariable [QGVAR(toggleActive), false];
	} else {
		[_computer, _activeUser, _app, _display, _control] call _statement;
		if (_isToggle) then {
			_control setVariable [QGVAR(toggleActive), true];
		};
	};

	private _shouldRefresh = if ("refreshAfterAction" in keys _app) then {
		_app getOrDefault ["refreshAfterAction", true]
	} else {
		!_isToggle
	};

	if (_shouldRefresh) then {
		[format ["custom:%1", _app getOrDefault ["id", ""]]] call MMC_fnc_renderApp;
	};
}];
_buttonCtrl ctrlCommit 0;

[_display, _group, [0.015, _y, _width + 0.004, 0.04], _border] call FUNC(createAppBorder);

if (_id isNotEqualTo "") then {
	private _map = _display getVariable [QGVAR(appControlMap), createHashMap];
	_map set [toLowerANSI _id, _buttonCtrl];
	_display setVariable [QGVAR(appControlMap), _map];
};

uiNamespace setVariable [QGVAR(appBuilderY), _y + 0.052];
_buttonCtrl
