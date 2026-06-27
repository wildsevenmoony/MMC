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

private _wasPlaying = (_computer getVariable [QGVAR(audioIndex), -1]) >= 0;
private _selectedFile = _display getVariable [QGVAR(selectedMediaFile), createHashMap];
private _index = _audioFiles findIf {
	(_x getOrDefault ["name", ""]) isEqualTo (_selectedFile getOrDefault ["name", ""])
	&& {(_x getOrDefault ["path", ""]) isEqualTo (_selectedFile getOrDefault ["path", ""])}
};
if (_index < 0) then {
	_index = _computer getVariable [QGVAR(audioIndex), -1];
};
if (_index < 0) then {
	_index = 0;
};

_index = _index + _direction;
if (_index < 0) then {
	_index = (count _audioFiles) - 1;
};
if (_index >= count _audioFiles) then {
	_index = 0;
};

private _file = _audioFiles param [_index, createHashMap];
_display setVariable [QGVAR(selectedMediaFile), _file];
if ((_display getVariable [QGVAR(currentApp), ""]) isEqualTo "files") then {
	_display setVariable [QGVAR(selectedFileIndex), _index];
};

private _started = false;
if (_wasPlaying) then {
	_started = [_computer, _file, _index] call FUNC(playAudio);
};

private _statusText = if (_wasPlaying) then {
	[format ["Could not play: %1", [_file] call FUNC(getFileDisplayName)], format ["Playing: %1", [_file] call FUNC(getFileDisplayName)]] select _started
} else {
	format ["Selected: %1", [_file] call FUNC(getFileDisplayName)]
};
_display setVariable [QGVAR(mediaStatusText), _statusText];
(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText _statusText;
["select", [controlNull, -1]] call FUNC(renderApp);
_wasPlaying && _started
