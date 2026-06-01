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
private _audioFiles = [_computer] call FUNC(getAudioFiles);
if (_audioFiles isEqualTo []) exitWith {
	_display setVariable [QGVAR(mediaStatusText), "Selected: No Audio File Selected"];
	(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText (_display getVariable [QGVAR(mediaStatusText), "Selected: No Audio File Selected"]);
	false
};

private _index = _computer getVariable [QGVAR(audioIndex), -1];
if (_index < 0) then {
	_index = 0;
} else {
	_index = _index + _direction;
	if (_index < 0) then {
		_index = (count _audioFiles) - 1;
	};
	if (_index >= count _audioFiles) then {
		_index = 0;
	};
};

private _file = _audioFiles param [_index, createHashMap];
[_computer, _file, _index] call FUNC(playAudio);

private _statusText = format ["Playing: %1", _file getOrDefault ["name", "Media"]];
_display setVariable [QGVAR(mediaStatusText), _statusText];
(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText _statusText;
true
