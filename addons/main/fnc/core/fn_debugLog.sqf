#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Writes an MMC debug line to the RPT when debug logging is enabled.
 *
 * Arguments:
 * 0: Debug category <STRING>
 * 1: Message <STRING>
 * 2: Optional details <ANY>
 *
 * Return Value:
 * Logged <BOOL>
 */

params [
	["_category", "General", [""]],
	["_message", "", [""]]
];

if !(missionNamespace getVariable [QGVAR(debugEnabled), false]) exitWith {false};

private _detailText = "";
if ((count _this) > 2) then {
	private _details = _this param [2, ""];
	_detailText = format [" | %1", _details];
};

diag_log format [
	"[MMC DEBUG][%1][%2][%3] %4%5",
	_category,
	["SERVER", "CLIENT"] select hasInterface,
	diag_tickTime toFixed 3,
	_message,
	_detailText
];

true
