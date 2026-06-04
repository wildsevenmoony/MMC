#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Returns a unique IDC for controls created at runtime in the computer display.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * Dynamic IDC <NUMBER>
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {-1};

private _next = _display getVariable [QGVAR(nextDynamicIdc), 870000];
_display setVariable [QGVAR(nextDynamicIdc), _next + 1];

_next
