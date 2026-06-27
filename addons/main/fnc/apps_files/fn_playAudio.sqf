#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Starts an audio file from the computer object on all clients.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: Audio file data <HASHMAP>
 * 2: Audio file index <NUMBER, default: -1>
 *
 * Return Value:
 * Started <BOOL>
 */

params [
	["_object", objNull, [objNull]],
	["_file", createHashMap, [createHashMap]],
	["_index", -1, [0]]
];

if (isNull _object) exitWith {false};

private _soundClass = [_file getOrDefault ["soundClass", ""]] call FUNC(normalizeAudioClass);
private _path = _file getOrDefault ["path", ""];
private _name = [_file] call FUNC(getFileDisplayName);

private _cleanPath = {
	params [["_value", "", [""]]];
	while {(_value select [0, 1]) in ["\", "/"]} do {
		_value = _value select [1];
	};
	_value
};

private _baseName = {
	params [["_value", "", [""]]];
	private _parts = _value splitString "\/";
	private _base = _parts param [(count _parts) - 1, _value];
	private _extensionParts = _base splitString ".";
	if ((count _extensionParts) > 1) then {
		_base = (_extensionParts select [0, (count _extensionParts) - 1]) joinString ".";
	};
	_base
};

private _classKind = {
	params [["_className", "", [""]]];
	if (_className isEqualTo "") exitWith {""};
	if (isClass (configFile >> "CfgVehicles" >> _className)) exitWith {"CfgVehicles"};
	if (isClass (configFile >> "CfgSFX" >> _className)) exitWith {"CfgSFX"};
	if (isClass (missionConfigFile >> "CfgSFX" >> _className)) exitWith {"CfgSFX"};
	if (isClass (configFile >> "CfgSounds" >> _className)) exitWith {"CfgSounds"};
	if (isClass (missionConfigFile >> "CfgSounds" >> _className)) exitWith {"CfgSounds"};
	""
};

private _candidates = [];
{
	if (_x isNotEqualTo "") then {
		_candidates pushBackUnique _x;
		_candidates pushBackUnique ([_x] call _baseName);
	};
} forEach [_soundClass, _path, _name];
private _candidateKeys = _candidates apply {toLowerANSI _x};

private _resolvedClass = "";
private _resolvedKind = "";
{
	_resolvedKind = [_x] call _classKind;
	if (_resolvedKind isNotEqualTo "") exitWith {
		_resolvedClass = _x;
	};
} forEach _candidates;

if (_resolvedClass isEqualTo "") then {
	private _configRoots = [
		[missionConfigFile >> "CfgSFX", "CfgSFX"],
		[configFile >> "CfgSFX", "CfgSFX"],
		[configFile >> "CfgVehicles", "CfgVehicles"],
		[missionConfigFile >> "CfgSounds", "CfgSounds"],
		[configFile >> "CfgSounds", "CfgSounds"]
	];

	{
		_x params ["_root", "_kind"];
		{
			private _cfg = _x;
			private _names = [
				configName _cfg,
				getText (_cfg >> "name"),
				getText (_cfg >> "displayName")
			];
			if ((_names apply {toLowerANSI ([_x] call _baseName)}) findIf {_x in _candidateKeys} >= 0) exitWith {
				_resolvedClass = configName _cfg;
				_resolvedKind = _kind;
			};
		} forEach (configProperties [_root, "isClass _x", true]);
		if (_resolvedClass isNotEqualTo "") exitWith {};
	} forEach _configRoots;
};

private _directPath = [_path] call _cleanPath;
private _hasDirectPath = _directPath isNotEqualTo "" && {fileExists _directPath};
if (_resolvedClass isEqualTo "" && {!_hasDirectPath}) exitWith {
	private _musicClass = _candidates findIf {
		isClass (configFile >> "CfgMusic" >> _x)
		|| {isClass (missionConfigFile >> "CfgMusic" >> _x)}
	};
	["Files", "Audio playback failed because no playable sound class was configured", createHashMapFromArray [
		["object", _object],
		["name", _name],
		["path", _path],
		["directPath", _directPath],
		["soundClass", _soundClass],
		["candidates", _candidates],
		["hasDirectPath", _hasDirectPath],
		["cfgMusicCandidate", _musicClass],
		["cfgMusicUnsupported", _musicClass >= 0]
	]] call FUNC(debugLog);
	false
};

_object setVariable [QGVAR(audioIndex), _index, true];
private _anchor = _object;
if (_object isKindOf "Logic" && {!isNull player}) then {
	_anchor = player;
};
[_object, _resolvedClass, _name, _directPath, _anchor] remoteExecCall [QFUNC(playAudioLocal), 0];
true
