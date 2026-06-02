#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Applies configured desktop text to synced users or computer defaults.
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

private _title = _logic getVariable [QGVAR(desktopTitle), "Welcome"];
private _content = _logic getVariable [QGVAR(desktopContent), "Select an app on the left."];
private _userModules = _objects select {_x getVariable [QGVAR(isUserModule), false]};

if (_userModules isNotEqualTo []) then {
	{
		private _userConfig = _x getVariable [QGVAR(userConfig), createHashMap];
		private _username = _userConfig getOrDefault ["username", ""];
		private _targets = (synchronizedObjects _x) select {_x getVariable [QGVAR(isComputer), false]};
		if (_targets isEqualTo []) then {
			_targets = if (GVAR(registeredComputers) isEqualType []) then {GVAR(registeredComputers)} else {[]};
		};
		{
			[_x, _username, _title, _content] call FUNC(modifyDesktop);
		} forEach _targets;
	} forEach _userModules;
} else {
	{
		if (!isNull _x) then {
			[_x, "", _title, _content] call FUNC(modifyDesktop);
		};
	} forEach (_objects select {_x getVariable [QGVAR(isComputer), false]});
};

if (!is3DEN) then {
	deleteVehicle _logic;
};

true
