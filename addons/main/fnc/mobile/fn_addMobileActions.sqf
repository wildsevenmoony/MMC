#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Registers the ACE self-action that opens the player's personal MMC mobile device.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Registered <BOOL>
 */

if (!hasInterface) exitWith {false};
if (missionNamespace getVariable [QGVAR(mobileActionRegistering), false]) exitWith {true};
missionNamespace setVariable [QGVAR(mobileActionRegistering), true];

[] spawn {
	waitUntil {
		!isNull player
		&& {!isNil "ace_interact_menu_fnc_createAction"}
		&& {!isNil "ace_interact_menu_fnc_addActionToClass"}
	};

	if (missionNamespace getVariable [QGVAR(mobileActionAdded), false]) exitWith {};
	missionNamespace setVariable [QGVAR(mobileActionAdded), true];

	private _action = [
		QGVAR(openMobileDevice),
		"Mobile Device",
		"\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa",
		{[] call MMC_fnc_openMobile},
		{call MMC_fnc_hasMobileDeviceItem},
		{[] call MMC_fnc_mobileDeviceChildren},
		[],
		[0, 0, 0],
		100,
		[false, false, false, false, true]
	] call ace_interact_menu_fnc_createAction;

	["CAManBase", 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
};

true
