#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Applies solid themed button hover colors.
 */

params [
	["_control", controlNull, [controlNull]],
	["_hovered", false, [false]]
];

if (isNull _control) exitWith {};

private _theme = GVAR(profileTheme);
private _button = [0.028, 0.032, 0.042, 0.98];
private _hover = [0.07, 0.078, 0.096, 0.98];

if (_theme isEqualTo "light") then {
	_button = [0.88, 0.895, 0.91, 0.98];
	_hover = [0.76, 0.78, 0.81, 0.98];
};

if (_theme isEqualTo "user") then {
	_button = [
		profileNamespace getVariable ["GUI_BCG_RGB_R", 0.13],
		profileNamespace getVariable ["GUI_BCG_RGB_G", 0.54],
		profileNamespace getVariable ["GUI_BCG_RGB_B", 0.21],
		profileNamespace getVariable ["GUI_BCG_RGB_A", 0.8]
	];
	_hover = [
		((_button select 0) + 0.12) min 1,
		((_button select 1) + 0.12) min 1,
		((_button select 2) + 0.12) min 1,
		0.98
	];
};

switch (_theme) do {
	case "blufor": {
		_button = [0, 0.333, 0.706, 0.98];
		_hover = [0.08, 0.42, 0.8, 0.98];
	};
	case "opfor": {
		_button = [0.886, 0, 0, 0.98];
		_hover = [1, 0.13, 0.13, 0.98];
	};
	case "independent": {
		_button = [0, 0.561, 0, 0.98];
		_hover = [0.12, 0.66, 0.12, 0.98];
	};
	case "civilian": {
		_button = [0.631, 0, 0.706, 0.98];
		_hover = [0.73, 0.1, 0.8, 0.98];
	};
};

_control ctrlSetBackgroundColor ([_button, _hover] select _hovered);
