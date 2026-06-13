#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Cleans up the MMC display and optionally logs out the current computer.
 */

params [
	["_display", displayNull, [displayNull]],
	["_exitCode", 0, [0]]
];

if (!isNull _display) then {
	[_display, true, true] call FUNC(clearCustomControls);
};

if (!isNull _display && {GVAR(logoutOnClose)}) then {
	private _computer = _display getVariable [QGVAR(computer), objNull];
	private _data = _computer getVariable [QGVAR(data), createHashMap];
	private _loginRequired = _data getOrDefault ["loginRequired", true];
	if (_loginRequired) then {
		[_computer] call FUNC(logout);
	} else {
		[_computer] call FUNC(ensureAutoLoginUser);
	};
	if (
		!isNull _computer
		&& {alive _computer}
		&& {!(_computer getVariable [QGVAR(destroyed), false])}
		&& {_computer getVariable [QGVAR(poweredOn), true]}
		&& {!(_computer getVariable [QGVAR(booting), false])}
	) then {
		[_computer, ["desktop", "login"] select (count ([_computer] call FUNC(getActiveUser)) == 0)] call FUNC(setScreenState);
	};
};

if (!isNull _display) then {
	private _computer = _display getVariable [QGVAR(computer), objNull];
	if (!isNull _computer && {(_computer getVariable [QGVAR(inUseBy), ""]) isEqualTo getPlayerUID player}) then {
		_computer setVariable [QGVAR(inUseBy), "", true];
	};
};

uiNamespace setVariable [QGVAR(display), displayNull];
