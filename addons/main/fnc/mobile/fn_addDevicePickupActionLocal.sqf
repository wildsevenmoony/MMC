#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds the local ACE pickup action to a placeable MMC mobile device object.
 *
 * Arguments:
 * 0: Device object <OBJECT>
 *
 * Return Value:
 * Added <BOOL>
 */

params [["_object", objNull, [objNull]]];

if (!hasInterface || {isNull _object}) exitWith {false};
if (_object getVariable [QGVAR(pickupActionAdded), false]) exitWith {true};
if (isNil "ace_interact_menu_fnc_createAction" || {isNil "ace_interact_menu_fnc_addActionToObject"}) exitWith {false};
if (count ([typeOf _object] call FUNC(getMobileDeviceType)) == 0) exitWith {false};

_object setVariable [QGVAR(pickupActionAdded), true];

private _action = [
	QGVAR(pickUpMobileDevice),
	"Pick Up Device",
	"\a3\ui_f\data\IGUI\Cfg\actions\take_ca.paa",
	{[_target] call MMC_fnc_pickUpDevice},
	{
		params ["_target", "_player"];
		!isNull _target
		&& {alive _target}
		&& {_player distance _target < 3}
		&& {count ([typeOf _target] call MMC_fnc_getMobileDeviceType) > 0}
	}
] call ace_interact_menu_fnc_createAction;

[_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

true
