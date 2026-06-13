#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Marks an object as an MMC computer and stores its initial configuration.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: Configuration data <HASHMAP, default: createHashMap>
 *
 * Return Value:
 * Registered object <OBJECT>
 */

params [
	["_object", objNull, [objNull]],
	["_config", createHashMap, [createHashMap]]
];

if (isNull _object) exitWith {objNull};

_object setVariable [QGVAR(isComputer), true, true];
_object setVariable [QGVAR(config), _config, true];
_object setVariable [QGVAR(destroyed), !alive _object, true];
_object setVariable [QGVAR(poweredOn), _config getOrDefault ["poweredOn", true], true];
_object setVariable [QGVAR(booting), false, true];
_object setVariable [QGVAR(activeUser), createHashMap, true];

private _existingData = _object getVariable [QGVAR(data), createHashMap];
private _data = _config getOrDefault ["data", [_config] call FUNC(createDefaultData)];
if (count _existingData > 0 && {!("data" in (keys _config))}) then {
	{
		if (_x in (keys _existingData)) then {
			_data set [_x, _existingData get _x];
		};
	} forEach [
		"users",
		"files",
		"mail",
		"messages",
		"notes",
		"desktopTitle",
		"desktopContent",
		"desktopAlign",
		"desktopScript"
	];
};
_object setVariable [QGVAR(data), _data, true];
_object setVariable [QGVAR(customApps), _config getOrDefault ["apps", _object getVariable [QGVAR(customApps), []]]];
[_object] call FUNC(ensureAutoLoginUser);

if !(_object getVariable [QGVAR(destroyedEhAdded), false]) then {
	_object setVariable [QGVAR(destroyedEhAdded), true];
	_object addEventHandler ["Killed", {
		params ["_object"];
		[_object] call MMC_fnc_handleDestroyed;
	}];
};

if (_object getVariable [QGVAR(destroyed), false]) exitWith {
	[_object] call FUNC(handleDestroyed);
	_object
};

private _data = _object getVariable [QGVAR(data), createHashMap];
private _loginRequired = _data getOrDefault ["loginRequired", true];
private _poweredOn = _object getVariable [QGVAR(poweredOn), true];
private _screenState = if (!_poweredOn) then {
	"powered_off"
} else {
	["desktop", "login"] select (count ([_object] call FUNC(getActiveUser)) == 0)
};
[_object, _screenState] call FUNC(setScreenState);

if !(GVAR(registeredComputers) isEqualType []) then {
	GVAR(registeredComputers) = [];
};

GVAR(registeredComputers) pushBackUnique _object;

if (GVAR(pendingGlobalUsers) isEqualType []) then {
	{
		private _layout = _x getOrDefault ["customLayout", createHashMap];
		if !(_layout isEqualType createHashMap) then {
			_layout = createHashMap;
		};
		[
			_object,
			_x getOrDefault ["username", "operator"],
			_x getOrDefault ["password", ""],
			_x getOrDefault ["email", ""],
			_x getOrDefault ["theme", "default"],
			_layout,
			"global",
			_x getOrDefault ["disabledApps", []]
		] call FUNC(addUser);
	} forEach GVAR(pendingGlobalUsers);
};

[_object] call FUNC(addActions);
[_object] remoteExecCall [QFUNC(addActions), 0, _object];

_object
