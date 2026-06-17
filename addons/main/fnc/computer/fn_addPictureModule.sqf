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

_objects append (synchronizedObjects _logic);
_objects = _objects arrayIntersect _objects;

private _name = _logic getVariable [QGVAR(fileName), "picture.paa"];
private _path = _logic getVariable [QGVAR(filePath), "\Pictures\picture.paa"];
private _texture = _logic getVariable [QGVAR(fileTexture), ""];
private _description = _logic getVariable [QGVAR(fileDescription), ""];
if (_texture isEqualTo "") then {
	_texture = _path;
};

private _profileModules = _objects select {
	private _type = typeOf _x;
	(_x getVariable [QGVAR(isMobileProfileModule), false]) || {_type in [QGVAR(mobileProfile), QGVAR(assignMobileProfile)]}
};
private _userModules = _objects select {_x getVariable [QGVAR(isUserModule), false]};

["Modules", "Add Picture module resolving targets", createHashMapFromArray [
	["module", _logic],
	["name", _name],
	["path", _path],
	["texture", _texture],
	["synced", _objects apply {format ["%1:%2", typeOf _x, _x]}],
	["profileModules", count _profileModules],
	["userModules", count _userModules]
]] call FUNC(debugLog);

{
	private _profile = _x getVariable [QGVAR(mobileProfileConfig), createHashMap];
	if !(_profile isEqualType createHashMap) then {
		_profile = createHashMap;
	};
	private _sourceModule = netId _logic;
	private _files = _profile getOrDefault ["files", []];
	_files = _files select {!(_x isEqualType createHashMap) || {_x getOrDefault ["sourceModule", ""] isNotEqualTo _sourceModule}};
	_files pushBack createHashMapFromArray [
		["sourceModule", _sourceModule],
		["name", _name],
		["type", "picture"],
		["path", _path],
		["content", _description],
		["texture", _texture]
	];
	_profile set ["files", _files];
	_x setVariable [QGVAR(mobileProfileConfig), _profile, true];
	private _profileId = _profile getOrDefault ["id", _x getVariable [QGVAR(mobileProfileId), "mobile_profile"]];
	[_profileId, _profile] call FUNC(registerMobileProfile);
	[_profileId, _profile] remoteExecCall [QFUNC(registerMobileProfile), 0, format [QGVAR(mobileProfile_%1), _profileId]];
	["Modules", "Add Picture enriched mobile profile", createHashMapFromArray [
		["profileModule", _x],
		["profileId", _profileId],
		["name", _name],
		["fileCount", count _files]
	]] call FUNC(debugLog);
} forEach _profileModules;

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
			[_x, _username, _name, _description, "picture", _path, _texture] call FUNC(addFileToUser);
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
			[_x, _name, _description, "picture", _path, _texture] call FUNC(addFile);
		};
	} forEach _targets;
};

if (!is3DEN) then {
	deleteVehicle _logic;
};

true
