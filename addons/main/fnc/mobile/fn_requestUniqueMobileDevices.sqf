#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Allocates hidden unique MMC mobile device item classes on the server.
 *
 * Arguments:
 * 0: Unit requesting replacements <OBJECT>
 * 1: Prototype item classes to replace <ARRAY>
 *
 * Return Value:
 * Request handled <BOOL>
 */

params [
	["_unit", objNull, [objNull]],
	["_items", [], [[]]]
];

if (!isServer || {isNull _unit}) exitWith {false};

["Mobile", "Server received unique mobile device request", createHashMapFromArray [
	["unit", format ["%1:%2:%3", name _unit, getPlayerUID _unit, typeOf _unit]],
	["items", _items]
]] call FUNC(debugLog);

if !(GVAR(mobileUniqueCounters) isEqualType createHashMap) then {
	GVAR(mobileUniqueCounters) = createHashMap;
};

private _pairs = [];
{
	private _base = _x;
	private _type = [_base] call FUNC(getMobileDeviceType);
	if (count _type > 0 && {!(_type getOrDefault ["unique", false])}) then {
		private _counter = GVAR(mobileUniqueCounters) getOrDefault [_base, 0];
		private _uniqueClass = "";
		while {_counter < 200 && {_uniqueClass isEqualTo ""}} do {
			_counter = _counter + 1;
			private _candidate = format ["%1_%2", _base, _counter];
			if (isClass (configFile >> "CfgWeapons" >> _candidate)) then {
				_uniqueClass = _candidate;
			};
		};
		GVAR(mobileUniqueCounters) set [_base, _counter];
		if (_uniqueClass isNotEqualTo "") then {
			_pairs pushBack [_base, _uniqueClass];
		};
	};
} forEach _items;

[_pairs] remoteExecCall [QFUNC(receiveUniqueMobileDevicesLocal), _unit];
["Mobile", "Server allocated unique mobile devices", createHashMapFromArray [
	["unit", format ["%1:%2", name _unit, getPlayerUID _unit]],
	["pairs", _pairs]
]] call FUNC(debugLog);
true
