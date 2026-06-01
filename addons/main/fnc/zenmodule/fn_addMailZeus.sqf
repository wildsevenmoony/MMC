#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds an email to the MMC computer under the Zeus cursor.
 */

params [
	["_position", [], [[]]],
	["_objectUnderCursor", objNull, [objNull]]
];

if (isNull _objectUnderCursor || {!(_objectUnderCursor getVariable [QGVAR(isComputer), false])}) exitWith {
	[objNull, "PLACE ON AN MMC COMPUTER"] call BIS_fnc_showCuratorFeedbackMessage;
};

[
	"Add Mail",
	[
		["EDIT", ["From", "Sender mail address displayed in the Mail app."], "sender@mmc.local", false],
		["EDIT", ["To", "Recipient mail address displayed in the Mail app."], "operator@mmc.local", false],
		["EDIT", ["Subject", "Mail subject displayed in the inbox list."], "Mission Update", false],
		["EDIT", ["Body", "Mail body shown when the mail is selected."], "Mail body goes here.", false],
		["EDIT", ["Date", "Display date for this mail."], "2035-06-01 08:00", false]
	],
	{
		params ["_dialogValues", "_object"];
		_dialogValues params ["_from", "_to", "_subject", "_body", "_date"];

		[_object, _from, _to, _subject, _body, _date] remoteExecCall [QFUNC(addMail), 0, true];
		[objNull, "MAIL ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
	},
	{},
	_objectUnderCursor
] call zen_dialog_fnc_create;
