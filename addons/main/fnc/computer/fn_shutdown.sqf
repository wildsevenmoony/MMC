#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Powers off the active computer and refreshes the display.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _computer = _display getVariable [QGVAR(computer), objNull];
[_computer] call FUNC(logout);
[_computer, false] call FUNC(setPowerState);
_display setVariable [QGVAR(startMenuOpen), false];
[
	_display,
	true,
	["MMC", "Saving session...", "Powering down"],
	-1
] call FUNC(setSystemOverlay);

[_display] spawn {
	params ["_display"];
	uiSleep (1.2 + random 1.2);
	if (!isNull _display) then {
		_display closeDisplay 1;
	};
};
