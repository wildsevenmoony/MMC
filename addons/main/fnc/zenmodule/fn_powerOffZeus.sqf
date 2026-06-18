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

if (!alive _objectUnderCursor || {_objectUnderCursor getVariable [QGVAR(destroyed), false]}) exitWith {
	[objNull, "COMPUTER IS DESTROYED"] call BIS_fnc_showCuratorFeedbackMessage;
};

[_objectUnderCursor, false] remoteExecCall [QFUNC(setPowerState), 2];
[objNull, "COMPUTER POWERED OFF"] call BIS_fnc_showCuratorFeedbackMessage;
