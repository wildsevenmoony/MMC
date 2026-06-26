#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Replaces local prototype MMC mobile items with allocated unique subclasses.
 *
 * Arguments:
 * 0: Replacement pairs [prototype, unique] <ARRAY>
 *
 * Return Value:
 * Applied <BOOL>
 */

params [["_pairs", [], [[]]]];

missionNamespace setVariable [QGVAR(uniqueMobileRequestPending), false];

if (!hasInterface || {isNull player}) exitWith {false};

["Mobile", "Received unique mobile device replacements", createHashMapFromArray [
	["pairs", _pairs],
	["inventoryBefore", (items player) + (assignedItems player)]
]] call FUNC(debugLog);

{
	_x params [
		["_baseClass", "", [""]],
		["_uniqueClass", "", [""]]
	];

	if (_baseClass isNotEqualTo "" && {_uniqueClass isNotEqualTo ""} && {_baseClass in ((items player) + (assignedItems player))}) then {
		private _assigned = _baseClass in (assignedItems player);
		if (_assigned) then {
			player unlinkItem _baseClass;
		} else {
			player removeItem _baseClass;
		};

		if (_assigned) then {
			player linkItem _uniqueClass;
		} else {
			player addItem _uniqueClass;
		};

		private _type = [_uniqueClass] call FUNC(getMobileDeviceType);
		if (count _type > 0) then {
			private _deviceInfo = createHashMapFromArray [
				["id", _uniqueClass],
				["key", _uniqueClass],
				["itemClass", _uniqueClass],
				["baseItemClass", _baseClass],
				["label", getText (configFile >> "CfgWeapons" >> _uniqueClass >> "displayName")],
				["orientation", _type getOrDefault ["orientation", "horizontal"]],
				["icon", _type getOrDefault ["icon", ""]],
				["source", "personal"],
				["clientLockCode", missionNamespace getVariable [QGVAR(mobileLockCode), ""]],
				["type", _type]
			];
			["Mobile", "Opening newly assigned unique mobile device for data initialization", createHashMapFromArray [
				["baseClass", _baseClass],
				["uniqueClass", _uniqueClass],
				["deviceInfo", _deviceInfo]
			]] call FUNC(debugLog);
			[player, _deviceInfo, false] remoteExecCall [QFUNC(openMobileServer), 2];
		};
	};
} forEach _pairs;

["Mobile", "Applied unique mobile device replacements", createHashMapFromArray [
	["inventoryAfter", (items player) + (assignedItems player)]
]] call FUNC(debugLog);

true
