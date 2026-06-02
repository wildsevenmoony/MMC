#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a configured user to synced MMC computers.
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

private _username = _logic getVariable [QGVAR(userName), "operator"];
private _password = _logic getVariable [QGVAR(userPassword), ""];
private _email = _logic getVariable [QGVAR(userEmail), "operator@mmcsystems.com"];
private _background = _logic getVariable [QGVAR(userBackground), "default_dark"];
private _backgroundCustom = _logic getVariable [QGVAR(userBackgroundCustom), ""];
private _forceTheme = _logic getVariable [QGVAR(userForceTheme), ""];
if (_backgroundCustom isNotEqualTo "") then {
	_background = _backgroundCustom;
};

_logic setVariable [QGVAR(isUserModule), true, true];
_logic setVariable [QGVAR(userConfig), createHashMapFromArray [
	["username", _username],
	["password", _password],
	["email", _email],
	["background", _background],
	["forceTheme", _forceTheme]
], true];

private _computerObjects = _objects select {_x getVariable [QGVAR(isComputer), false]};
if (_computerObjects isEqualTo []) then {
	_computerObjects = if (GVAR(registeredComputers) isEqualType []) then {GVAR(registeredComputers)} else {[]};
};

{
	if (!isNull _x) then {
		[_x, _username, _password, _email, _background, _forceTheme] call FUNC(addUser);
	};
} forEach _computerObjects;

// Keep the module logic alive so synced file/mail modules can target this user.

true
