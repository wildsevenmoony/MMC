#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a themed progress bar to the currently rendering scripted app.
 *
 * Arguments:
 * 0: Value id <STRING>
 * 1: Label <STRING, default: "">
 * 2: Value from 0 to 1 <NUMBER, default: 0>
 * 3: Bar height <NUMBER, default: 0.026>
 * 4: Width <NUMBER, default: full content width>
 * 5: Fill color <ARRAY or STRING, default: themed accent>
 * 6: Background color <ARRAY or STRING, default: themed panel strong>
 * 7: Show percentage text <BOOL, default: true>
 * 8: Tooltip <STRING, default: "">
 *
 * Return Value:
 * Fill control <CONTROL>
 *
 * Example:
 * ["signal", "Signal Strength", 0.65] call MMC_fnc_addAppProgressBar
 */

params [
	["_id", "", [""]],
	["_label", "", [""]],
	["_value", 0, [0]],
	["_height", 0.026, [0]],
	["_width", -1, [0]],
	["_fillColor", [], ["", []]],
	["_backgroundColor", [], ["", []]],
	["_showValue", true, [true]],
	["_tooltip", "", [""]]
];

private _display = uiNamespace getVariable [QGVAR(appBuilderDisplay), displayNull];
private _group = uiNamespace getVariable [QGVAR(appBuilderGroup), controlNull];
if (isNull _display || {isNull _group}) exitWith {controlNull};

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _accent = _themeConfig getOrDefault ["bootAccent", [0.13, 0.54, 0.21, 0.95]];
private _panelStrong = _themeConfig getOrDefault ["panelStrong", [0.015, 0.018, 0.024, 0.98]];
private _textColor = _themeConfig getOrDefault ["text", [0.92, 0.94, 0.97, 1]];
private _border = _themeConfig getOrDefault ["border", [0, 0, 0, 0.85]];
private _barColor = [_fillColor, _accent] call FUNC(parseAppColor);
private _barBackground = [_backgroundColor, _panelStrong, 0.78] call FUNC(parseAppColor);

private _groupW = (ctrlPosition _group) select 2;
private _w = [_width, _groupW - 0.045] select (_width < 0);
private _x = 0.015;
private _y = uiNamespace getVariable [QGVAR(appBuilderY), 0.015];

if (_label isNotEqualTo "") then {
	private _labelCtrl = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
	_labelCtrl ctrlSetPosition [_x, _y, _w, 0.05];
	_labelCtrl ctrlSetBackgroundColor [0, 0, 0, 0];
	_labelCtrl ctrlSetTextColor _textColor;
	_labelCtrl ctrlSetStructuredText parseText ([_label] call FUNC(normalizeStructuredText));
	_labelCtrl ctrlSetTooltip _tooltip;
	_labelCtrl ctrlCommit 0;
	private _labelH = 0.03 max ((ctrlTextHeight _labelCtrl) + 0.008);
	_labelCtrl ctrlSetPosition [_x, _y, _w, _labelH];
	_labelCtrl ctrlCommit 0;
	_y = _y + _labelH + 0.006;
};

private _barH = _height max 0.01;
private _background = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
_background ctrlSetPosition [_x, _y, _w, _barH];
_background ctrlSetText "";
_background ctrlSetBackgroundColor _barBackground;
_background ctrlSetTooltip _tooltip;
_background ctrlCommit 0;

private _fill = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
_fill ctrlSetPosition [_x, _y, 0.001, _barH];
_fill ctrlSetText "";
_fill ctrlSetBackgroundColor _barColor;
_fill ctrlSetTooltip _tooltip;
_fill ctrlCommit 0;

private _valueCtrl = controlNull;
if (_showValue) then {
	_valueCtrl = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
	_valueCtrl ctrlSetPosition [_x, _y, _w - 0.006, _barH];
	_valueCtrl ctrlSetText "";
	_valueCtrl ctrlSetBackgroundColor [0, 0, 0, 0];
	_valueCtrl ctrlSetTextColor _textColor;
	_valueCtrl ctrlSetTooltip _tooltip;
	_valueCtrl ctrlCommit 0;
};

[_display, _group, [_x, _y, _w + 0.004, _barH], _border] call FUNC(createAppBorder);

_fill setVariable [QGVAR(progressMaxWidth), _w];
_fill setVariable [QGVAR(progressHeight), _barH];
_fill setVariable [QGVAR(progressValueControl), _valueCtrl];
_fill setVariable [QGVAR(progressBackgroundControl), _background];
_fill setVariable [QGVAR(valueType), "progress"];
_fill setVariable [QGVAR(valueId), toLowerANSI _id];

if (_id isNotEqualTo "") then {
	private _map = _display getVariable [QGVAR(appControlMap), createHashMap];
	_map set [toLowerANSI _id, _fill];
	_display setVariable [QGVAR(appControlMap), _map];
};

[_fill, _value] call FUNC(setAppProgressBar);

uiNamespace setVariable [QGVAR(appBuilderY), _y + _barH + 0.014];
_fill
