#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Disables or restores login and mobile lock controls while the hacking UI is active.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Lock controls <BOOL>
 *
 * Return Value:
 * Controls updated <BOOL>
 */

params [
	["_display", displayNull, [displayNull]],
	["_locked", true, [true]]
];

if (isNull _display) exitWith {false};

if (!_locked) exitWith {
	{
		if (_x isEqualType controlNull && {!isNull _x}) then {
			_x ctrlEnable true;
		};
	} forEach (_display getVariable [QGVAR(hackingLockedControls), []]);
	_display setVariable [QGVAR(hackingLockedControls), []];
	true
};

private _controls = [];

if (_display getVariable [QGVAR(mobileLockScreen), false]) then {
	private _map = _display getVariable [QGVAR(mobileLockControlMap), createHashMap];
	_controls append (_map getOrDefault ["buttons", []]);
	{
		private _ctrl = _map getOrDefault [_x, controlNull];
		if (!isNull _ctrl) then {
			_controls pushBack _ctrl;
		};
	} forEach ["confirm", "delete", "hack"];

	private _rotate = _display getVariable [QGVAR(mobileRotateControl), controlNull];
	if (!isNull _rotate) then {
		_controls pushBack _rotate;
	};
} else {
	{
		private _ctrl = _display displayCtrl _x;
		if (!isNull _ctrl) then {
			_controls pushBack _ctrl;
		};
	} forEach [
		IDC_MMC_LOGIN_USERNAME,
		IDC_MMC_LOGIN_PASSWORD,
		IDC_MMC_LOGIN_PASSWORD_VISIBLE,
		IDC_MMC_LOGIN_PASSWORD_TOGGLE,
		IDC_MMC_LOGIN_BUTTON,
		IDC_MMC_LOGIN_SHUTDOWN
	];

	{
		if (_x isEqualType controlNull && {!isNull _x}) then {
			_controls pushBackUnique _x;
		};
	} forEach (_display getVariable [QGVAR(hackingEntryControls), []]);
};

{
	if (_x isEqualType controlNull && {!isNull _x}) then {
		_x ctrlEnable false;
	};
} forEach _controls;

_display setVariable [QGVAR(hackingLockedControls), _controls];
true
