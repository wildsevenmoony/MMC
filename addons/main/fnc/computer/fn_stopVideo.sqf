#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Stops video playback started by the MMC media player.
 *
 * Return Value:
 * Stopped <BOOL>
 */

missionNamespace setVariable [QGVAR(videoSkip), true];
[""] call BIS_fnc_playVideo;
missionNamespace setVariable [QGVAR(videoSkip), nil];
true
