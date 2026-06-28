#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Plays one local 3D hacking sound from a unit.
 *
 * Arguments:
 * 0: Sound origin unit <OBJECT>
 * 1: Sound class <STRING>
 *
 * Return Value:
 * Sound started <BOOL>
 */

params [
	["_unit", objNull, [objNull]],
	["_sound", "", [""]]
];

if (!hasInterface || {isNull _unit} || {_sound isEqualTo ""}) exitWith {false};

private _source = "Land_HelipadEmpty_F" createVehicleLocal (getPosATL _unit);
_source attachTo [_unit, [0, 0, 0.8]];
_source say3D _sound;

[
	{
		params ["_source"];
		if (!isNull _source) then {
			deleteVehicle _source;
		};
	},
	[_source],
	3.5
] call CBA_fnc_waitAndExecute;

true
