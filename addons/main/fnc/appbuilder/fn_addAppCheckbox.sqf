#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a checkbox to the currently rendering scripted app.
 *
 * Arguments:
 * 0: Value id <STRING>
 * 1: Label <STRING>
 * 2: Checked <BOOL, default: false>
 * 3: On changed callback <CODE, default: {}>
 *
 * Return Value:
 * Created checkbox <CONTROL>
 */

params [
	["_id", "", [""]],
	["_label", "Checkbox", [""]],
	["_checked", false, [false]],
	["_onChanged", {}, [{}]]
];

private _display = uiNamespace getVariable [QGVAR(appBuilderDisplay), displayNull];
private _group = uiNamespace getVariable [QGVAR(appBuilderGroup), controlNull];
if (isNull _display || {isNull _group || {_id isEqualTo ""}}) exitWith {controlNull};

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _app = uiNamespace getVariable [QGVAR(appBuilderApp), createHashMap];
private _textColor = _themeConfig getOrDefault ["text", [0.92, 0.94, 0.97, 1]];
private _y = uiNamespace getVariable [QGVAR(appBuilderY), 0.015];

private _checkbox = _display ctrlCreate ["RscCheckBox", [_display] call FUNC(nextDynamicIdc), _group];
_checkbox ctrlSetText "";
_checkbox ctrlSetPosition [0.015, _y, 0.032, 0.032];
_checkbox cbSetChecked _checked;
_checkbox setVariable [QGVAR(valueType), "checkbox"];
_checkbox setVariable [QGVAR(valueId), toLowerANSI _id];
_checkbox setVariable [QGVAR(app), _app];
_checkbox setVariable [QGVAR(onChanged), _onChanged];
_checkbox ctrlAddEventHandler ["CheckedChanged", {
	params ["_control", "_checked"];
	private _display = ctrlParent _control;
	private _computer = _display getVariable [QGVAR(computer), objNull];
	private _activeUser = [_computer] call MMC_fnc_getActiveUser;
	private _app = _control getVariable [QGVAR(app), createHashMap];
	private _onChanged = _control getVariable [QGVAR(onChanged), {}];
	[_computer, _activeUser, _app, _display, _control, _checked > 0] call _onChanged;
}];
_checkbox ctrlCommit 0;

private _labelCtrl = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
_labelCtrl ctrlSetPosition [0.052, _y, ((ctrlPosition _group) select 2) - 0.085, 0.032];
_labelCtrl ctrlSetText _label;
_labelCtrl ctrlSetTextColor _textColor;
_labelCtrl ctrlSetBackgroundColor [0, 0, 0, 0];
_labelCtrl ctrlCommit 0;

private _map = _display getVariable [QGVAR(appControlMap), createHashMap];
_map set [toLowerANSI _id, _checkbox];
_display setVariable [QGVAR(appControlMap), _map];

uiNamespace setVariable [QGVAR(appBuilderY), _y + 0.044];
_checkbox
