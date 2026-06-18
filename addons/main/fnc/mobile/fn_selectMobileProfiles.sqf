#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Selects all mobile profiles matching a player and inventory device.
 *
 * Arguments:
 * 0: Player <OBJECT>
 * 1: Mobile device record <HASHMAP>
 *
 * Return Value:
 * Matching profiles, sorted by priority from low to high <ARRAY>
 */

params [
	["_player", objNull, [objNull]],
	["_deviceInfo", createHashMap, [createHashMap]]
];

if (isNull _player) exitWith {[]};
if !(GVAR(mobileProfiles) isEqualType []) then {
	GVAR(mobileProfiles) = [];
};

private _itemClass = _deviceInfo getOrDefault ["itemClass", ""];
private _deviceType = _deviceInfo getOrDefault ["type", createHashMap];
if !(_deviceType isEqualType createHashMap) then {
	_deviceType = [_itemClass] call FUNC(getMobileDeviceType);
};
private _deviceId = _deviceType getOrDefault ["id", _deviceInfo getOrDefault ["id", ""]];
private _baseItemClass = _deviceInfo getOrDefault ["baseItemClass", _deviceType getOrDefault ["baseItemClass", _itemClass]];
private _source = _deviceInfo getOrDefault ["source", ""];
private _uid = getPlayerUID _player;
private _playerName = name _player;
private _unitVar = vehicleVarName _player;
private _unitNetId = netId _player;
private _unitClass = typeOf _player;
private _faction = faction _player;
private _groupId = groupId group _player;
private _assignedProfileIds = _player getVariable [QGVAR(assignedMobileProfileIds), []];
if !(_assignedProfileIds isEqualType []) then {
	_assignedProfileIds = [];
};
_assignedProfileIds = _assignedProfileIds apply {
	private _entry = if (_x isEqualType "") then {_x} else {str _x};
	toLowerANSI ([_entry] call CBA_fnc_trim)
};

private _sideKey = {
	params ["_value"];
	if (_value isEqualType sideUnknown) exitWith {toLowerANSI str _value};
	if (_value isEqualType "") exitWith {
		switch (toLowerANSI _value) do {
			case "blu";
			case "blue";
			case "blufor";
			case "west": {"west"};
			case "red";
			case "opfor";
			case "east": {"east"};
			case "green";
			case "independent";
			case "resistance";
			case "guer": {"guer"};
			case "civilian";
			case "civ": {"civ"};
			default {toLowerANSI _value};
		}
	};
	toLowerANSI str _value
};
private _playerSide = [side group _player] call _sideKey;

private _asArray = {
	params ["_value"];
	if (isNil "_value") exitWith {[]};
	if (_value isEqualType []) exitWith {_value};
	if (_value isEqualType "") exitWith {
		(_value splitString ",") apply {[_x] call CBA_fnc_trim} select {_x isNotEqualTo ""}
	};
	[_value]
};

private _matchesList = {
	params ["_profile", "_keys", "_value", ["_lower", true]];
	private _list = [];
	{
		_list append ([_profile getOrDefault [_x, []]] call _asArray);
	} forEach _keys;
	if (_list isEqualTo []) exitWith {true};
	private _lookup = if (_lower) then {toLowerANSI _value} else {_value};
	(_list findIf {
		private _entry = if (_lower && {_x isEqualType ""}) then {toLowerANSI _x} else {_x};
		_entry isEqualTo _lookup
	}) >= 0
};

private _matchesSide = {
	params ["_profile"];
	private _list = [_profile getOrDefault ["sides", _profile getOrDefault ["side", []]]] call _asArray;
	if (_list isEqualTo []) exitWith {true};
	(_list findIf {([_x] call _sideKey) isEqualTo _playerSide}) >= 0
};

private _matchesCondition = {
	params ["_profile"];
	if !("condition" in keys _profile) exitWith {true};
	private _condition = _profile getOrDefault ["condition", {}];
	if !(_condition isEqualType {}) exitWith {true};
	private _result = [_player, _deviceInfo, _profile] call _condition;
	if !(_result isEqualType true) exitWith {false};
	_result
};

private _matchesUnitObjects = {
	params ["_profile"];
	private _list = [];
	{
		_list append ([_profile getOrDefault [_x, []]] call _asArray);
	} forEach ["units", "unitObjects"];
	if (_list isEqualTo []) exitWith {true};
	(_list findIf {_x isEqualType objNull && {_x isEqualTo _player}}) >= 0
};

