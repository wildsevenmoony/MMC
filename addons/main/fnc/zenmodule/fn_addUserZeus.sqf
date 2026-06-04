#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a user to the MMC computer under the Zeus cursor.
 */

params [
	["_position", [], [[]]],
	["_objectUnderCursor", objNull, [objNull]]
];

if (!isNull _objectUnderCursor && {!(_objectUnderCursor getVariable [QGVAR(isComputer), false])}) exitWith {
	[objNull, "PLACE ON AN MMC COMPUTER OR EMPTY GROUND"] call BIS_fnc_showCuratorFeedbackMessage;
};

[
	"Add User",
	[
		["EDIT", ["Username", "Login username for this account."], "operator", false],
		["EDIT", ["Password", "Leave empty to allow login with an empty password field."], "", false],
		["EDIT", ["E-Mail Address", "Mail addressed to this value appears in this user's inbox."], "operator@mmcsystems.com", false],
		[
			"COMBO",
			["Theme", "Preset layout and desktop background for this user. Default uses the client's CBA Default Theme."],
			[
				["default", "nato", "csat", "aaf"],
				["Default", "NATO", "CSAT", "AAF"],
				0
			],
			false
		],
		["CHECKBOX", ["Files App", "If unchecked, the Files app is hidden while this user is logged in."], true, false],
		["CHECKBOX", ["Mail App", "If unchecked, the Mail app is hidden while this user is logged in."], true, false],
		["CHECKBOX", ["Messenger App", "If unchecked, the Messenger app is hidden while this user is logged in."], true, false],
		["CHECKBOX", ["Notes App", "If unchecked, the Notes app is hidden while this user is logged in."], true, false]
	],
	{
		params ["_dialogValues", "_object"];
		_dialogValues params ["_username", "_password", "_email", "_theme", "_filesEnabled", "_mailEnabled", "_messagesEnabled", "_notesEnabled"];

		private _disabledApps = [];
		if (!_filesEnabled) then {_disabledApps pushBack "files"};
		if (!_mailEnabled) then {_disabledApps pushBack "mail"};
		if (!_messagesEnabled) then {_disabledApps pushBack "messages"};
		if (!_notesEnabled) then {_disabledApps pushBack "notes"};

		private _targets = if (isNull _object) then {
			if (GVAR(registeredComputers) isEqualType []) then {GVAR(registeredComputers)} else {[]}
		} else {
			[_object]
		};
		private _scope = ["direct", "global"] select (isNull _object);

		{
			[_x, _username, _password, _email, _theme, createHashMap, _scope, _disabledApps] remoteExecCall [QFUNC(addUser), 0, true];
		} forEach _targets;
		[objNull, "USER ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
	},
	{},
	_objectUnderCursor
] call zen_dialog_fnc_create;
