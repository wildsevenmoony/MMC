#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a raw UI control to the currently rendering scripted app.
 *
 * Arguments:
 * 0: Value id <STRING>
 * 1: Control class <STRING>
 * 2: Height <NUMBER, default: 0.12>
 * 3: Setup callback <CODE, default: {}>
 * 4: Width <NUMBER, default: -1, use app content width>
 *
 * Return Value:
 * Created control <CONTROL>
 *
 * Example:
 * ["preview", "RscPicture", 0.25, {_this#0 ctrlSetText "#(argb,8,8,3)color(0,0,0,1)"}] call MMC_fnc_addAppControl
 */

params [
	["_id", "", [""]],
	["_controlClass", "RscText", [""]],
	["_height", 0.12, [0]],
	["_setup", {}, [{}]],
	["_width", -1, [0]]
];

private _display = uiNamespace getVariable [QGVAR(appBuilderDisplay), displayNull];
private _group = uiNamespace getVariable [QGVAR(appBuilderGroup), controlNull];
if (isNull _display || {isNull _group || {_controlClass isEqualTo ""}}) exitWith {controlNull};

private _computer = uiNamespace getVariable [QGVAR(appBuilderComputer), objNull];
private _activeUser = uiNamespace getVariable [QGVAR(appBuilderUser), createHashMap];
private _app = uiNamespace getVariable [QGVAR(appBuilderApp), createHashMap];
private _groupW = (ctrlPosition _group) select 2;
private _y = uiNamespace getVariable [QGVAR(appBuilderY), 0.015];
private _w = if (_width > 0) then {_width} else {_groupW - 0.045};

private _control = _display ctrlCreate [_controlClass, [_display] call FUNC(nextDynamicIdc), _group];
_control ctrlSetPosition [0.015, _y, _w, _height max 0.001];
_control ctrlCommit 0;
_control setVariable [QGVAR(valueType), "control"];
_control setVariable [QGVAR(valueId), toLowerANSI _id];
_control setVariable [QGVAR(app), _app];

[_control, _display, _group, _computer, _activeUser, _app] call _setup;

if (_id isNotEqualTo "") then {
	private _map = _display getVariable [QGVAR(appControlMap), createHashMap];
	_map set [toLowerANSI _id, _control];
	_display setVariable [QGVAR(appControlMap), _map];
};

uiNamespace setVariable [QGVAR(appBuilderY), _y + (_height max 0.001) + 0.012];
_control
