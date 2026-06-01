#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Stops media playback for the open computer.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

private _computer = _display getVariable [QGVAR(computer), objNull];
[_computer] call FUNC(stopAudio);
[] call FUNC(stopVideo);
_display setVariable [QGVAR(mediaStatusText), "Stopped"];
(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText "Stopped";
true
