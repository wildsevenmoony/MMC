#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Applies an Eden layout module to synced Register Computer modules or computers.
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

private _layout = [_logic] call FUNC(getLayoutFromModule);

private _registerModules = _objects select {typeOf _x isEqualTo QGVAR(registerComputer)};
private _computerObjects = _objects select {_x getVariable [QGVAR(isComputer), false]};

{
	_x setVariable [QGVAR(computerLayout), _layout, true];

	private _targets = _x getVariable [QGVAR(registeredComputerObjects), []];
	if (_targets isEqualTo []) then {
		_targets = (synchronizedObjects _x) select {_x getVariable [QGVAR(isComputer), false]};
	};

	{
		[_x, _layout] call FUNC(setComputerLayout);
	} forEach _targets;
} forEach _registerModules;

{
	[_x, _layout] call FUNC(setComputerLayout);
} forEach _computerObjects;

if (!is3DEN) then {
	deleteVehicle _logic;
};

true
