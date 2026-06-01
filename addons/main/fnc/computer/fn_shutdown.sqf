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
[
	_display,
	true,
	"<t align='center' size='2.4'><br/><br/><br/><br/>MMC</t><br/><t align='center' size='1.1'>Saving session...</t><br/><t align='center' size='0.9'>Powering down</t>",
	-1
] call FUNC(setSystemOverlay);

[_display] spawn {
	params ["_display"];
	uiSleep 1.8;
	if (!isNull _display) then {
		_display closeDisplay 1;
	};
};
