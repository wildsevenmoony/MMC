#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds structured text to the currently rendering scripted app.
 *
 * Arguments:
 * 0: Structured text <STRING>
 * 1: Height override <NUMBER, default: -1>
 *
 * Return Value:
 * Created control <CONTROL>
 */

params [
	["_text", "", [""]],
	["_height", -1, [0]]
];

private _display = uiNamespace getVariable [QGVAR(appBuilderDisplay), displayNull];
private _group = uiNamespace getVariable [QGVAR(appBuilderGroup), controlNull];
if (isNull _display || {isNull _group}) exitWith {controlNull};

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _textColor = _themeConfig getOrDefault ["text", [0.92, 0.94, 0.97, 1]];
private _groupW = (ctrlPosition _group) select 2;
private _y = uiNamespace getVariable [QGVAR(appBuilderY), 0.015];
private _w = _groupW - 0.045;

private _control = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
_control ctrlSetPosition [0.015, _y, _w, 0.05];
_control ctrlSetText "";
_control ctrlSetBackgroundColor [0, 0, 0, 0];
_control ctrlSetTextColor _textColor;
_control ctrlSetStructuredText parseText ([_text] call FUNC(normalizeStructuredText));
_control ctrlCommit 0;

if (_height < 0) then {
	_height = 0.035 max ((ctrlTextHeight _control) + 0.014);
};

_control ctrlSetPosition [0.015, _y, _w, _height];
_control ctrlCommit 0;

uiNamespace setVariable [QGVAR(appBuilderY), _y + _height + 0.012];
_control
