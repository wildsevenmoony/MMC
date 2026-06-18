#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Normalizes mission-maker text before it is rendered as structured text.
 *
 * Arguments:
 * 0: Text <STRING>
 *
 * Return Value:
 * Text with real line breaks and literal \n converted to <br/> <STRING>
 */

params [["_text", "", [""]]];

private _break = toArray "<br/>";
private _codes = toArray _text;
private _out = [];
private _i = 0;
private _count = count _codes;

while {_i < _count} do {
	private _code = _codes select _i;
	if (_code isEqualTo 13) then {
		_out append _break;
		_i = _i + 1;
		if (_i < _count && {(_codes select _i) isEqualTo 10}) then {
			_i = _i + 1;
		};
	} else {
		if (_code isEqualTo 10) then {
			_out append _break;
			_i = _i + 1;
		} else {
			if (_code isEqualTo 92 && {_i + 1 < _count && {(_codes select (_i + 1)) isEqualTo 110}}) then {
				_out append _break;
				_i = _i + 2;
			} else {
				_out pushBack _code;
				_i = _i + 1;
			};
		};
	};
};

toString _out
