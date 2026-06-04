#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Logs out of the currently open MMC computer and returns to the login screen.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _data = _computer getVariable [QGVAR(data), createHashMap];
if !(_data getOrDefault ["loginRequired", true]) exitWith {false};

[_computer] call FUNC(logout);

_display setVariable [QGVAR(startMenuOpen), false];
_display setVariable [QGVAR(activeUser), createHashMap];
[_display] call FUNC(showLogin);
true
