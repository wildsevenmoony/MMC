#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Calculates Fallout-style character likeness between two words.
 *
 * Arguments:
 * 0: Guess word <STRING>
 * 1: Target word <STRING>
 *
 * Return Value:
 * Matching positions <NUMBER>
 */

params [
	["_guess", "", [""]],
	["_target", "", [""]]
];

private _guessChars = toArray _guess;
private _targetChars = toArray _target;
private _limit = (count _guessChars) min (count _targetChars);
private _matches = 0;

for "_i" from 0 to (_limit - 1) do {
	if ((_guessChars select _i) == (_targetChars select _i)) then {
		_matches = _matches + 1;
	};
};

_matches
