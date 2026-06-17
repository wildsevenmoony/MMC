#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a picked-up MMC device item locally and stores its preserved data record.
 *
 * Arguments:
 * 0: Inventory item classname <STRING>
 * 1: Device record <HASHMAP>
 *
 * Return Value:
 * Received <BOOL>
 */

params [
	["_itemClass", "", [""]],
	["_record", createHashMap, [createHashMap]]
];

if (!hasInterface || {isNull player} || {_itemClass isEqualTo ""}) exitWith {false};

private _added = false;
if (player canAdd _itemClass) then {
	player addItem _itemClass;
	_added = true;
};

if (!_added) exitWith {false};

private _records = player getVariable [QGVAR(carriedMobileDevices), []];
if !(_records isEqualType []) then {
	_records = [];
};

private _id = _record getOrDefault ["id", ""];
if (_id isNotEqualTo "" && {_records findIf {(_x getOrDefault ["id", ""]) isEqualTo _id} < 0}) then {
	_records pushBack _record;
	player setVariable [QGVAR(carriedMobileDevices), _records, true];
};

private _type = [_itemClass] call FUNC(getMobileDeviceType);
if (count _type > 0) then {
	private _deviceInfo = +_record;
	_deviceInfo set ["type", _type];
	[player, _deviceInfo, false] remoteExecCall [QFUNC(openMobileServer), 2];
};

true
