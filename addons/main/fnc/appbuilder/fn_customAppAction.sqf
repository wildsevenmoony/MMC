#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Executes a scripted mission app action.
 *
 * Arguments:
 * 0: App id <STRING>
 * 1: Action index <NUMBER>
 *
 * Return Value:
 * Executed <BOOL>
 */

params [
	["_id", "", [""]],
	["_actionIndex", -1, [0]]
];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display || {_id isEqualTo "" || {_actionIndex < 0}}) exitWith {false};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _activeUser = [_computer] call FUNC(getActiveUser);
private _apps = _computer getVariable [QGVAR(customApps), []];
private _lookup = toLowerANSI _id;
private _appIndex = _apps findIf {toLowerANSI (_x getOrDefault ["id", ""]) isEqualTo _lookup};
if (_appIndex < 0) exitWith {false};

private _app = _apps select _appIndex;
private _actions = _app getOrDefault ["actions", []];
private _action = _actions param [_actionIndex, []];
if (_action isEqualTo []) exitWith {false};

private _statement = if (_action isEqualType createHashMap) then {
	_action getOrDefault ["statement", {}]
} else {
	_action param [1, {}, [{}]]
};
private _condition = if (_action isEqualType createHashMap) then {
	_action getOrDefault ["condition", {true}]
} else {
	_action param [3, {true}, [{}]]
};

if !(_statement isEqualType {}) exitWith {false};
if !(_condition isEqualType {}) exitWith {false};
if !([_computer, _activeUser, _app, _display] call _condition) exitWith {false};

[_computer, _activeUser, _app, _display] call _statement;

if (_app getOrDefault ["refreshAfterAction", true]) then {
	[format ["custom:%1", _lookup]] call FUNC(renderApp);
};

true
