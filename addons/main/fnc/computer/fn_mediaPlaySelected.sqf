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

if !(_type in ["audio", "video"]) exitWith {
	(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText "Selected: No Audio File Selected";
	false
};

private _mediaFiles = [_computer] call FUNC(getMediaFiles);
private _mediaIndex = _mediaFiles findIf {
	(_x getOrDefault ["name", ""]) isEqualTo (_file getOrDefault ["name", ""])
	&& {(_x getOrDefault ["path", ""]) isEqualTo (_file getOrDefault ["path", ""])}
};

_computer setVariable [QGVAR(audioIndex), _mediaIndex, true];

if (_type isEqualTo "audio") then {
	[] call FUNC(stopVideo);
	[_computer, _file, _mediaIndex] call FUNC(playAudio);
} else {
	[_file] call FUNC(playVideo);
};

(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText format ["Playing: %1", _file getOrDefault ["name", "Media"]];
true
