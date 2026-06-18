#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a scrollable styled box to the currently rendering scripted app.
 *
 * Arguments:
 * 0: Content <STRING, CODE, or ARRAY>
 * 1: Background color <ARRAY or STRING, default: themed panel>
 * 2: Border color <ARRAY or STRING, default: themed border>
 * 3: Background alpha <NUMBER, default: 0.45>
 * 4: Height <NUMBER, default: auto>
 * 5: Width <NUMBER, default: full content width>
 *
 * Return Value:
 * Created controls group <CONTROL>
 */

params [
	["_content", "", ["", {}, []]],
	["_background", [], ["", []]],
	["_borderColor", [], ["", []]],
	["_alpha", 0.45, [0]],
	["_height", -1, [0]],
	["_width", -1, [0]]
];

private _display = uiNamespace getVariable [QGVAR(appBuilderDisplay), displayNull];
private _parentGroup = uiNamespace getVariable [QGVAR(appBuilderGroup), controlNull];
if (isNull _display || {isNull _parentGroup}) exitWith {controlNull};

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _panel = _themeConfig getOrDefault ["panel", [0.02, 0.025, 0.035, 0.94]];
private _border = _themeConfig getOrDefault ["border", [0, 0, 0, 0.85]];
private _bgColor = [_background, _panel, _alpha] call FUNC(parseAppColor);
private _frameColor = [_borderColor, _border] call FUNC(parseAppColor);
private _parentW = (ctrlPosition _parentGroup) select 2;
private _parentY = uiNamespace getVariable [QGVAR(appBuilderY), 0.015];
private _w = [_width, _parentW - 0.045] select (_width < 0);
private _initialH = [_height, 0.12] select (_height < 0);

private _backgroundCtrl = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _parentGroup];
_backgroundCtrl ctrlSetText "";
_backgroundCtrl ctrlSetPosition [0.015, _parentY, _w, _initialH];
_backgroundCtrl ctrlSetBackgroundColor _bgColor;
_backgroundCtrl ctrlCommit 0;

private _boxGroup = _display ctrlCreate [QGVAR(RscComputerAppGroup), [_display] call FUNC(nextDynamicIdc), _parentGroup];
_boxGroup ctrlSetText "";
_boxGroup ctrlSetPosition [0.015, _parentY, _w, _initialH];
_boxGroup ctrlCommit 0;

private _oldGroup = uiNamespace getVariable [QGVAR(appBuilderGroup), controlNull];
private _oldY = uiNamespace getVariable [QGVAR(appBuilderY), 0.015];

uiNamespace setVariable [QGVAR(appBuilderGroup), _boxGroup];
uiNamespace setVariable [QGVAR(appBuilderY), 0.012];
[_content] call FUNC(runAppBuilderContent);

private _contentH = (uiNamespace getVariable [QGVAR(appBuilderY), 0.012]) + 0.012;
private _boxH = if (_height < 0) then {0.055 max _contentH} else {_height};

uiNamespace setVariable [QGVAR(appBuilderGroup), _oldGroup];
uiNamespace setVariable [QGVAR(appBuilderY), _oldY + _boxH + 0.014];

{
	_x ctrlSetPosition [0.015, _parentY, _w, _boxH];
	_x ctrlCommit 0;
} forEach [_backgroundCtrl, _boxGroup];

[_display, _parentGroup, [0.015, _parentY, _w + 0.004, _boxH], _frameColor] call FUNC(createAppBorder);

_boxGroup
