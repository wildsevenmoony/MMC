#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Opens the user-scoped Add Mail dynamic Zeus dialog.
 */

private _users = [] call FUNC(getRegisteredUsers);
if (_users isEqualTo []) exitWith {
	[objNull, "NO REGISTERED USERS"] call BIS_fnc_showCuratorFeedbackMessage;
};

createDialog QGVAR(RscAddMailDialog)
