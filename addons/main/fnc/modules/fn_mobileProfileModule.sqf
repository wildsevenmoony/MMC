#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Registers an Eden Mobile Profile module for personal inventory MMC devices.
 *
 * Arguments:
 * 0: Module logic or 3DEN callback mode <OBJECT or STRING>
 * 1: Synced objects or 3DEN callback input <ARRAY>
 * 2: Activated <BOOL>
 *
 * Return Value:
 * Registered <BOOL>
 */

private _logic = objNull;
private _activated = true;

if ((_this param [0, objNull]) isEqualType "") then {
	private _mode = _this param [0, "", [""]];
	private _input = _this param [1, [], [[]]];

	if !(_mode in ["init", "attributesChanged3DEN", "registeredToWorld3DEN", "connectionChanged3DEN"]) exitWith {true};

	_input params [
		["_logicInput", objNull, [objNull]],
		["_activatedInput", true, [true]]
	];

	_logic = _logicInput;
	_activated = _activatedInput;

	if (is3DEN) exitWith {true};
} else {
	_this params [
		["_logicInput", objNull, [objNull]],
		["_objectsInput", [], [[]]],
		["_activatedInput", true, [true]]
	];

	_logic = _logicInput;
	_activated = _activatedInput;
};

if (!_activated || {isNull _logic}) exitWith {true};

["MobileProfile", "Module activation", createHashMapFromArray [
	["logic", _logic],
	["synced", (synchronizedObjects _logic) apply {format ["%1:%2", typeOf _x, _x]}],
	["activated", _activated]
]] call FUNC(debugLog);

private _splitList = {
	params [["_text", "", [""]]];

	private _list = [];
	{
		private _entry = [_x] call CBA_fnc_trim;
		_entry = _entry splitString """'" joinString "";
		if (_entry isNotEqualTo "") then {
			_list pushBackUnique _entry;
		};
	} forEach (_text splitString ",");
	_list
};

private _id = toLowerANSI ([_logic getVariable [QGVAR(mobileProfileId), "mobile_profile"]] call CBA_fnc_trim);
if (_id isEqualTo "") then {
	_id = format ["mobile_profile_%1", netId _logic];
};

private _sources = switch (_logic getVariable [QGVAR(mobileProfileSource), "personal"]) do {
	case "picked": {["picked"]};
	case "both": {["personal", "picked"]};
	default {["personal"]};
};

private _profile = _logic getVariable [QGVAR(mobileProfileConfig), createHashMap];
if !(_profile isEqualType createHashMap) then {
	_profile = createHashMap;
};

_profile set ["id", _id];
_profile set ["priority", _logic getVariable [QGVAR(mobileProfilePriority), 0]];
_profile set ["sources", _sources];
_profile set ["theme", _logic getVariable [QGVAR(mobileProfileTheme), "default"]];
_profile set ["aliases", [_logic getVariable [QGVAR(mobileProfileAliases), ""]] call _splitList];
private _emailDomain = [_logic getVariable [QGVAR(mobileProfileEmailDomain), ""]] call CBA_fnc_trim;
if (_emailDomain isNotEqualTo "") then {
	_profile set ["emailDomain", _emailDomain];
} else {
	_profile deleteAt "emailDomain";
};
private _lockCode = [_logic getVariable [QGVAR(mobileLockCode), ""]] call CBA_fnc_trim;
if (_lockCode isNotEqualTo "") then {
	_profile set ["lockCode", _lockCode];
} else {
	_profile deleteAt "lockCode";
};
private _messengerName = [_logic getVariable [QGVAR(messengerName), ""]] call CBA_fnc_trim;
if (_messengerName isNotEqualTo "") then {
	_profile set ["displayName", _messengerName];
	_profile set ["messengerName", _messengerName];
} else {
	_profile deleteAt "displayName";
	_profile deleteAt "messengerName";
};
_profile set ["itemClasses", [_logic getVariable [QGVAR(mobileProfileItemClasses), ""]] call _splitList];
_profile set ["deviceIds", [_logic getVariable [QGVAR(mobileProfileDeviceIds), ""]] call _splitList];
_profile set ["playerUIDs", [_logic getVariable [QGVAR(mobileProfileUIDs), ""]] call _splitList];
_profile set ["playerNames", [_logic getVariable [QGVAR(mobileProfilePlayerNames), ""]] call _splitList];
_profile set ["unitVars", [_logic getVariable [QGVAR(mobileProfileUnitVars), ""]] call _splitList];
_profile set ["unitClasses", [_logic getVariable [QGVAR(mobileProfileUnitClasses), ""]] call _splitList];
_profile set ["factions", [_logic getVariable [QGVAR(mobileProfileFactions), ""]] call _splitList];
_profile set ["groups", [_logic getVariable [QGVAR(mobileProfileGroups), ""]] call _splitList];

private _side = _logic getVariable [QGVAR(mobileProfileSide), ""];
if (_side isEqualTo "") then {
	_profile set ["sides", []];
} else {
	_profile set ["sides", [_side]];
};

private _appScripts = [_logic getVariable [QGVAR(mobileProfileAppScripts), ""]] call _splitList;
if (_appScripts isNotEqualTo []) then {
	_profile set ["appScripts", _appScripts];
};

_profile set ["disabledApps", [_logic] call FUNC(getDisabledAppsFromConfig)];
_profile = [_profile, synchronizedObjects _logic, _logic] call FUNC(enrichMobileProfileFromModules);

["MobileProfile", "Profile built", createHashMapFromArray [
	["id", _id],
	["sources", _profile getOrDefault ["sources", []]],
	["theme", _profile getOrDefault ["theme", ""]],
	["hasLockCode", (_profile getOrDefault ["lockCode", ""]) isNotEqualTo ""],
	["aliases", _profile getOrDefault ["aliases", []]],
	["itemClasses", _profile getOrDefault ["itemClasses", []]],
	["deviceIds", _profile getOrDefault ["deviceIds", []]],
	["files", count (_profile getOrDefault ["files", []])],
	["mails", count (_profile getOrDefault ["mails", []])],
	["hasLayout", count (_profile getOrDefault ["layout", createHashMap]) > 0],
	["hasDesktop", ("desktopContent" in (keys _profile)) || {"desktopScript" in (keys _profile)}]
]] call FUNC(debugLog);

_logic setVariable [QGVAR(isMobileProfileModule), true, true];
_logic setVariable [QGVAR(mobileProfileConfig), _profile, true];

[_id, _profile] call FUNC(registerMobileProfile);
[_id, _profile] remoteExecCall [QFUNC(registerMobileProfile), 0, format [QGVAR(mobileProfile_%1), _id]];

// Keep the logic alive so synced content modules can enrich this profile.
true
