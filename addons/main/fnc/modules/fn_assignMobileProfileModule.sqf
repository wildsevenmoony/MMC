#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Registers a simple unit-bound mobile profile from an Eden module.
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
private _objects = [];
private _activated = true;
private _skipGiveDevice = false;

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
		["_activatedInput", true, [true]],
		["_skipGiveDeviceInput", false, [false]]
	];

	_logic = _logicInput;
	_objects = _objectsInput;
	_activated = _activatedInput;
	_skipGiveDevice = _skipGiveDeviceInput;
};

if (!_activated || {isNull _logic}) exitWith {true};

_objects append (synchronizedObjects _logic);
_objects = _objects arrayIntersect _objects;

["AssignProfile", "Module activation", createHashMapFromArray [
	["logic", _logic],
	["objects", _objects apply {format ["%1:%2", typeOf _x, _x]}],
	["activated", _activated],
	["skipGiveDevice", _skipGiveDevice]
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

private _units = _objects select {_x isKindOf "CAManBase"};
private _id = _logic getVariable [QGVAR(assignMobileProfileId), ""];
_id = toLowerANSI ([_id] call CBA_fnc_trim);
if (_id isEqualTo "") then {
	_id = format ["assigned_mobile_%1", netId _logic];
};

private _profile = _logic getVariable [QGVAR(mobileProfileConfig), createHashMap];
if !(_profile isEqualType createHashMap) then {
	_profile = createHashMap;
};

private _email = [_logic getVariable [QGVAR(assignMobileProfileEmail), ""]] call CBA_fnc_trim;
private _appScripts = [_logic getVariable [QGVAR(mobileProfileAppScripts), ""]] call _splitList;
private _unitVars = [];
{
	private _var = vehicleVarName _x;
	if (_var isNotEqualTo "") then {
		_unitVars pushBackUnique _var;
	};
} forEach _units;

private _sideText = "";
private _displayName = "";
if (_units isNotEqualTo []) then {
	private _unit = _units select 0;
	_sideText = str (side group _unit);
	_displayName = name _unit;
};
private _messengerName = [_logic getVariable [QGVAR(messengerName), ""]] call CBA_fnc_trim;
if (_messengerName isNotEqualTo "") then {
	_displayName = _messengerName;
};

_profile set ["id", _id];
_profile set ["priority", _logic getVariable [QGVAR(assignMobileProfilePriority), 100]];
_profile set ["sources", ["personal"]];
_profile set ["units", _units];
_profile set ["unitNetIds", _units apply {netId _x} select {_x isNotEqualTo ""}];
_profile set ["unitVars", _unitVars];
if (_sideText isNotEqualTo "") then {
	_profile set ["side", _sideText];
	_profile set ["messengerSide", _sideText];
};
if (_displayName isNotEqualTo "") then {
	_profile set ["displayName", _displayName];
	_profile set ["messengerName", _displayName];
};
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
_profile set ["disabledApps", [_logic] call FUNC(getDisabledAppsFromConfig)];
if (_email isNotEqualTo "") then {
	_profile set ["primaryEmail", _email];
} else {
	_profile deleteAt "primaryEmail";
};
if (_appScripts isNotEqualTo []) then {
	_profile set ["appScripts", _appScripts];
} else {
	_profile deleteAt "appScripts";
};

_profile = [_profile, _objects, _logic] call FUNC(enrichMobileProfileFromModules);

["AssignProfile", "Profile built", createHashMapFromArray [
	["id", _id],
	["units", _units apply {format ["%1:%2", name _x, typeOf _x]}],
	["theme", _profile getOrDefault ["theme", ""]],
	["hasLockCode", (_profile getOrDefault ["lockCode", ""]) isNotEqualTo ""],
	["primaryEmail", _profile getOrDefault ["primaryEmail", ""]],
	["aliases", _profile getOrDefault ["aliases", []]],
	["appScripts", _profile getOrDefault ["appScripts", []]],
	["files", count (_profile getOrDefault ["files", []])],
	["mails", count (_profile getOrDefault ["mails", []])],
	["hasLayout", count (_profile getOrDefault ["layout", createHashMap]) > 0],
	["hasDesktop", ("desktopContent" in (keys _profile)) || {"desktopScript" in (keys _profile)}]
]] call FUNC(debugLog);

_logic setVariable [QGVAR(isMobileProfileModule), true, true];
_logic setVariable [QGVAR(isAssignedMobileProfileModule), true, true];
_logic setVariable [QGVAR(mobileProfileId), _id, true];
_logic setVariable [QGVAR(mobileProfileConfig), _profile, true];

{
	private _assignedProfiles = _x getVariable [QGVAR(assignedMobileProfileIds), []];
	if !(_assignedProfiles isEqualType []) then {
		_assignedProfiles = [];
	};
	_assignedProfiles pushBackUnique _id;
	_x setVariable [QGVAR(assignedMobileProfileIds), _assignedProfiles, true];

	private _assignedConfigs = _x getVariable [QGVAR(assignedMobileProfileConfigs), []];
	if !(_assignedConfigs isEqualType []) then {
		_assignedConfigs = [];
	};
	private _assignedProfile = +_profile;
	_assignedProfile deleteAt "units";
	private _configIndex = _assignedConfigs findIf {
		_x isEqualType createHashMap && {toLowerANSI (_x getOrDefault ["id", ""]) isEqualTo _id}
	};
	if (_configIndex < 0) then {
		_assignedConfigs pushBack _assignedProfile;
	} else {
		_assignedConfigs set [_configIndex, _assignedProfile];
	};
	_x setVariable [QGVAR(assignedMobileProfileConfigs), _assignedConfigs, true];
} forEach _units;

[_id, _profile] call FUNC(registerMobileProfile);
[_id, _profile] remoteExecCall [QFUNC(registerMobileProfile), 0, format [QGVAR(mobileProfile_%1), _id]];

["AssignProfile", "Profile registered", createHashMapFromArray [
	["id", _id],
	["registeredProfiles", count GVAR(mobileProfiles)]
]] call FUNC(debugLog);

if (!_skipGiveDevice && {_logic getVariable [QGVAR(assignMobileProfileGiveDevice), false]}) then {
	private _itemClass = _logic getVariable [QGVAR(assignMobileProfileDevice), QGVAR(smartphone)];
	if (_itemClass isNotEqualTo "") then {
		["AssignProfile", "Giving device to synced units", createHashMapFromArray [
			["id", _id],
			["itemClass", _itemClass],
			["units", _units apply {name _x}]
		]] call FUNC(debugLog);
		{
			[_x, _itemClass] call FUNC(addMobileDeviceItemLocal);
		} forEach _units;
	};
};

true
