#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Powers off the active computer and refreshes the display.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _computer = _display getVariable [QGVAR(computer), objNull];
[_computer, false] call FUNC(setPowerState);
_display setVariable [QGVAR(startMenuOpen), false];
["desktop"] call FUNC(renderApp);

[_display] spawn {
	params ["_display"];
	uiSleep 1.5;
	if (!isNull _display) then {
		_display closeDisplay 1;
	};
};
