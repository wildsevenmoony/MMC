#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a horizontal line to the currently rendering scripted app.
 *
 * Arguments:
 * 0: Color <ARRAY or STRING, default: themed border>
 * 1: Height <NUMBER, default: 0.003>
 * 2: Width <NUMBER, default: full content width>
 *
 * Return Value:
 * Created line <CONTROL>
 */

params [
	["_color", [], ["", []]],
	["_height", 0.003, [0]],
	["_width", -1, [0]]
];

private _display = uiNamespace getVariable [QGVAR(appBuilderDisplay), displayNull];
private _group = uiNamespace getVariable [QGVAR(appBuilderGroup), controlNull];
if (isNull _display || {isNull _group}) exitWith {controlNull};

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _border = _themeConfig getOrDefault ["border", [1, 1, 1, 0.35]];
private _lineColor = [_color, _border] call FUNC(parseAppColor);
private _groupW = (ctrlPosition _group) select 2;
private _y = uiNamespace getVariable [QGVAR(appBuilderY), 0.015];
private _w = [_width, _groupW - 0.045] select (_width < 0);

private _line = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
_line ctrlSetText "";
_line ctrlSetPosition [0.015, _y + 0.006, _w, _height];
_line ctrlSetBackgroundColor _lineColor;
_line ctrlCommit 0;

uiNamespace setVariable [QGVAR(appBuilderY), _y + _height + 0.018];
_line
