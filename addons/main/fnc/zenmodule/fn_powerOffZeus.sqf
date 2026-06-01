#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Powers off the MMC computer under the Zeus cursor.
 */

params [
	["_position", [], [[]]],
	["_objectUnderCursor", objNull, [objNull]]
];

if (isNull _objectUnderCursor || {!(_objectUnderCursor getVariable [QGVAR(isComputer), false])}) exitWith {
	[objNull, "PLACE ON AN MMC COMPUTER"] call BIS_fnc_showCuratorFeedbackMessage;
};

[_objectUnderCursor, false] remoteExecCall [QFUNC(setPowerState), 0];
[objNull, "COMPUTER POWERED OFF"] call BIS_fnc_showCuratorFeedbackMessage;
