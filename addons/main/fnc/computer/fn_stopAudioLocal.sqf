#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Stops the local audio source currently attached to a computer object.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 *
 * Return Value:
 * Stopped <BOOL>
 */

params [["_object", objNull, [objNull]]];

if (isNull _object) exitWith {false};

private _source = _object getVariable [QGVAR(audioSource), objNull];
if (!isNull _source) then {
	deleteVehicle _source;
};

_object setVariable [QGVAR(audioSource), objNull];
_object setVariable [QGVAR(audioName), ""];
true
