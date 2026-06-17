#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Builds a list of MMC mobile devices currently available from the local player's inventory.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Available device records <ARRAY>
 */

if (!hasInterface || {isNull player}) exitWith {[]};

private _inventory = (items player) + (assignedItems player);
private _records = player getVariable [QGVAR(carriedMobileDevices), []];
if !(_records isEqualType []) then {
	_records = [];
};

private _available = [];
private _usedCounts = createHashMap;
private _keptRecords = [];

{
	if (_x isEqualType createHashMap) then {
		private _itemClass = _x getOrDefault ["itemClass", ""];
		private _type = [_itemClass] call FUNC(getMobileDeviceType);
		if (count _type > 0) then {
			private _ownedCount = {_x isEqualTo _itemClass} count _inventory;
			private _usedCount = _usedCounts getOrDefault [_itemClass, 0];
			if (_usedCount < _ownedCount) then {
				private _record = +_x;
				_record set ["type", _type];
				_record set ["source", _record getOrDefault ["source", "picked"]];
				_record set ["label", _record getOrDefault ["label", _type getOrDefault ["label", _itemClass]]];
				_record set ["orientation", _record getOrDefault ["orientation", _type getOrDefault ["orientation", "horizontal"]]];
				_record set ["icon", _record getOrDefault ["icon", _type getOrDefault ["icon", ""]]];
				_available pushBack _record;
				_keptRecords pushBack _x;
				_usedCounts set [_itemClass, _usedCount + 1];
			};
		};
	};
} forEach _records;

if (_keptRecords isNotEqualTo _records) then {
	player setVariable [QGVAR(carriedMobileDevices), _keptRecords, true];
};

{
	private _itemClass = _x;
	private _usedCount = _usedCounts getOrDefault [_itemClass, 0];
	if (_usedCount > 0) then {
		_usedCounts set [_itemClass, _usedCount - 1];
	} else {
		private _type = [_itemClass] call FUNC(getMobileDeviceType);
		if (count _type > 0) then {
			private _isUnique = _type getOrDefault ["unique", false];
			private _baseLabel = _type getOrDefault ["label", _itemClass];
			private _label = if (_isUnique) then {
				getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName")
			} else {
				_baseLabel
			};
			if (_label isEqualTo "") then {
				_label = _baseLabel;
			};
			private _key = ["personal", _itemClass] select _isUnique;
			_available pushBack createHashMapFromArray [
				["id", [_type getOrDefault ["id", _itemClass], _itemClass] select _isUnique],
				["key", _key],
				["itemClass", _itemClass],
				["baseItemClass", _type getOrDefault ["baseItemClass", _itemClass]],
				["label", _label],
				["orientation", _type getOrDefault ["orientation", "horizontal"]],
				["icon", _type getOrDefault ["icon", ""]],
				["source", "personal"],
				["type", _type]
			];
		};
	};
} forEach _inventory;

["Mobile", "Built mobile inventory device list", createHashMapFromArray [
	["inventory", _inventory],
	["carriedRecords", _records apply {
		if (_x isEqualType createHashMap) then {
			createHashMapFromArray [
				["itemClass", _x getOrDefault ["itemClass", ""]],
				["key", _x getOrDefault ["key", ""]],
				["source", _x getOrDefault ["source", ""]]
			]
		} else {
			str _x
		}
	}],
	["available", _available apply {
		createHashMapFromArray [
			["itemClass", _x getOrDefault ["itemClass", ""]],
			["baseItemClass", _x getOrDefault ["baseItemClass", ""]],
			["key", _x getOrDefault ["key", ""]],
			["source", _x getOrDefault ["source", ""]],
			["label", _x getOrDefault ["label", ""]]
		]
	}]
]] call FUNC(debugLog);

_available
