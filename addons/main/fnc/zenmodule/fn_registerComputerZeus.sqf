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
			"EDIT",
			["Background Texture", "Optional texture path for this computer's desktop background."],
			"",
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
		_dialogValues params ["_systemName", "_background", "_poweredOn"];

		private _config = createHashMapFromArray [
			["systemName", _systemName],
			["background", _background],
			["poweredOn", _poweredOn]
		];

		[_object, _config] remoteExecCall [QFUNC(registerObject), 0, true];
		[objNull, "COMPUTER REGISTERED"] call BIS_fnc_showCuratorFeedbackMessage;
	},
	{},
	_objectUnderCursor
] call zen_dialog_fnc_create;
