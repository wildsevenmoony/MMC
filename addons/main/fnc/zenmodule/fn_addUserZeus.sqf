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
		["EDIT", ["Address Book", "Optional comma or semicolon separated entries, e.g. Overlord <overlord@aaf.ass>,bravo@aaf.ass."], "", false],
		["EDIT", ["Messenger Username", "Display name shown in Messenger. Leave empty to use Username."], "", false],
		[
			"COMBO",
			["Messenger Side", "Side used by Messenger. Auto derives the side from the selected theme. Hidden keeps this user out of contact lists."],
			[
				["", "west", "east", "guer", "civ", "hidden"],
				["Auto (Theme)", "BLUFOR", "OPFOR", "Independent", "Civilian", "Hidden"],
				0
			],
			false
		],
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
		_dialogValues params ["_username", "_password", "_email", "_addressBookText", "_messengerName", "_messengerSide", "_theme", "_filesEnabled", "_mailEnabled", "_messagesEnabled", "_notesEnabled"];

		private _disabledApps = [];
		if (!_filesEnabled) then {_disabledApps pushBack "files"};
		if (!_mailEnabled) then {_disabledApps pushBack "mail"};
		if (!_messagesEnabled) then {_disabledApps pushBack "messages"};
		if (!_notesEnabled) then {_disabledApps pushBack "notes"};
		_messengerName = [_messengerName] call CBA_fnc_trim;
		if (_messengerName isEqualTo "") then {
			_messengerName = _username;
		};
		if (_messengerSide isEqualTo "") then {
			_messengerSide = [_theme, createHashMap] call FUNC(getMessengerSideFromTheme);
		};
		private _metadata = createHashMapFromArray [
			["displayName", _messengerName],
			["messengerName", _messengerName],
			["side", _messengerSide],
			["messengerSide", _messengerSide],
			["addressBook", [_addressBookText] call FUNC(normalizeAddressBook)]
		];

		private _targets = if (isNull _object) then {
			[] call FUNC(getRegisteredComputers)
		} else {
			[_object]
		};
		private _scope = ["direct", "global"] select (isNull _object);

		{
			[_x, _username, _password, _email, _theme, createHashMap, _scope, _disabledApps, _metadata] remoteExecCall [QFUNC(addUser), 2];
		} forEach _targets;
		[objNull, "USER ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
	},
	{},
	_objectUnderCursor
] call zen_dialog_fnc_create;
