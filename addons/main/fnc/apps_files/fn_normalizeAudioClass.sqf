#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Normalizes an audio class field that may contain copied config syntax.
 *
 * Arguments:
 * 0: Raw audio class text <STRING>
 *
 * Return Value:
 * Audio class name <STRING>
 */

params [["_value", "", [""]]];

private _tokens = _value splitString " 	;{}=:""";
if (_tokens isEqualTo []) exitWith {""};

if (toLowerANSI (_tokens select 0) isEqualTo "class") exitWith {
	_tokens param [1, ""]
};

_tokens select 0