private _profilePool = +GVAR(mobileProfiles);
private _assignedProfileConfigs = _player getVariable [QGVAR(assignedMobileProfileConfigs), []];
if !(_assignedProfileConfigs isEqualType []) then {
	_assignedProfileConfigs = [];
};

["MobileProfile", "Selecting mobile profiles", createHashMapFromArray [
	["player", format ["%1:%2:%3", name _player, getPlayerUID _player, typeOf _player]],
	["unitVar", _unitVar],
	["unitNetId", _unitNetId],
	["itemClass", _itemClass],
	["baseItemClass", _baseItemClass],
	["deviceId", _deviceId],
	["source", _source],
	["registeredProfiles", count GVAR(mobileProfiles)],
	["assignedIds", _assignedProfileIds],
	["assignedConfigs", count _assignedProfileConfigs]
]] call FUNC(debugLog);

{
	if (_x isEqualType createHashMap) then {
		private _profileId = toLowerANSI ([_x getOrDefault ["id", ""]] call CBA_fnc_trim);
		private _index = _profilePool findIf {toLowerANSI (_x getOrDefault ["id", ""]) isEqualTo _profileId};
		if (_index < 0 || {_profileId isEqualTo ""}) then {
			_profilePool pushBack _x;
		} else {
			_profilePool set [_index, _x];
		};
	};
} forEach _assignedProfileConfigs;

private _matches = [];
{
	private _profile = _x;
	if (_profile isEqualType createHashMap) then {
		private _profileId = _profile getOrDefault ["id", ""];
		private _profileIdLower = toLowerANSI ([_profileId] call CBA_fnc_trim);
		private _explicitlyAssigned = _profileIdLower isNotEqualTo "" && {_profileIdLower in _assignedProfileIds};
		private _ok = true;
		_ok = _ok && {
			[_profile, ["itemClasses", "itemClass"], _itemClass] call _matchesList
			|| {_baseItemClass isNotEqualTo _itemClass && {[_profile, ["itemClasses", "itemClass"], _baseItemClass] call _matchesList}}
		};
		_ok = _ok && {[_profile, ["deviceIds", "deviceId"], _deviceId] call _matchesList};
		_ok = _ok && {[_profile, ["sources", "source"], _source] call _matchesList};
		if (!_explicitlyAssigned) then {
			_ok = _ok && {[_profile, ["playerUIDs", "uids", "uid"], _uid] call _matchesList};
			_ok = _ok && {[_profile, ["playerNames", "names", "playerName"], _playerName] call _matchesList};
			_ok = _ok && {[_profile, ["unitVars", "unitVar", "variableNames"], _unitVar] call _matchesList};
			_ok = _ok && {[_profile, ["unitNetIds", "unitNetId"], _unitNetId] call _matchesList};
			_ok = _ok && {[_profile] call _matchesUnitObjects};
			_ok = _ok && {[_profile, ["unitClasses", "unitClass"], _unitClass] call _matchesList};
			_ok = _ok && {[_profile, ["factions", "faction"], _faction] call _matchesList};
			_ok = _ok && {[_profile, ["groups", "groupIds", "groupId"], _groupId] call _matchesList};
			_ok = _ok && {[_profile] call _matchesSide};
		};
		_ok = _ok && {[_profile] call _matchesCondition};

		if (_ok) then {
			_matches pushBack [_profile getOrDefault ["priority", 0], _profileId, _profile];
		};

		["MobileProfile", "Profile match evaluated", createHashMapFromArray [
			["id", _profileId],
			["explicitlyAssigned", _explicitlyAssigned],
			["matched", _ok],
			["sources", _profile getOrDefault ["sources", _profile getOrDefault ["source", []]]],
			["itemClasses", _profile getOrDefault ["itemClasses", _profile getOrDefault ["itemClass", []]]],
			["deviceIds", _profile getOrDefault ["deviceIds", _profile getOrDefault ["deviceId", []]]],
			["unitVars", _profile getOrDefault ["unitVars", []]],
			["unitNetIds", _profile getOrDefault ["unitNetIds", []]],
			["files", count (_profile getOrDefault ["files", []])],
			["mails", count (_profile getOrDefault ["mails", []])]
		]] call FUNC(debugLog);
	};
} forEach _profilePool;

_matches sort true;
["MobileProfile", "Selected mobile profiles", createHashMapFromArray [
	["count", count _matches],
	["ids", _matches apply {_x select 1}]
]] call FUNC(debugLog);
_matches apply {_x select 2}
