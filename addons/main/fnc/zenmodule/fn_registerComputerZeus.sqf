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
			["Closed System", "Closed systems only allow users explicitly added to this computer. Open systems can use globally registered mission users."],
			false,
			false
		],
		[
			"CHECKBOX",
			["Starts Powered On", "If unchecked, Zeus or ACE must start the computer before players can open it."],
			true,
			false
		]
	],
	{
		params ["_dialogValues", "_object"];
		_dialogValues params ["_systemName", "_theme", "_closedSystem", "_poweredOn"];

		private _layout = createHashMapFromArray [
			["preset", _theme],
			["useCustomColors", false],
			["background", ""],
			["colors", createHashMap]
		];

		private _config = createHashMapFromArray [
			["systemName", _systemName],
			["layout", _layout],
			["closedSystem", _closedSystem],
			["poweredOn", _poweredOn]
		];

		[_object, _config] remoteExecCall [QFUNC(registerObject), 0, true];
		[objNull, "COMPUTER REGISTERED"] call BIS_fnc_showCuratorFeedbackMessage;
	},
	{},
	_objectUnderCursor
] call zen_dialog_fnc_create;
