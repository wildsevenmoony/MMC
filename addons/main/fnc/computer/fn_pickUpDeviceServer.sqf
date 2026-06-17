#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Captures a placeable MMC mobile device's data and transfers it into a player's inventory.
 *
 * Arguments:
 * 0: Device object <OBJECT>
 * 1: Player <OBJECT>
 *
 * Return Value:
 * Picked up <BOOL>
 */

params [
	["_object", objNull, [objNull]],
	["_player", objNull, [objNull]]
];

if (!isServer || {isNull _object} || {isNull _player}) exitWith {false};
if (_player distance _object > 5) exitWith {false};

private _type = [typeOf _object] call FUNC(getMobileDeviceType);
if (count _type == 0) exitWith {false};

private _itemClass = _type getOrDefault ["itemClass", ""];
if (_itemClass isEqualTo "") exitWith {false};
private _baseItemClass = _itemClass;

if !(GVAR(mobileUniqueCounters) isEqualType createHashMap) then {
	GVAR(mobileUniqueCounters) = createHashMap;
};

private _counter = GVAR(mobileUniqueCounters) getOrDefault [_baseItemClass, 0];
private _uniqueClass = "";
while {_counter < 200 && {_uniqueClass isEqualTo ""}} do {
	_counter = _counter + 1;
	private _candidate = format ["%1_%2", _baseItemClass, _counter];
	if (isClass (configFile >> "CfgWeapons" >> _candidate)) then {
		_uniqueClass = _candidate;
	};
};
GVAR(mobileUniqueCounters) set [_baseItemClass, _counter];
if (_uniqueClass isNotEqualTo "") then {
	_itemClass = _uniqueClass;
};

private _data = _object getVariable [QGVAR(data), createHashMap];
private _label = _data getOrDefault ["systemName", _object getVariable [QGVAR(systemName), _type getOrDefault ["label", "Mobile Device"]]];
private _record = createHashMapFromArray [
	["id", format ["picked_%1_%2_%3", getPlayerUID _player, floor serverTime, floor random 100000]],
	["key", _itemClass],
	["itemClass", _itemClass],
	["baseItemClass", _baseItemClass],
	["label", _label],
	["orientation", _object getVariable [QGVAR(mobileDefaultOrientation), _type getOrDefault ["orientation", "horizontal"]]],
	["icon", _type getOrDefault ["icon", ""]],
	["source", "picked"],
	["data", _data]
];

private _records = _player getVariable [QGVAR(carriedMobileDevices), []];
if !(_records isEqualType []) then {
	_records = [];
};
_records pushBack _record;
_player setVariable [QGVAR(carriedMobileDevices), _records, true];

if (GVAR(registeredComputers) isEqualType []) then {
	private _index = GVAR(registeredComputers) find _object;
	if (_index >= 0) then {
		GVAR(registeredComputers) deleteAt _index;
	};
};

[_itemClass, _record] remoteExecCall [QFUNC(receivePickedDeviceLocal), _player];
deleteVehicle _object;

true
