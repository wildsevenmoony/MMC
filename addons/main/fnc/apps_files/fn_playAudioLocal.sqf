#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Starts a local looping audio source on a computer object.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: Audio source class <STRING>
 * 2: Display name <STRING>
 * 3: Direct audio path fallback <STRING, default: "">
 * 4: Playback anchor object <OBJECT, default: objNull>
 *
 * Return Value:
 * Started <BOOL>
 */

params [
	["_object", objNull, [objNull]],
	["_soundClass", "", [""]],
	["_name", "Audio", [""]],
	["_path", "", [""]],
	["_anchor", objNull, [objNull]]
];

if (isNull _object || {_soundClass isEqualTo "" && {_path isEqualTo ""}}) exitWith {false};

[_object] call FUNC(stopAudioLocal);

private _playObject = _object;
if (isNull _anchor) then {
	if (_object isKindOf "Logic" && {!isNull player}) then {
		_playObject = player;
	};
} else {
	_playObject = _anchor;
};
private _playPosATL = getPosATLVisual _playObject;
private _playPosASL = getPosASLVisual _playObject;
private _source = objNull;
private _mode = "";

if (isClass (configFile >> "CfgVehicles" >> _soundClass)) then {
	_source = createSoundSource [_soundClass, _playPosATL, [], 0];
	_mode = "CfgVehicles";
};

if (isNull _source && {
	isClass (configFile >> "CfgSFX" >> _soundClass)
	|| {isClass (missionConfigFile >> "CfgSFX" >> _soundClass)}
}) then {
	_source = createTrigger ["EmptyDetector", _playPosATL, false];
	_source setSoundEffect ["", "", "", _soundClass];
	_source setTriggerArea [0, 0, 0, false];
	_source setTriggerActivation ["ANYPLAYER", "PRESENT", true];
	_source setTriggerStatements ["true", "", ""];
	_mode = "CfgSFX";
};

if (isNull _source && {
	isClass (configFile >> "CfgSounds" >> _soundClass)
	|| {isClass (missionConfigFile >> "CfgSounds" >> _soundClass)}
}) exitWith {
	_playObject say3D _soundClass;
	_object setVariable [QGVAR(audioSource), objNull];
	_object setVariable [QGVAR(audioName), _name];
	["Files", "Started one-shot CfgSounds audio playback", createHashMapFromArray [
		["object", _object],
		["soundClass", _soundClass],
		["name", _name]
	]] call FUNC(debugLog);
	true
};

if (isNull _source && {_path isNotEqualTo ""} && {fileExists _path}) exitWith {
	private _soundId = playSound3D [_path, _playObject, false, _playPosASL, 1, 1, 50];
	_object setVariable [QGVAR(audioSource), objNull];
	_object setVariable [QGVAR(audioSoundId), _soundId];
	_object setVariable [QGVAR(audioName), _name];
	_object setVariable [QGVAR(audioMusicPlaying), false];
	["Files", "Started one-shot direct audio path playback", createHashMapFromArray [
		["object", _object],
		["path", _path],
		["name", _name]
	]] call FUNC(debugLog);
	true
};

if (isNull _source) exitWith {
	["Files", "Local audio playback failed to find a playable class or file path", createHashMapFromArray [
		["object", _object],
		["soundClass", _soundClass],
		["name", _name],
		["path", _path],
		["hasCfgVehiclesClass", isClass (configFile >> "CfgVehicles" >> _soundClass)],
		["hasCfgSFXClass", isClass (configFile >> "CfgSFX" >> _soundClass)],
		["hasMissionCfgSFXClass", isClass (missionConfigFile >> "CfgSFX" >> _soundClass)],
		["hasCfgSoundsClass", isClass (configFile >> "CfgSounds" >> _soundClass)],
		["hasMissionCfgSoundsClass", isClass (missionConfigFile >> "CfgSounds" >> _soundClass)],
		["hasCfgMusicClass", isClass (configFile >> "CfgMusic" >> _soundClass)],
		["hasMissionCfgMusicClass", isClass (missionConfigFile >> "CfgMusic" >> _soundClass)],
		["cfgMusicUnsupported", isClass (configFile >> "CfgMusic" >> _soundClass) || {isClass (missionConfigFile >> "CfgMusic" >> _soundClass)}]
	]] call FUNC(debugLog);
	false
};

_source attachTo [_playObject, [0, 0, 0]];
_object setVariable [QGVAR(audioSource), _source];
_object setVariable [QGVAR(audioSoundId), -1];
_object setVariable [QGVAR(audioName), _name];
_object setVariable [QGVAR(audioMusicPlaying), false];
["Files", "Started local audio playback", createHashMapFromArray [
	["object", _object],
	["anchor", _playObject],
	["soundClass", _soundClass],
	["name", _name],
	["mode", _mode]
]] call FUNC(debugLog);
true
