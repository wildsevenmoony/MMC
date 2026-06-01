#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a text file to the MMC computer under the Zeus cursor.
 */

params [
	["_position", [], [[]]],
	["_objectUnderCursor", objNull, [objNull]]
];

if (isNull _objectUnderCursor || {!(_objectUnderCursor getVariable [QGVAR(isComputer), false])}) exitWith {
	[objNull, "PLACE ON AN MMC COMPUTER"] call BIS_fnc_showCuratorFeedbackMessage;
};

[
	"Add Text File",
	[
		["EDIT", ["File Name", "Displayed in the computer's Files app."], "intel.txt", false],
		["EDIT", ["File Path", "Displayed path in the Files app."], "\Desktop\intel.txt", false],
		["EDIT", ["Content", "Text shown when the file is selected."], "Mission intel goes here.", false]
	],
	{
		params ["_dialogValues", "_object"];
		_dialogValues params ["_name", "_path", "_content"];

		[_object, _name, _content, "text", _path] remoteExecCall [QFUNC(addFile), 0, true];
		[objNull, "TEXT FILE ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
	},
	{},
	_objectUnderCursor
] call zen_dialog_fnc_create;
