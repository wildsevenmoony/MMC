#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Checks if the local player can start an MMC hacking attempt.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Hacking mode, "login" or "mobile" <STRING>
 *
 * Return Value:
 * Can start hacking <BOOL>
 */

params [
	["_display", displayNull, [displayNull]],
	["_mode", "login", [""]]
];

if (isNull _display || {!hasInterface}) exitWith {false};
if !(missionNamespace getVariable [QGVAR(hackingEnabled), true]) exitWith {false};
if (_display getVariable [QGVAR(hackingBusy), false]) exitWith {false};

private _requiredItem = [missionNamespace getVariable [QGVAR(hackingRequiredItem), QGVAR(hackingTool)]] call CBA_fnc_trim;
if (_requiredItem isEqualTo "") exitWith {true};

_requiredItem in ((items player) + (assignedItems player))
