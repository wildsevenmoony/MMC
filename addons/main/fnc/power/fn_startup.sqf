#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Powers on the active computer and refreshes the display.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _computer = _display getVariable [QGVAR(computer), objNull];
[_computer, false] call FUNC(startComputer);
