#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Starts the MMC computer under the Zeus cursor.
 */

params [
	["_position", [], [[]]],
	["_objectUnderCursor", objNull, [objNull]]
];

if (isNull _objectUnderCursor || {!(_objectUnderCursor getVariable [QGVAR(isComputer), false])}) exitWith {
	[objNull, "PLACE ON AN MMC COMPUTER"] call BIS_fnc_showCuratorFeedbackMessage;
};

if (_objectUnderCursor getVariable [QGVAR(poweredOn), false]) exitWith {
	[objNull, "COMPUTER IS ALREADY ON"] call BIS_fnc_showCuratorFeedbackMessage;
};

[_objectUnderCursor, false] remoteExecCall [QFUNC(startComputer), 0];
[objNull, "COMPUTER STARTING"] call BIS_fnc_showCuratorFeedbackMessage;
