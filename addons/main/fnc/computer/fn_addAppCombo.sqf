#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a combo box to the currently rendering scripted app.
 *
 * Arguments:
 * 0: Value id <STRING>
 * 1: Label <STRING>
 * 2: Options <ARRAY of STRING or [value,label]>
 * 3: Selected value <STRING, default: "">
 * 4: On changed callback <CODE, default: {}>
 *
 * Return Value:
 * Created combo control <CONTROL>
 */

params [
	["_id", "", [""]],
	["_label", "", [""]],
	["_options", [], [[]]],
	["_selected", "", [""]],
	["_onChanged", {}, [{}]]
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

private _combo = _display ctrlCreate ["RscCombo", [_display] call FUNC(nextDynamicIdc), _group];
_combo ctrlSetText "";
_combo ctrlSetPosition [0.015, _y, _w, 0.04];
_combo ctrlSetBackgroundColor _panel;
_combo ctrlSetTextColor _textColor;
_combo setVariable [QGVAR(valueType), "combo"];
_combo setVariable [QGVAR(valueId), toLowerANSI _id];
_combo setVariable [QGVAR(app), _app];
_combo setVariable [QGVAR(onChanged), _onChanged];

private _values = [];
private _selectedIndex = 0;
{
	private _value = "";
	private _optionLabel = "";
	if (_x isEqualType []) then {
		_value = _x param [0, "", [""]];
		_optionLabel = _x param [1, _value, [""]];
	} else {
		_value = str _x;
		_optionLabel = _value;
	};

	private _row = _combo lbAdd _optionLabel;
	_combo lbSetData [_row, _value];
	_values pushBack _value;
	if (toLowerANSI _value isEqualTo toLowerANSI _selected) then {
		_selectedIndex = _row;
	};
} forEach _options;
_combo lbSetCurSel _selectedIndex;
_combo setVariable [QGVAR(comboValues), _values];
_combo ctrlAddEventHandler ["LBSelChanged", {
	params ["_control", "_index"];
	private _display = ctrlParent _control;
	private _computer = _display getVariable [QGVAR(computer), objNull];
	private _activeUser = [_computer] call MMC_fnc_getActiveUser;
	private _app = _control getVariable [QGVAR(app), createHashMap];
	private _onChanged = _control getVariable [QGVAR(onChanged), {}];
	private _value = _control lbData _index;
	[_computer, _activeUser, _app, _display, _control, _value] call _onChanged;
}];
_combo ctrlCommit 0;

[_display, _group, [0.015, _y, _w + 0.004, 0.04], _border] call FUNC(createAppBorder);

private _map = _display getVariable [QGVAR(appControlMap), createHashMap];
_map set [toLowerANSI _id, _combo];
_display setVariable [QGVAR(appControlMap), _map];

uiNamespace setVariable [QGVAR(appBuilderY), _y + 0.052];
_combo
