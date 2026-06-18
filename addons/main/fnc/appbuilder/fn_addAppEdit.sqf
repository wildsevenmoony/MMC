#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds an edit field to the currently rendering scripted app.
 *
 * Arguments:
 * 0: Value id <STRING>
 * 1: Label <STRING>
 * 2: Default text <STRING, default: "">
 * 3: On commit callback <CODE, default: {}>
 *
 * Return Value:
 * Created edit control <CONTROL>
 */

private _args = +_this;
if ((count _args) == 1 && {(_args select 0) isEqualType ""}) then {
	_args = [format ["edit_%1", round random 999999], "", _args select 0];
};

_args params [
	["_id", "", [""]],
	["_label", "", [""]],
	["_default", "", [""]],
	["_onCommit", {}, [{}]]
];

private _display = uiNamespace getVariable [QGVAR(appBuilderDisplay), displayNull];
private _group = uiNamespace getVariable [QGVAR(appBuilderGroup), controlNull];
if (isNull _display || {isNull _group || {_id isEqualTo ""}}) exitWith {controlNull};

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _app = uiNamespace getVariable [QGVAR(appBuilderApp), createHashMap];
private _textColor = _themeConfig getOrDefault ["text", [0.92, 0.94, 0.97, 1]];
private _panel = _themeConfig getOrDefault ["panel", [0.02, 0.025, 0.035, 0.94]];
private _border = _themeConfig getOrDefault ["border", [0, 0, 0, 0.85]];
private _groupW = (ctrlPosition _group) select 2;
private _y = uiNamespace getVariable [QGVAR(appBuilderY), 0.015];
private _w = _groupW - 0.045;

if (_label isNotEqualTo "") then {
	private _labelCtrl = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
	_labelCtrl ctrlSetPosition [0.015, _y, _w, 0.026];
	_labelCtrl ctrlSetText _label;
	_labelCtrl ctrlSetTextColor _textColor;
	_labelCtrl ctrlSetBackgroundColor [0, 0, 0, 0];
	_labelCtrl ctrlCommit 0;
	_y = _y + 0.028;
};

private _edit = _display ctrlCreate ["RscEdit", [_display] call FUNC(nextDynamicIdc), _group];
_edit ctrlSetPosition [0.015, _y, _w, 0.04];
_edit ctrlSetText _default;
_edit ctrlSetTextColor _textColor;
_edit ctrlSetBackgroundColor _panel;
_edit setVariable [QGVAR(valueType), "edit"];
_edit setVariable [QGVAR(valueId), toLowerANSI _id];
_edit setVariable [QGVAR(app), _app];
_edit setVariable [QGVAR(onCommit), _onCommit];
_edit ctrlAddEventHandler ["KillFocus", {
	params ["_control"];
	private _display = ctrlParent _control;
	private _computer = _display getVariable [QGVAR(computer), objNull];
	private _activeUser = [_computer] call MMC_fnc_getActiveUser;
	private _app = _control getVariable [QGVAR(app), createHashMap];
	private _onCommit = _control getVariable [QGVAR(onCommit), {}];
	[_computer, _activeUser, _app, _display, _control, ctrlText _control] call _onCommit;
}];
_edit ctrlCommit 0;

[_display, _group, [0.015, _y, _w + 0.004, 0.04], _border] call FUNC(createAppBorder);

private _map = _display getVariable [QGVAR(appControlMap), createHashMap];
_map set [toLowerANSI _id, _edit];
_display setVariable [QGVAR(appControlMap), _map];

uiNamespace setVariable [QGVAR(appBuilderY), _y + 0.052];
_edit
