#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Deletes dynamic scripted app buttons and action controls from the display.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Also clear launcher buttons <BOOL, default: true>
 * 2: Also clear app action buttons <BOOL, default: true>
 *
 * Return Value:
 * None
 */

params [
	["_display", displayNull, [displayNull]],
	["_clearLaunchers", true, [true]],
	["_clearActions", true, [true]]
];

if (isNull _display) exitWith {};

if (_clearActions) then {
	{
		if (_x isEqualType []) then {
			private _cleanup = _x param [0, {}, [{}]];
			private _args = _x param [1, []];
			[_display, _args] call _cleanup;
		} else {
			if (_x isEqualType {}) then {
				[_display, []] call _x;
			};
		};
	} forEach (_display getVariable [QGVAR(appCleanupHandlers), []]);
	_display setVariable [QGVAR(appCleanupHandlers), []];
};

private _deleteControls = {
	params ["_controls"];
	{
		if (!isNull _x) then {
			ctrlDelete _x;
		};
	} forEach _controls;
};

if (_clearLaunchers) then {
	[_display getVariable [QGVAR(customAppControls), []]] call _deleteControls;
	_display setVariable [QGVAR(customAppControls), []];
};

if (_clearActions) then {
	[_display getVariable [QGVAR(customActionControls), []]] call _deleteControls;
	_display setVariable [QGVAR(customActionControls), []];
};
