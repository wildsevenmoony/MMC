#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Registers the object under the Zeus cursor as an MMC computer.
 */

params [
	["_position", [], [[]]],
	["_objectUnderCursor", objNull, [objNull]]
];

if (isNull _objectUnderCursor) exitWith {
	[objNull, "PLACE ON AN OBJECT"] call BIS_fnc_showCuratorFeedbackMessage;
};

if (_objectUnderCursor isKindOf "CAManBase") exitWith {
	[objNull, "PLACE ON AN OBJECT"] call BIS_fnc_showCuratorFeedbackMessage;
};

[
	"Register Computer",
	[
		[
			"EDIT",
			["System Name", "Name shown in the MMC taskbar."],
			"MMC Workstation",
			false
		],
		[
			"COMBO",
			["Theme", "Preset layout and desktop background for the computer before a user is logged in."],
			[
				["default", "nato", "csat", "aaf"],
				["Default", "NATO", "CSAT", "AAF"],
				0
			],
			false
		],
		[
			"CHECKBOX",
			["Login Screen", "If disabled, the computer automatically opens the desktop of its first direct user. Add a user to the computer afterwards if none exists yet."],
			true,
			false
		],
		[
			"CHECKBOX",
			["Closed System", "Closed systems only allow users explicitly added to this computer. Open systems can use globally registered mission users."],
			false,
			false
		],
		[
			"CHECKBOX",
			["Starts Powered On", "If unchecked, Zeus or ACE must start the computer before players can open it."],
			true,
			false
		],
		[
			"CHECKBOX",
			["Files App", "If unchecked, the Files app is hidden for every user on this computer."],
			true,
			false
		],
		[
			"CHECKBOX",
			["Mail App", "If unchecked, the Mail app is hidden for every user on this computer."],
			true,
			false
		],
		[
			"CHECKBOX",
			["Messenger App", "If unchecked, the Messenger app is hidden for every user on this computer."],
			true,
			false
		],
		[
			"CHECKBOX",
			["Notes App", "If unchecked, the Notes app is hidden for every user on this computer."],
			true,
			false
		]
	],
	{
		params ["_dialogValues", "_object"];
		_dialogValues params ["_systemName", "_theme", "_loginRequired", "_closedSystem", "_poweredOn", "_filesEnabled", "_mailEnabled", "_messagesEnabled", "_notesEnabled"];

		private _layout = createHashMapFromArray [
			["preset", _theme],
			["useCustomColors", false],
			["background", ""],
			["colors", createHashMap]
		];

		private _disabledApps = [];
		if (!_filesEnabled) then {_disabledApps pushBack "files"};
		if (!_mailEnabled) then {_disabledApps pushBack "mail"};
		if (!_messagesEnabled) then {_disabledApps pushBack "messages"};
		if (!_notesEnabled) then {_disabledApps pushBack "notes"};

		private _config = createHashMapFromArray [
			["systemName", _systemName],
			["layout", _layout],
			["loginRequired", _loginRequired],
			["closedSystem", _closedSystem],
			["poweredOn", _poweredOn],
			["disabledApps", _disabledApps]
		];

		[_object, _config] remoteExecCall [QFUNC(registerObject), 2];
		[objNull, "COMPUTER REGISTERED"] call BIS_fnc_showCuratorFeedbackMessage;
	},
	{},
	_objectUnderCursor
] call zen_dialog_fnc_create;
