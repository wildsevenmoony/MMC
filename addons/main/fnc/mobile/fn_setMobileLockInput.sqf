#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Updates the currently entered mobile lock code and its dot display.
 *
 * Arguments:
 * 0: Mobile display <DISPLAY>
 * 1: Lock code input <STRING>
 *
 * Return Value:
 * Input <STRING>
 */

params [
	["_display", displayNull, [displayNull]],
	["_input", "", [""]]
];

if (isNull _display) exitWith {""};

private _digits = toArray "0123456789";
_input = toString ((toArray _input) select {_x in _digits});
if ((count _input) > 12) then {
	_input = _input select [0, 12];
};

_display setVariable [QGVAR(mobileLockInput), _input];
_display setVariable [QGVAR(loginPassword), _input];

private _map = _display getVariable [QGVAR(mobileLockControlMap), createHashMap];
private _dots = _map getOrDefault ["dots", controlNull];
if (!isNull _dots) then {
	private _text = "<t align='center' size='1.35' shadow='0'>";
	private _count = count _input;
	if (_count == 0) then {
		_text = _text + "<t color='#FFFFFF66'>- - - -</t>";
	} else {
		private _filled = [];
		for "_i" from 1 to _count do {
			_filled pushBack "*";
		};
		_text = _text + (_filled joinString " ");
	};
	_text = _text + "</t>";
	_dots ctrlSetStructuredText parseText _text;
};

private _error = _map getOrDefault ["error", controlNull];
if (!isNull _error) then {
	_error ctrlSetStructuredText parseText "";
};

_input
