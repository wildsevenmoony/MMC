#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Opens a prepared mobile MMC computer object on the owning client.
 *
 * Arguments:
 * 0: Mobile computer object <OBJECT>
 * 1: Synchronized computer data <HASHMAP>
 * 2: Default orientation <STRING, default: "horizontal">
 * 3: Device label <STRING, default: "Mobile Device">
 * 4: Matched app profiles <ARRAY, optional>
 *
 * Return Value:
 * Opened <BOOL>
 */

params [
	["_device", objNull, [objNull]],
	["_data", createHashMap, [createHashMap]],
	["_orientation", "horizontal", [""]],
	["_label", "Mobile Device", [""]],
	["_matchedProfiles", [], [[]]]
];

if (!hasInterface || {isNull _device}) exitWith {false};

["Mobile", "Opening mobile display locally", createHashMapFromArray [
	["device", _device],
	["orientation", _orientation],
	["label", _label],
	["users", (_data getOrDefault ["users", []]) apply {
		createHashMapFromArray [
			["username", _x getOrDefault ["username", ""]],
			["email", _x getOrDefault ["email", ""]],
			["theme", _x getOrDefault ["theme", ""]],
			["files", count (_x getOrDefault ["files", []])],
			["mail", count (_x getOrDefault ["mail", []])],
			["outbox", count (_x getOrDefault ["outbox", []])],
			["aliases", _x getOrDefault ["emailAliases", []]]
		]
	}],
	["matchedProfiles", _matchedProfiles]
]] call FUNC(debugLog);

_device setVariable [QGVAR(isComputer), true];
_device setVariable [QGVAR(isMobileComputer), true];
_device setVariable [QGVAR(mobileDefaultOrientation), _orientation];
_device setVariable [QGVAR(mobileDeviceLabel), _label];
_device setVariable [QGVAR(data), _data];
_device setVariable [QGVAR(poweredOn), true];
_device setVariable [QGVAR(booting), false];
[_device] call FUNC(ensureAutoLoginUser);

private _profiles = _matchedProfiles select {_x isEqualType createHashMap};
if (_profiles isEqualTo []) then {
	private _profileIds = _device getVariable [QGVAR(mobileAppliedProfiles), []];
	if (GVAR(mobileProfiles) isEqualType []) then {
		{
			private _lookup = toLowerANSI _x;
			private _index = GVAR(mobileProfiles) findIf {toLowerANSI (_x getOrDefault ["id", ""]) isEqualTo _lookup};
			if (_index >= 0) then {
				_profiles pushBack (GVAR(mobileProfiles) select _index);
			};
		} forEach _profileIds;
	};
};
[_device, player, _profiles] call FUNC(applyMobileProfileLocal);

["Mobile", "Applied local mobile profiles", createHashMapFromArray [
	["profileIds", _profiles apply {_x getOrDefault ["id", ""]}]
]] call FUNC(debugLog);

GVAR(activeComputer) = _device;
GVAR(openingMobile) = true;
createDialog QGVAR(RscMobileComputer);
true
