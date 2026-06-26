#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Handles keyboard input while the MMC mobile lock screen is active.
 *
 * Arguments:
 * 0: Mobile display <DISPLAY>
 * 1: Key code <NUMBER>
 *
 * Return Value:
 * Key handled <BOOL>
 */

params [
	["_display", displayNull, [displayNull]],
	["_key", -1, [0]]
];

if (isNull _display || {!(_display getVariable [QGVAR(mobileLockScreen), false])}) exitWith {false};

private _digit = "";
switch (_key) do {
	case 2: {_digit = "1"};
	case 3: {_digit = "2"};
	case 4: {_digit = "3"};
	case 5: {_digit = "4"};
	case 6: {_digit = "5"};
	case 7: {_digit = "6"};
	case 8: {_digit = "7"};
	case 9: {_digit = "8"};
	case 10: {_digit = "9"};
	case 11: {_digit = "0"};
	case 79: {_digit = "1"};
	case 80: {_digit = "2"};
	case 81: {_digit = "3"};
	case 75: {_digit = "4"};
	case 76: {_digit = "5"};
	case 77: {_digit = "6"};
	case 71: {_digit = "7"};
	case 72: {_digit = "8"};
	case 73: {_digit = "9"};
	case 82: {_digit = "0"};
	case 28: {
		call FUNC(unlockMobile);
		true
	};
	case 156: {
		call FUNC(unlockMobile);
		true
	};
	case 14: {
		private _input = _display getVariable [QGVAR(mobileLockInput), ""];
		if (_input isNotEqualTo "") then {
			[_display, _input select [0, (count _input - 1) max 0]] call FUNC(setMobileLockInput);
		};
		true
	};
	default {false};
};

if (_digit isEqualTo "") exitWith {false};

private _input = _display getVariable [QGVAR(mobileLockInput), ""];
[_display, _input + _digit] call FUNC(setMobileLockInput);
true
