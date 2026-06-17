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

_objects append (synchronizedObjects _logic);
_objects = _objects arrayIntersect _objects;

private _layout = [_logic] call FUNC(getLayoutFromModule);

private _profileModules = _objects select {
	private _type = typeOf _x;
	(_x getVariable [QGVAR(isMobileProfileModule), false]) || {_type in [QGVAR(mobileProfile), QGVAR(assignMobileProfile)]}
};
private _registerModules = _objects select {typeOf _x isEqualTo QGVAR(registerComputer)};
private _computerObjects = _objects select {_x getVariable [QGVAR(isComputer), false]};

["Modules", "Layout module resolving targets", createHashMapFromArray [
	["module", _logic],
	["preset", _layout getOrDefault ["preset", ""]],
	["applyScreen", _layout getOrDefault ["applyScreen", true]],
	["synced", _objects apply {format ["%1:%2", typeOf _x, _x]}],
	["profileModules", count _profileModules],
	["registerModules", count _registerModules],
	["computerObjects", count _computerObjects]
]] call FUNC(debugLog);

{
	private _profile = _x getVariable [QGVAR(mobileProfileConfig), createHashMap];
	if !(_profile isEqualType createHashMap) then {
		_profile = createHashMap;
	};
	_profile set ["layout", _layout];
	_x setVariable [QGVAR(mobileProfileConfig), _profile, true];
	private _profileId = _profile getOrDefault ["id", _x getVariable [QGVAR(mobileProfileId), "mobile_profile"]];
	[_profileId, _profile] call FUNC(registerMobileProfile);
	[_profileId, _profile] remoteExecCall [QFUNC(registerMobileProfile), 0, format [QGVAR(mobileProfile_%1), _profileId]];
	["Modules", "Layout enriched mobile profile", createHashMapFromArray [
		["profileModule", _x],
		["profileId", _profileId],
		["preset", _layout getOrDefault ["preset", ""]]
	]] call FUNC(debugLog);
} forEach _profileModules;

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
