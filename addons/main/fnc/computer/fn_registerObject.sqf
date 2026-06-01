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
_object setVariable [QGVAR(poweredOn), _config getOrDefault ["poweredOn", true], true];
_object setVariable [QGVAR(data), _config getOrDefault ["data", [_config] call FUNC(createDefaultData)], true];

if !(GVAR(registeredComputers) isEqualType []) then {
	GVAR(registeredComputers) = [];
};

GVAR(registeredComputers) pushBackUnique _object;

[_object] call FUNC(addActions);

_object
