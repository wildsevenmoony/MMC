#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Registers ACE Zeus actions for opening MMC computers from the Zeus interface.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Registered <BOOL>
 */

if (!hasInterface) exitWith {false};
if (missionNamespace getVariable [QGVAR(zeusActionsRegistering), false]) exitWith {true};

missionNamespace setVariable [QGVAR(zeusActionsRegistering), true];

[] spawn {
	waitUntil {
		!isNull player
		&& {!isNil "ace_interact_menu_fnc_createAction"}
		&& {!isNil "ace_interact_menu_fnc_addActionToZeus"}
	};

	if (missionNamespace getVariable [QGVAR(zeusActionsAdded), false]) exitWith {};
	missionNamespace setVariable [QGVAR(zeusActionsAdded), true];

	private _action = [
		QGVAR(zeusComputerRoot),
		"Computer",
		"\a3\ui_f\data\igui\cfg\simpleTasks\types\computer_ca.paa",
		{},
		{true},
		{[] call MMC_fnc_zeusComputerChildren},
		[],
		[0, 0, 0],
		100,
		[false, false, true, false, true]
	] call ace_interact_menu_fnc_createAction;

	[["ACE_ZeusActions"], _action] call ace_interact_menu_fnc_addActionToZeus;
};

true
