#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds player interactions to a registered computer object.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 *
 * Return Value:
 * None
 */

params [["_object", objNull, [objNull]]];

if (isNull _object) exitWith {};
if !(_object getVariable [QGVAR(isComputer), false]) exitWith {};
if (_object getVariable [QGVAR(actionsAdded), false]) exitWith {};

_object setVariable [QGVAR(actionsAdded), true];

private _action = [
	QGVAR(openComputer),
	"Open Computer",
	"",
	{[_target] call FUNC(open)},
	{[_target] call FUNC(canOpen)}
] call ace_interact_menu_fnc_createAction;

[_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

private _startAction = [
	QGVAR(startComputer),
	"Start Computer",
	"",
	{[_target, true] call FUNC(startComputer)},
	{
		(_target getVariable [QGVAR(isComputer), false])
		&& {!(_target getVariable [QGVAR(poweredOn), true])}
		&& {!(_target getVariable [QGVAR(booting), false])}
	}
] call ace_interact_menu_fnc_createAction;

[_object, 0, ["ACE_MainActions"], _startAction] call ace_interact_menu_fnc_addActionToObject;
