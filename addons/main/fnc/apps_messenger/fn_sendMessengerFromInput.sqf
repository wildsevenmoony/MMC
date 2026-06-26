#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Sends the current Messenger input field to the selected contact.
 *
 * Arguments:
 * 0: Computer display <DISPLAY>
 * 1: Input control <CONTROL>
 *
 * Return Value:
 * Sent request queued <BOOL>
 */

params [
	["_display", displayNull, [displayNull]],
	["_input", controlNull, [controlNull]]
];

if (isNull _display) exitWith {false};
if (isNull _input) then {
	_input = _display getVariable [QGVAR(messengerInputControl), controlNull];
};
private _computer = _display getVariable [QGVAR(computer), objNull];
private _own = [_computer] call FUNC(getMessengerIdentity);
private _targets = [_computer] call FUNC(getMessengerDevices);
private _targetId = _display getVariable [QGVAR(messengerSelectedId), ""];
if (isNull _input) exitWith {
	["Messenger", "Send rejected", createHashMapFromArray [
		["reason", "missing input"],
		["targetId", _targetId]
	]] call FUNC(debugLog);
	false
};

private _body = ctrlText _input;
if (([_body] call CBA_fnc_trim) isEqualTo "") then {
	private _fallbackInputs = (allControls _display) select {
		_x getVariable [QGVAR(messengerInputField), false]
		&& {
			(_x getVariable [QGVAR(messengerInputSelectedId), _targetId]) isEqualTo _targetId
			&& {([ctrlText _x] call CBA_fnc_trim) isNotEqualTo ""}
		}
	};
	if (_fallbackInputs isNotEqualTo []) then {
		private _fallbackInput = _fallbackInputs select 0;
		["Messenger", "Recovered non-empty input control", createHashMapFromArray [
			["targetId", _targetId],
			["bodyLength", count ctrlText _fallbackInput],
			["candidateCount", count _fallbackInputs]
		]] call FUNC(debugLog);
		_input = _fallbackInput;
		_body = ctrlText _input;
	};
};
if (([_body] call CBA_fnc_trim) isEqualTo "") exitWith {
	["Messenger", "Send rejected", createHashMapFromArray [
		["reason", "empty body"],
		["targetId", _targetId]
	]] call FUNC(debugLog);
	false
};

private _targetIndex = _targets findIf {(_x getOrDefault ["id", ""]) isEqualTo _targetId};
if (_targetIndex < 0) exitWith {
	["Messenger", "Send rejected", createHashMapFromArray [
		["reason", "target not found"],
		["targetId", _targetId],
		["targetCount", count _targets]
	]] call FUNC(debugLog);
	false
};

private _target = _targets select _targetIndex;
private _lastSend = _display getVariable [QGVAR(messengerSendLast), -1];
if (diag_tickTime - _lastSend < 0.35) exitWith {
	["Messenger", "Send rejected", createHashMapFromArray [
		["reason", "debounce"],
		["elapsed", diag_tickTime - _lastSend]
	]] call FUNC(debugLog);
	false
};
_display setVariable [QGVAR(messengerSendLast), diag_tickTime];

private _drafts = _display getVariable [QGVAR(messengerDrafts), createHashMap];
if (_drafts isEqualType createHashMap) then {
	_drafts set [_targetId, ""];
	_display setVariable [QGVAR(messengerDrafts), _drafts];
};

_display setVariable [QGVAR(messengerSkipDraftSave), true];
_display setVariable [QGVAR(messengerForceScrollBottom), true];
_display setVariable [QGVAR(messengerKeepSelection), true];
_input ctrlSetText "";
{
	if (
		_x getVariable [QGVAR(messengerInputField), false]
		&& {(_x getVariable [QGVAR(messengerInputSelectedId), _targetId]) isEqualTo _targetId}
	) then {
		_x ctrlSetText "";
	};
} forEach (allControls _display);

[
	_own getOrDefault ["id", ""],
	_own getOrDefault ["name", "Unknown"],
	_target getOrDefault ["id", ""],
	_target getOrDefault ["name", "Unknown"],
	_body,
	_own,
	_target
] call FUNC(sendMessengerMessage);

["Messenger", "Send queued", createHashMapFromArray [
	["from", _own getOrDefault ["name", "Unknown"]],
	["to", _target getOrDefault ["name", "Unknown"]],
	["bodyLength", count _body]
]] call FUNC(debugLog);

["messages"] call FUNC(renderApp);
private _newInput = _display getVariable [QGVAR(messengerInputControl), controlNull];
if (!isNull _newInput) then {
	ctrlSetFocus _newInput;
};

true
