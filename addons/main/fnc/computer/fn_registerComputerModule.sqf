#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Registers synced objects as MMC computers from an Eden/Zeus module.
 */

private _logic = objNull;
private _objects = [];
private _activated = true;

if ((_this param [0, objNull]) isEqualType "") then {
	private _mode = _this param [0, "", [""]];
	private _input = _this param [1, [], [[]]];

	if !(_mode in ["init", "attributesChanged3DEN", "registeredToWorld3DEN", "connectionChanged3DEN"]) exitWith {true};

	_input params [
		["_logicInput", objNull, [objNull]],
		["_activatedInput", true, [true]]
	];

	_logic = _logicInput;
	_activated = _activatedInput;

	if (is3DEN) exitWith {true};
} else {
	_this params [
		["_logicInput", objNull, [objNull]],
		["_objectsInput", [], [[]]],
		["_activatedInput", true, [true]]
	];

	_logic = _logicInput;
	_objects = _objectsInput;
	_activated = _activatedInput;
};

if (!_activated || {isNull _logic}) exitWith {true};

if (_objects isEqualTo []) then {
	_objects = synchronizedObjects _logic;
};

private _layoutModules = _objects select {typeOf _x isEqualTo QGVAR(customLayout)};
private _userModules = _objects select {typeOf _x isEqualTo QGVAR(addUser)};
private _targets = _objects select {!(_x isKindOf "Logic")};
private _loginRequired = _logic getVariable [QGVAR(loginRequired), true];
private _disabledApps = [_logic] call FUNC(getDisabledAppsFromConfig);

private _config = createHashMapFromArray [
	["poweredOn", _logic getVariable [QGVAR(poweredOn), true]],
	["loginRequired", _loginRequired],
	["closedSystem", _logic getVariable [QGVAR(closedSystem), false]],
	["systemName", _logic getVariable [QGVAR(systemName), "MMC Workstation"]],
	["disabledApps", _disabledApps]
];

if (!_loginRequired && {_userModules isNotEqualTo []}) then {
	_config set ["autoLoginUsername", (_userModules select 0) getVariable [QGVAR(userName), "operator"]];
};

private _layout = _logic getVariable [QGVAR(computerLayout), createHashMap];
if (_layoutModules isNotEqualTo []) then {
	_layout = [_layoutModules select 0] call FUNC(getLayoutFromModule);
};
if (_layout isEqualType createHashMap && {count _layout > 0}) then {
	_config set ["layout", _layout];
};

_logic setVariable [QGVAR(registeredComputerObjects), _targets, true];

{
	if (!isNull _x) then {
		[_x, _config] call FUNC(registerObject);
	};
} forEach _targets;

true
