#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Plays the previous or next audio file visible to the active user.
 *
 * Arguments:
 * 0: Direction <-1|1>
 */

params [["_direction", 1, [0]]];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _mediaFiles = [_computer] call FUNC(getMediaFiles);
if (_mediaFiles isEqualTo []) exitWith {
	(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText "Selected: No Audio File Selected";
	false
};

private _index = _computer getVariable [QGVAR(audioIndex), -1];
if (_index < 0) then {
	_index = 0;
} else {
	_index = _index + _direction;
	if (_index < 0) then {
		_index = (count _mediaFiles) - 1;
	};
	if (_index >= count _mediaFiles) then {
		_index = 0;
	};
};

private _file = _mediaFiles param [_index, createHashMap];
private _type = _file getOrDefault ["type", ""];
if (_type isEqualTo "audio") then {
	[] call FUNC(stopVideo);
	[_computer, _file, _index] call FUNC(playAudio);
} else {
	[_file] call FUNC(playVideo);
	_computer setVariable [QGVAR(audioIndex), _index, true];
};

(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText format ["Playing: %1", _file getOrDefault ["name", "Media"]];
true
