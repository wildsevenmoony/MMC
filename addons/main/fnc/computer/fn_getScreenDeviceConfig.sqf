#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Resolves the object screen aspect and setObjectTexture selection.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 *
 * Return Value:
 * [Aspect <STRING>, Texture selection <NUMBER>]
 */

params [["_object", objNull, [objNull]]];

// Add future devices to one of these aspect lists and, if needed, to _selectionOneClasses.
private _aspect1x1Classes = [
	"Land_PCSet_01_screen_F",
	"Land_PCSet_Intel_01_F",
	"Land_PCSet_Intel_02_F",
	"Land_Laptop_03_black_F",
	"Land_Laptop_03_olive_F",
	"Land_Laptop_03_sand_F",
	"Land_Laptop_02_unfolded_F",
	"Land_FlatTV_01_F"
];

private _aspect2x1Classes = [
	"Land_Laptop_device_F",
	"Land_Laptop_unfolded_F",
	"Land_Laptop_Intel_01_F",
	"Land_Laptop_Intel_02_F",
	"Land_Laptop_Intel_Oldman_F"
];

private _selectionOneClasses = [
	"Land_Laptop_03_black_F",
	"Land_Laptop_03_olive_F",
	"Land_Laptop_03_sand_F"
];

private _aspect = "1x1";
if (_aspect2x1Classes findIf {_object isKindOf _x} >= 0) then {
	_aspect = "2x1";
} else {
	if (_aspect1x1Classes findIf {_object isKindOf _x} < 0) then {
		_aspect = "1x1";
	};
};

private _selection = 0;
if (_selectionOneClasses findIf {_object isKindOf _x} >= 0) then {
	_selection = 1;
};

[_aspect, _selection]
