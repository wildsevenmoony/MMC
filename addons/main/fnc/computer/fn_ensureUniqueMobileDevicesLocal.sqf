#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Requests unique MMC mobile subclasses for unassigned prototype inventory items.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Replacement request sent <BOOL>
 */

if (!hasInterface || {isNull player}) exitWith {false};
if (missionNamespace getVariable [QGVAR(uniqueMobileRequestPending), false]) exitWith {false};

private _inventory = (items player) + (assignedItems player);
private _records = player getVariable [QGVAR(carriedMobileDevices), []];
if !(_records isEqualType []) then {
	_records = [];
};

private _protectedCounts = createHashMap;
{
	if (_x isEqualType createHashMap) then {
		private _recordClass = _x getOrDefault ["itemClass", ""];
		if (_recordClass isNotEqualTo "") then {
			_protectedCounts set [_recordClass, (_protectedCounts getOrDefault [_recordClass, 0]) + 1];
		};
	};
} forEach _records;

private _toRequest = [];
{
	private _baseClass = _x getOrDefault ["itemClass", ""];
	private _ownedCount = {_x isEqualTo _baseClass} count _inventory;
	private _protectedCount = _protectedCounts getOrDefault [_baseClass, 0];
	private _replaceCount = (_ownedCount - _protectedCount) max 0;
	for "_i" from 1 to _replaceCount do {
		_toRequest pushBack _baseClass;
	};
} forEach ([] call FUNC(getMobileDeviceTypes));

if (_toRequest isEqualTo []) exitWith {false};

missionNamespace setVariable [QGVAR(uniqueMobileRequestPending), true];
["Mobile", "Requesting unique mobile device replacements", createHashMapFromArray [
	["items", _toRequest],
	["inventory", _inventory],
	["carriedRecords", _records apply {
		if (_x isEqualType createHashMap) then {_x getOrDefault ["itemClass", ""]} else {str _x}
	}]
]] call FUNC(debugLog);
[player, _toRequest] remoteExecCall [QFUNC(requestUniqueMobileDevices), 2];
true
