#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds an email to selected MMC users.
 */

params [
	["_position", [], [[]]],
	["_objectUnderCursor", objNull, [objNull]]
];

private _users = [] call FUNC(getRegisteredUsers);
if (_users isEqualTo []) exitWith {
	[objNull, "NO REGISTERED USERS"] call BIS_fnc_showCuratorFeedbackMessage;
};

private _userFields = _users apply {
	private _username = _x getOrDefault ["username", "Unknown"];
	["CHECKBOX", [_username, "Select the Users to add the mail to."], false, false]
};

[
	"Add Mail",
	([
		["EDIT", ["From", "Sender mail address displayed in the Mail app."], "sender@mmc.local", false],
		["EDIT", ["To", "Recipient mail address displayed in the Mail app. Leave empty to use each selected user's address."], "", false],
		["EDIT", ["Subject", "Mail subject displayed in the inbox list."], "Mission Update", false],
		["EDIT", ["Body", "Mail body shown when the mail is selected."], "Mail body goes here.", false],
		["EDIT", ["Date", "Display date for this mail."], "2035-06-01 08:00", false]
	] + _userFields),
	{
		params ["_dialogValues", "_args"];
		_args params ["_users"];

		private _from = _dialogValues param [0, "sender@mmc.local", [""]];
		private _to = _dialogValues param [1, "", [""]];
		private _subject = _dialogValues param [2, "Mission Update", [""]];
		private _body = _dialogValues param [3, "Mail body goes here.", [""]];
		private _date = _dialogValues param [4, "2035-06-01 08:00", [""]];
		private _selected = [];

		for "_i" from 0 to ((count _users) - 1) do {
			if (_dialogValues param [_i + 5, false, [false]]) then {
				_selected pushBack ((_users select _i) getOrDefault ["username", ""]);
			};
		};

		if (_selected isEqualTo []) exitWith {
			[objNull, "NO USERS SELECTED"] call BIS_fnc_showCuratorFeedbackMessage;
		};

		{
			private _computer = _x;
			{
				[_computer, _x, _from, _to, _subject, _body, _date] remoteExecCall [QFUNC(addMailToUser), 0, true];
			} forEach _selected;
		} forEach GVAR(registeredComputers);
		[objNull, "MAIL ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
	},
	{},
	[_users]
] call zen_dialog_fnc_create;
