#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Applies local scripted app content from matching mobile profiles.
 *
 * Arguments:
 * 0: Mobile computer object <OBJECT>
 * 1: Player <OBJECT>
 * 2: Matching profiles <ARRAY>
 *
 * Return Value:
 * Applied <BOOL>
 */

params [
	["_device", objNull, [objNull]],
	["_player", player, [objNull]],
	["_profiles", [], [[]]]
];

if (isNull _device) exitWith {false};

["MobileProfile", "Applying local mobile profile apps", createHashMapFromArray [
	["device", _device],
	["profiles", _profiles apply {
		if (_x isEqualType createHashMap) then {
			createHashMapFromArray [
				["id", _x getOrDefault ["id", ""]],
				["apps", count (_x getOrDefault ["apps", []])],
				["appScripts", _x getOrDefault ["appScripts", []]]
			]
		} else {
			str _x
		}
	}]
]] call FUNC(debugLog);

private _asArray = {
	params ["_value"];
	if (isNil "_value") exitWith {[]};
	if (_value isEqualType []) exitWith {_value};
	if (_value isEqualType "") exitWith {[_value]};
	[_value]
};

{
	[_device, _x] call FUNC(removeApp);
} forEach (_device getVariable [QGVAR(mobileProfileAppIds), []]);

private _appIds = [];
{
	private _profile = _x;
	if (_profile isEqualType createHashMap) then {
		{
			private _app = if (_x isEqualType createHashMap) then {_x} else {createHashMapFromArray _x};
			private _id = _app getOrDefault ["id", ""];
			if (_id isNotEqualTo "") then {
				[
					_device,
					_id,
					_app getOrDefault ["label", _id],
					_app getOrDefault ["content", ""],
					_app getOrDefault ["actions", []],
					_app getOrDefault ["extra", createHashMap]
				] call FUNC(addApp);
				_appIds pushBackUnique (toLowerANSI _id);
				["MobileProfile", "Added inline mobile profile app", createHashMapFromArray [
					["profileId", _profile getOrDefault ["id", ""]],
					["appId", _id],
					["label", _app getOrDefault ["label", _id]]
				]] call FUNC(debugLog);
			};
		} forEach (_profile getOrDefault ["apps", []]);

		{
			private _script = [_x] call CBA_fnc_trim;
			if (_script isNotEqualTo "" && {fileExists _script}) then {
				private _beforeApps = (_device getVariable [QGVAR(customApps), []]) apply {toLowerANSI (_x getOrDefault ["id", ""])};
				private _result = [_device, _player, _profile] call (compile preprocessFileLineNumbers _script);
				["MobileProfile", "Executed mobile profile app script", createHashMapFromArray [
					["profileId", _profile getOrDefault ["id", ""]],
					["script", _script],
					["result", _result]
				]] call FUNC(debugLog);
				if (_result isEqualType "") then {
					_appIds pushBackUnique (toLowerANSI _result);
				} else {
					if (_result isEqualType []) then {
						{
							if (_x isEqualType "") then {
								_appIds pushBackUnique (toLowerANSI _x);
							};
						} forEach _result;
					};
				};
				{
					private _id = toLowerANSI (_x getOrDefault ["id", ""]);
					if (_id isNotEqualTo "" && {!(_id in _beforeApps)}) then {
						_appIds pushBackUnique _id;
					};
				} forEach (_device getVariable [QGVAR(customApps), []]);
			} else {
				diag_log format ["[MMC] Mobile profile app script not found: %1", _script];
				["MobileProfile", "Mobile profile app script not found", createHashMapFromArray [
					["profileId", _profile getOrDefault ["id", ""]],
					["script", _script]
				]] call FUNC(debugLog);
			};
		} forEach ([_profile getOrDefault ["appScripts", []]] call _asArray);
	};
} forEach _profiles;

_device setVariable [QGVAR(mobileProfileAppIds), _appIds];
["MobileProfile", "Applied local mobile profile apps result", createHashMapFromArray [
	["device", _device],
	["appIds", _appIds],
	["customApps", (_device getVariable [QGVAR(customApps), []]) apply {_x getOrDefault ["id", ""]}]
]] call FUNC(debugLog);
true
