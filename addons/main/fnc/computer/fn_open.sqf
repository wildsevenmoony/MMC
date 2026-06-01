#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Opens the computer UI for a registered computer object.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 *
 * Return Value:
 * Opened <BOOL>
 */

params [["_object", objNull, [objNull]]];

if (isNull _object || {!(_object getVariable [QGVAR(isComputer), false])}) exitWith {false};

if (_object getVariable [QGVAR(booting), false]) exitWith {
	hint "The computer is booting.";
	false
};

if !(_object getVariable [QGVAR(poweredOn), true]) exitWith {
	hint "The computer is powered off.";
	false
};

private _ownerUid = getPlayerUID player;
private _inUseBy = _object getVariable [QGVAR(inUseBy), ""];
if (_inUseBy isNotEqualTo "" && {_inUseBy isNotEqualTo _ownerUid}) exitWith {
	["This computer is already in use.", 1.5, player, 12] call ace_common_fnc_displayTextStructured;
	false
};

_object setVariable [QGVAR(inUseBy), _ownerUid, true];
GVAR(activeComputer) = _object;
createDialog QGVAR(RscComputer);
true
