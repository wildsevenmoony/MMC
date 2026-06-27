#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Plays the selected audio file in the Files app.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _file = _display getVariable [QGVAR(selectedMediaFile), createHashMap];
private _type = _file getOrDefault ["type", ""];

if (_type isNotEqualTo "audio") exitWith {
	_display setVariable [QGVAR(mediaStatusText), "Selected: No Audio File Selected"];
	(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText (_display getVariable [QGVAR(mediaStatusText), "Selected: No Audio File Selected"]);
	false
};

private _audioFiles = [_computer] call FUNC(getAudioFiles);
private _audioIndex = _audioFiles findIf {
	(_x getOrDefault ["name", ""]) isEqualTo (_file getOrDefault ["name", ""])
	&& {(_x getOrDefault ["path", ""]) isEqualTo (_file getOrDefault ["path", ""])}
};

private _started = [_computer, _file, _audioIndex] call FUNC(playAudio);

private _displayName = [_file] call FUNC(getFileDisplayName);
private _statusText = [format ["Could not play: %1", _displayName], format ["Playing: %1", _displayName]] select _started;
_display setVariable [QGVAR(mediaStatusText), _statusText];
(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText _statusText;
_started
