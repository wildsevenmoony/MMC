#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Parses app builder colors from RGBA arrays or hex strings.
 *
 * Arguments:
 * 0: Color <ARRAY or STRING>
 * 1: Fallback color <ARRAY>
 * 2: Alpha override <NUMBER, default: -1>
 *
 * Return Value:
 * RGBA color <ARRAY>
 */

params [
	["_color", [1, 1, 1, 1], ["", []]],
	["_fallback", [1, 1, 1, 1], [[]]],
	["_alpha", -1, [0]]
];

if (_color isEqualType []) exitWith {
	private _out = +_color;
	if ((count _out) == 3) then {
		_out pushBack 1;
	};
	if ((count _out) != 4) exitWith {_fallback};
	if (_alpha >= 0) then {
		_out set [3, _alpha];
	};
	_out
};

private _text = toUpperANSI (trim _color);
if (_text isEqualTo "") exitWith {_fallback};
if ((_text select [0, 1]) isEqualTo "#") then {
	_text = _text select [1];
};
if ((_text select [0, 2]) isEqualTo "0X") then {
	_text = _text select [2];
};
if !((count _text) in [6, 8]) exitWith {_fallback};

private _digits = "0123456789ABCDEF";
private _pair = {
	params ["_pairText", "_digits"];
	private _chars = toArray _pairText;
	private _hi = _digits find (toString [_chars param [0, 0]]);
	private _lo = _digits find (toString [_chars param [1, 0]]);
	if (_hi < 0 || {_lo < 0}) exitWith {-1};
	((_hi * 16) + _lo) / 255
};

private _red = [_text select [0, 2], _digits] call _pair;
private _green = [_text select [2, 2], _digits] call _pair;
private _blue = [_text select [4, 2], _digits] call _pair;
private _outAlpha = [1, _alpha] select (_alpha >= 0);

if (_red < 0 || {_green < 0 || {_blue < 0}}) exitWith {_fallback};
if ((count _text) == 8 && {_alpha < 0}) then {
	_outAlpha = [_text select [6, 2], _digits] call _pair;
	if (_outAlpha < 0) exitWith {_fallback};
};

[_red, _green, _blue, _outAlpha]
