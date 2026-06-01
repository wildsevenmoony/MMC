#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Plays a video in the computer content area.
 *
 * Arguments:
 * 0: Video file data <HASHMAP>
 *
 * Return Value:
 * Started <BOOL>
 */

params [["_file", createHashMap, [createHashMap]]];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

private _videoPath = _file getOrDefault ["videoPath", ""];
if (_videoPath isEqualTo "") exitWith {false};

private _computer = _display getVariable [QGVAR(computer), objNull];
[_computer] call FUNC(stopAudio);

missionNamespace setVariable [QGVAR(videoSkip), false];
[
	_videoPath,
	[safeZoneX + 0.485, safeZoneY + 0.19, safeZoneW - 0.72, safeZoneH - 0.455],
	[1, 1, 1, 1],
	QGVAR(videoSkip),
	[0, 0, 0, 1],
	true
] spawn BIS_fnc_playVideo;

true
