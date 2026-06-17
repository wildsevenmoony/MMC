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

if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
	private _focusSink = _display getVariable [QGVAR(mobileFocusSinkControl), controlNull];
	if (isNull _focusSink) then {
		_focusSink = _display ctrlCreate ["RscEdit", [_display] call FUNC(nextDynamicIdc)];
		_focusSink ctrlSetPosition [-10, -10, 0.001, 0.001];
		_focusSink ctrlSetText "";
		_focusSink ctrlSetTextColor [0, 0, 0, 0];
		_focusSink ctrlSetBackgroundColor [0, 0, 0, 0];
		_focusSink ctrlCommit 0;
		_display setVariable [QGVAR(mobileFocusSinkControl), _focusSink];
	};
	ctrlSetFocus _focusSink;
};

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

if (_clearLaunchers) then {
	[_display getVariable [QGVAR(customAppControls), []]] call _deleteControls;
	_display setVariable [QGVAR(customAppControls), []];
};

if (_clearActions) then {
	private _messengerInput = _display getVariable [QGVAR(messengerInputControl), controlNull];
	private _messengerSelectedId = _display getVariable [QGVAR(messengerSelectedId), ""];
	if (!isNull _messengerInput && {_messengerSelectedId isNotEqualTo ""}) then {
		private _drafts = _display getVariable [QGVAR(messengerDrafts), createHashMap];
		if !(_drafts isEqualType createHashMap) then {
			_drafts = createHashMap;
		};
		_drafts set [_messengerSelectedId, ctrlText _messengerInput];
		_display setVariable [QGVAR(messengerDrafts), _drafts];
	};

	[_display getVariable [QGVAR(customActionControls), []]] call _deleteControls;
	_display setVariable [QGVAR(customActionControls), []];
	[_display getVariable [QGVAR(messengerDynamicControls), []]] call _deleteControls;
	_display setVariable [QGVAR(messengerDynamicControls), []];
	[
		_display getVariable [QGVAR(messengerInputBackgroundControl), controlNull],
		_display getVariable [QGVAR(messengerInputGroupControl), controlNull],
		_display getVariable [QGVAR(messengerInputControl), controlNull],
		_display getVariable [QGVAR(messengerSendControl), controlNull],
		_display getVariable [QGVAR(messengerSendHotspotControl), controlNull],
		_display getVariable [QGVAR(messengerSendFrameControl), controlNull]
	] call _deleteControls;
	_display setVariable [QGVAR(messengerInputBackgroundControl), controlNull];
	_display setVariable [QGVAR(messengerInputGroupControl), controlNull];
	_display setVariable [QGVAR(messengerInputControl), controlNull];
	_display setVariable [QGVAR(messengerSendControl), controlNull];
	_display setVariable [QGVAR(messengerSendHotspotControl), controlNull];
	_display setVariable [QGVAR(messengerSendFrameControl), controlNull];
	{
		if (
			(_x getVariable [QGVAR(messengerInputControlsGeneration), -1]) >= 0
			|| {_x getVariable [QGVAR(messengerDynamicControl), false]}
		) then {
			ctrlDelete _x;
		};
	} forEach (allControls _display);
};

if (_clearActions) then {
	_display setVariable [QGVAR(messengerInputControlsGeneration), (_display getVariable [QGVAR(messengerInputControlsGeneration), 0]) + 1];
};
