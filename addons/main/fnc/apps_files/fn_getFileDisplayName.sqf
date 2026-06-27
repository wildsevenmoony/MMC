#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Returns the best display name for a file entry.
 *
 * Arguments:
 * 0: File data <HASHMAP>
 *
 * Return Value:
 * Display name <STRING>
 */

params [["_file", createHashMap, [createHashMap]]];

private _name = _file getOrDefault ["name", "Untitled"];
if ((_file getOrDefault ["type", ""]) isNotEqualTo "audio") exitWith {_name};

private _soundClass = [_file getOrDefault ["soundClass", ""]] call FUNC(normalizeAudioClass);
if (_soundClass isEqualTo "") exitWith {_name};

private _configs = [
	missionConfigFile >> "CfgSFX" >> _soundClass,
	configFile >> "CfgSFX" >> _soundClass,
	configFile >> "CfgVehicles" >> _soundClass,
	missionConfigFile >> "CfgSounds" >> _soundClass,
	configFile >> "CfgSounds" >> _soundClass
];

private _index = _configs findIf {isClass _x && {getText (_x >> "name") isNotEqualTo ""}};
if (_index < 0) exitWith {_name};

getText ((_configs select _index) >> "name")
