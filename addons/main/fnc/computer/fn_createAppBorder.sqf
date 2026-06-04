#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Creates a text-free border from four small background controls.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Parent control <CONTROL, default: controlNull>
 * 2: Position <ARRAY [x,y,w,h]>
 * 3: Color <ARRAY>
 * 4: Thickness <NUMBER, default: 0.0012>
 *
 * Return Value:
 * Border controls <ARRAY>
 */

params [
	["_display", displayNull, [displayNull]],
	["_parent", controlNull, [controlNull]],
	["_position", [0, 0, 0, 0], [[]], 4],
	["_color", [0, 0, 0, 0.85], [[]], 4],
	["_thickness", 0.0012, [0]]
];

if (isNull _display) exitWith {[]};

_position params ["_x", "_y", "_w", "_h"];
private _t = _thickness max 0.0005;
private _positions = [
	[_x, _y, _w, _t],
	[_x, _y + _h - _t, _w, _t],
	[_x, _y, _t, _h],
	[_x + _w - _t, _y, _t, _h]
];

private _controls = [];
{
	private _control = if (isNull _parent) then {
		_display ctrlCreate [QGVAR(RscComputerLine), [_display] call FUNC(nextDynamicIdc)]
	} else {
		_display ctrlCreate [QGVAR(RscComputerLine), [_display] call FUNC(nextDynamicIdc), _parent]
	};
	_control ctrlSetText "";
	_control ctrlSetPosition _x;
	_control ctrlSetBackgroundColor _color;
	_control ctrlCommit 0;
	_controls pushBack _control;
} forEach _positions;

_controls
