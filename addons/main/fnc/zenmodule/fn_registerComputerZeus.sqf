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
			["Background", "Preset desktop background. Ignored if Custom Background Texture is filled."],
			[
				["default_dark", "default_light", "nato", "csat", "aaf", "fia"],
				["Default Dark", "Default Light", "NATO", "CSAT", "AAF", "FIA"],
				0
			],
			false
		],
		[
			"EDIT",
			["Custom Background Texture", "Optional texture path. If filled, this overrides the Background selection above."],
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
		_dialogValues params ["_systemName", "_background", "_backgroundCustom", "_poweredOn"];

		if (_backgroundCustom isNotEqualTo "") then {
			_background = _backgroundCustom;
		};

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
