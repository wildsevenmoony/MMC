#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Registers a mobile profile for personal inventory MMC devices.
 *
 * Arguments:
 * 0: Profile id <STRING>
 * 1: Profile config <HASHMAP or ARRAY>
 *
 * Return Value:
 * Registered <BOOL>
 *
 * Example:
 * ["aaf_drone_ops", createHashMapFromArray [["side", independent], ["apps", []]]] call MMC_fnc_registerMobileProfile
 */

params [
	["_id", "", [""]],
	["_config", createHashMap, [createHashMap, []]]
];

_id = toLowerANSI ([_id] call CBA_fnc_trim);
if (_id isEqualTo "") exitWith {false};

private _profile = if (_config isEqualType createHashMap) then {
	+_config
} else {
	createHashMapFromArray _config
};

_profile set ["id", _id];
_profile set ["priority", _profile getOrDefault ["priority", 0]];
if (!("source" in keys _profile) && {!("sources" in keys _profile)}) then {
	_profile set ["sources", ["personal"]];
};

if !(GVAR(mobileProfiles) isEqualType []) then {
	GVAR(mobileProfiles) = [];
};

private _index = GVAR(mobileProfiles) findIf {toLowerANSI (_x getOrDefault ["id", ""]) isEqualTo _id};
if (_index < 0) then {
	GVAR(mobileProfiles) pushBack _profile;
} else {
	GVAR(mobileProfiles) set [_index, _profile];
};

["MobileProfile", "Registered mobile profile", createHashMapFromArray [
	["id", _id],
	["index", _index],
	["total", count GVAR(mobileProfiles)],
	["sources", _profile getOrDefault ["sources", _profile getOrDefault ["source", []]]],
	["theme", _profile getOrDefault ["theme", ""]],
	["files", count (_profile getOrDefault ["files", []])],
	["mails", count (_profile getOrDefault ["mails", []])],
	["appScripts", _profile getOrDefault ["appScripts", []]]
]] call FUNC(debugLog);

true
