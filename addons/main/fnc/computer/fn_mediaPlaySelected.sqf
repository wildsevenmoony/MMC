#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Plays the selected audio file in the Files app.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _data = _display getVariable [QGVAR(data), createHashMap];
private _activeUser = [_computer] call FUNC(getActiveUser);
private _files = (_data getOrDefault ["files", []]) + (_activeUser getOrDefault ["files", []]);
private _index = lbCurSel (_display displayCtrl IDC_MMC_APP_LIST);
private _file = _files param [_index, createHashMap];

if ((_file getOrDefault ["type", ""]) isNotEqualTo "audio") exitWith {false};

private _audioFiles = [_computer] call FUNC(getAudioFiles);
private _audioIndex = _audioFiles findIf {
	(_x getOrDefault ["name", ""]) isEqualTo (_file getOrDefault ["name", ""])
	&& {(_x getOrDefault ["path", ""]) isEqualTo (_file getOrDefault ["path", ""])}
};

[_computer, _file, _audioIndex] call FUNC(playAudio);
(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText format ["Playing: %1", _file getOrDefault ["name", "Audio"]];
true
