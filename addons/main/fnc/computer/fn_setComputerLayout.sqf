#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Applies a layout config to a registered MMC computer.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: Layout config <HASHMAP>
 *
 * Return Value:
 * Applied <BOOL>
 */

params [
	["_object", objNull, [objNull]],
	["_layout", createHashMap, [createHashMap]]
];

if (isNull _object || {!(_layout isEqualType createHashMap)}) exitWith {false};

private _config = _object getVariable [QGVAR(config), createHashMap];
if !(_config isEqualType createHashMap) then {
	_config = createHashMap;
};
_config set ["layout", _layout];
_object setVariable [QGVAR(config), _config, true];

private _data = _object getVariable [QGVAR(data), [_config] call FUNC(createDefaultData)];
if !(_data isEqualType createHashMap) then {
	_data = [_config] call FUNC(createDefaultData);
};
_data set ["layout", _layout];
_object setVariable [QGVAR(data), _data, true];

true
