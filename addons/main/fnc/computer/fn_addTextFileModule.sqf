#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a configured text file to synced MMC computers.
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

private _name = _logic getVariable [QGVAR(fileName), "intel.txt"];
private _path = _logic getVariable [QGVAR(filePath), "\Desktop\intel.txt"];
private _content = _logic getVariable [QGVAR(fileContent), "Mission intel goes here."];
private _userModules = _objects select {_x getVariable [QGVAR(isUserModule), false]};

if (_userModules isNotEqualTo []) then {
	{
		private _userConfig = _x getVariable [QGVAR(userConfig), createHashMap];
		private _username = _userConfig getOrDefault ["username", ""];
		private _userSyncs = synchronizedObjects _x;
		private _targets = _userSyncs select {_x getVariable [QGVAR(isComputer), false]};
		private _registerModules = _userSyncs select {typeOf _x isEqualTo QGVAR(registerComputer)};
		{
			private _registeredObjects = _x getVariable [QGVAR(registeredComputerObjects), []];
			if (_registeredObjects isEqualTo []) then {
				_registeredObjects = (synchronizedObjects _x) select {!(_x isKindOf "Logic")};
			};
			_targets append _registeredObjects;
		} forEach _registerModules;
		_targets = _targets arrayIntersect _targets;
		if (_targets isEqualTo []) then {
			_targets = [] call FUNC(getRegisteredComputers);
		};

		{
			[_x, _username, _name, _content, "text", _path] call FUNC(addFileToUser);
		} forEach _targets;
	} forEach _userModules;
} else {
	private _targets = _objects select {_x getVariable [QGVAR(isComputer), false]};
	private _registerModules = _objects select {typeOf _x isEqualTo QGVAR(registerComputer)};
	{
		private _registeredObjects = _x getVariable [QGVAR(registeredComputerObjects), []];
		if (_registeredObjects isEqualTo []) then {
			_registeredObjects = (synchronizedObjects _x) select {_x getVariable [QGVAR(isComputer), false]};
		};
		_targets append _registeredObjects;
	} forEach _registerModules;
	_targets = _targets arrayIntersect _targets;

	{
		if (!isNull _x) then {
			[_x, _name, _content, "text", _path] call FUNC(addFile);
		};
	} forEach _targets;
};

if (!is3DEN) then {
	deleteVehicle _logic;
};

true
