#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Changes the text of an app builder control by control handle or value id.
 *
 * Arguments:
 * 0: Control or value id <CONTROL or STRING>
 * 1: Text <STRING>
 * 2: Structured text <BOOL, default: false>
 *
 * Return Value:
 * Changed <BOOL>
 */

params [
	["_target", controlNull, [controlNull, ""]],
	["_text", "", [""]],
	["_structured", false, [false]]
];

private _control = _target;
if (_target isEqualType "") then {
	private _display = uiNamespace getVariable [QGVAR(display), displayNull];
	if (isNull _display) exitWith {false};

	private _map = _display getVariable [QGVAR(appControlMap), createHashMap];
	_control = _map getOrDefault [toLowerANSI _target, controlNull];
};

if (isNull _control) exitWith {false};

if (_structured) then {
	_control ctrlSetStructuredText parseText ([_text] call FUNC(normalizeStructuredText));
} else {
	_control ctrlSetText _text;
};

true
