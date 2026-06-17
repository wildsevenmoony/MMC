#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Rebuilds mobile profile data from placed mobile profile modules and any
 * synced MMC content modules that still exist.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Refreshed at least one profile module <BOOL>
 *
 * Example:
 * [] call MMC_fnc_refreshMobileProfilesFromModules
 */

if (!isServer) exitWith {false};

private _profileTypes = [QGVAR(mobileProfile), QGVAR(assignMobileProfile)];
private _logics = (allMissionObjects "Logic") + (allMissionObjects "Module_F");
_logics = _logics arrayIntersect _logics;

private _profileModules = _logics select {typeOf _x in _profileTypes};
private _refreshed = false;

["MobileProfile", "Refreshing mobile profiles from modules", createHashMapFromArray [
	["moduleCount", count _profileModules],
	["modules", _profileModules apply {format ["%1:%2", typeOf _x, _x]}]
]] call FUNC(debugLog);

{
	private _profileModule = _x;
	private _profileType = typeOf _profileModule;
	private _syncedObjects = synchronizedObjects _profileModule;

	["MobileProfile", "Refreshing one profile module", createHashMapFromArray [
		["module", _profileModule],
		["type", _profileType],
		["synced", _syncedObjects apply {format ["%1:%2", typeOf _x, _x]}]
	]] call FUNC(debugLog);

	if (_profileType isEqualTo QGVAR(assignMobileProfile)) then {
		[_profileModule, _syncedObjects, true, true] call FUNC(assignMobileProfileModule);
	} else {
		[_profileModule, _syncedObjects, true] call FUNC(mobileProfileModule);
	};
	_refreshed = true;
} forEach _profileModules;

_refreshed
