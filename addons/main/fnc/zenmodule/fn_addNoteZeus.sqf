#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Opens the user-scoped Add Note dynamic Zeus dialog.
 *
 * Arguments:
 * 0: Module position <ARRAY>
 * 1: Object under cursor <OBJECT>
 *
 * Return Value:
 * None
 */

private _users = [] call FUNC(getRegisteredUsers);
if (_users isEqualTo []) exitWith {
	[objNull, "NO REGISTERED USERS"] call BIS_fnc_showCuratorFeedbackMessage;
};

createDialog QGVAR(RscAddNoteDialog)
