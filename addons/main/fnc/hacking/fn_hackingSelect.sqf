#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Handles a word selection inside the MMC hacking puzzle.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Selected word <STRING>
 *
 * Return Value:
 * Selection handled <BOOL>
 */

params [
	["_display", displayNull, [displayNull]],
	["_word", "", [""]]
];

if (isNull _display || {_word isEqualTo ""}) exitWith {false};

private _state = _display getVariable [QGVAR(hackingState), createHashMap];
if (count _state == 0 || {_state getOrDefault ["lockedOut", false]}) exitWith {false};

private _target = _state getOrDefault ["targetWord", ""];
if (_word isEqualTo _target) exitWith {
	[_display, true] call FUNC(hackingFinish);
	true
};

private _likeness = [_word, _target] call FUNC(hackingLikeness);
private _history = _state getOrDefault ["history", []];
_history pushBack [_word, _likeness];
_state set ["history", _history];
_state set ["attemptsLeft", (_state getOrDefault ["attemptsLeft", 1]) - 1];

if ((_state getOrDefault ["attemptsLeft", 0]) <= 0) then {
	_state set ["lockedOut", true];
	["Hacking", "Hacking attempt failed", createHashMapFromArray [
		["mode", _state getOrDefault ["mode", ""]],
		["target", _state getOrDefault ["targetLabel", ""]]
	]] call FUNC(debugLog);
};

_display setVariable [QGVAR(hackingState), _state];
[_display] call FUNC(hackingRender);
true
