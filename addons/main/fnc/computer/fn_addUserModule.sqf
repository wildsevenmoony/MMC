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
private _theme = _logic getVariable [QGVAR(userTheme), _logic getVariable [QGVAR(userBackground), "default"]];
private _disabledApps = [_logic] call FUNC(getDisabledAppsFromConfig);
private _customLayout = _logic getVariable [QGVAR(customLayout), createHashMap];
if !(_customLayout isEqualType createHashMap) then {
	_customLayout = createHashMap;
};

private _legacyBackgroundCustom = _logic getVariable [QGVAR(userBackgroundCustom), ""];
if (_legacyBackgroundCustom isNotEqualTo "" && {count _customLayout == 0}) then {
	_customLayout = createHashMapFromArray [
		["preset", _theme],
		["useCustomColors", false],
		["background", _legacyBackgroundCustom],
		["colors", createHashMap]
	];
};

_logic setVariable [QGVAR(isUserModule), true, true];
private _userConfig = createHashMapFromArray [
	["username", _username],
	["password", _password],
	["email", _email],
	["theme", _theme],
	["scope", "pending"],
	["disabledApps", _disabledApps]
];
if (count _customLayout > 0) then {
	_userConfig set ["customLayout", _customLayout];
};
_logic setVariable [QGVAR(userConfig), _userConfig, true];

private _computerObjects = _objects select {_x getVariable [QGVAR(isComputer), false]};
private _registerModules = _objects select {typeOf _x isEqualTo QGVAR(registerComputer)};
private _hasComputerTarget = (_computerObjects isNotEqualTo []) || {_registerModules isNotEqualTo []};
{
	private _registeredObjects = _x getVariable [QGVAR(registeredComputerObjects), []];
	if (_registeredObjects isEqualTo []) then {
		_registeredObjects = (synchronizedObjects _x) select {!(_x isKindOf "Logic")};
	};
	_computerObjects append _registeredObjects;
} forEach _registerModules;
_computerObjects = _computerObjects arrayIntersect _computerObjects;

private _scope = "direct";
if (_computerObjects isEqualTo []) then {
	if (!_hasComputerTarget) then {
		_scope = "global";
		_computerObjects = [] call FUNC(getRegisteredComputers);
	} else {
		_computerObjects = [];
	};
};
_userConfig set ["scope", _scope];
_logic setVariable [QGVAR(userConfig), _userConfig, true];

if (_scope isEqualTo "global") then {
	if !(GVAR(pendingGlobalUsers) isEqualType []) then {
		GVAR(pendingGlobalUsers) = [];
	};
	private _lookup = toLowerANSI _username;
	private _pendingIndex = GVAR(pendingGlobalUsers) findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
	if (_pendingIndex < 0) then {
		GVAR(pendingGlobalUsers) pushBack _userConfig;
	} else {
		GVAR(pendingGlobalUsers) set [_pendingIndex, _userConfig];
	};
};

{
	if (!isNull _x) then {
		[_x, _username, _password, _email, _theme, _customLayout, _scope, _disabledApps] call FUNC(addUser);
	};
} forEach _computerObjects;

// Keep the module logic alive so synced file/mail modules can target this user.

true
