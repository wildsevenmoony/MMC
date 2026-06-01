#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Powers off the active computer and refreshes the display.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _computer = _display getVariable [QGVAR(computer), objNull];
[_computer, "power_down"] call FUNC(setScreenState);
[_computer] call FUNC(logout);
[_computer] call FUNC(stopAudio);
_display setVariable [QGVAR(startMenuOpen), false];
[
	_display,
	true,
	["MMC", "Saving session...", "Powering down"],
	-1
] call FUNC(setSystemOverlay);

[_display] spawn {
	params ["_display"];
	private _computer = _display getVariable [QGVAR(computer), objNull];
	uiSleep (1.2 + random 1.2);
	[_computer, false] call MMC_fnc_setPowerState;
	if (!isNull _display) then {
		_display closeDisplay 1;
	};
};
