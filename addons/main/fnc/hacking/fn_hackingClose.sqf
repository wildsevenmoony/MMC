#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Deletes the MMC hacking overlay and, optionally, its entry button.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Clear active hacking state <BOOL, default: true>
 * 2: Clear hacking entry button <BOOL, default: false>
 *
 * Return Value:
 * None
 */

params [
	["_display", displayNull, [displayNull]],
	["_clearState", true, [true]],
	["_clearEntry", false, [true]]
];

if (isNull _display) exitWith {};

[_display, false] call FUNC(hackingSetScreenLocked);

private _deleteControls = {
	private _controls = _this;
	if (_controls isEqualType controlNull) then {
		_controls = [_controls];
	};
	if !(_controls isEqualType []) exitWith {};

	private _pending = +_controls;
	while {count _pending > 0} do {
		private _control = _pending deleteAt 0;
		if (_control isEqualType []) then {
			_pending append _control;
		} else {
			if (_control isEqualType controlNull && {!isNull _control}) then {
				ctrlDelete _control;
			};
		};
	};
};

[_display getVariable [QGVAR(hackingControls), []]] call _deleteControls;
_display setVariable [QGVAR(hackingControls), []];
[_display getVariable [QGVAR(hackingProgressControls), []]] call _deleteControls;
_display setVariable [QGVAR(hackingProgressControls), []];

if (_clearEntry) then {
	[_display getVariable [QGVAR(hackingEntryControls), []]] call _deleteControls;
	_display setVariable [QGVAR(hackingEntryControls), []];
};

if (_clearState) then {
	[player, false] call FUNC(hackingSetEffectsLocal);
	_display setVariable [QGVAR(hackingCancelled), true];
	_display setVariable [QGVAR(hackingState), createHashMap];
	_display setVariable [QGVAR(hackingBusy), false];
};
