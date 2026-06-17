#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Toggles the mobile MMC display between horizontal and vertical layouts.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * New orientation <STRING>
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {GVAR(mobileOrientation)};

private _orientation = _display getVariable [QGVAR(mobileOrientation), GVAR(mobileOrientation)];
_orientation = ["vertical", "horizontal"] select (_orientation isEqualTo "vertical");
_display setVariable [QGVAR(mobileOrientation), _orientation];

private _currentApp = _display getVariable [QGVAR(currentApp), ""];
if (_currentApp isEqualTo "messages" || {(_currentApp select [0, 7]) isEqualTo "custom:"}) then {
	private _paneSelection = ["", "customApps"] select (_display getVariable [QGVAR(mobileCustomAppsOpen), false]);
	if (_display getVariable [QGVAR(mobileNavOpen), false]) then {
		_paneSelection = "nav";
	};
	_display setVariable [QGVAR(mobilePaneSelection), _paneSelection];
	if (_currentApp isEqualTo "messages") then {
		[_display] call FUNC(applyMobileDisplayLayout);
	};
	[_currentApp] call FUNC(renderApp);
} else {
	[_display] call FUNC(applyMobileDisplayLayout);
};

_orientation
