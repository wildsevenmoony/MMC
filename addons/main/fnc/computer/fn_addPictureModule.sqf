#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a configured picture to synced MMC computers or users.
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

private _name = _logic getVariable [QGVAR(fileName), "picture.paa"];
private _path = _logic getVariable [QGVAR(filePath), "\Pictures\picture.paa"];
private _texture = _logic getVariable [QGVAR(fileTexture), ""];
private _description = _logic getVariable [QGVAR(fileDescription), ""];
if (_texture isEqualTo "") then {
	_texture = _path;
};

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
			[_x, _username, _name, _description, "picture", _path, _texture] call FUNC(addFileToUser);
		} forEach _targets;
	} forEach _userModules;
} else {
	{
		if (!isNull _x) then {
			[_x, _name, _description, "picture", _path, _texture] call FUNC(addFile);
		};
	} forEach (_objects select {_x getVariable [QGVAR(isComputer), false]});
};

if (!is3DEN) then {
	deleteVehicle _logic;
};

true
