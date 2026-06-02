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
			["Background", "Preset desktop background for this user. Ignored if Custom Background Texture is filled."],
			[
				["default_dark", "default_light", "nato", "csat", "aaf", "fia"],
				["Default Dark", "Default Light", "NATO", "CSAT", "AAF", "FIA"],
				0
			],
			false
		],
		["EDIT", ["Custom Background Texture", "Optional texture path. If filled, this overrides the Background selection above."], "", false],
		[
			"COMBO",
			["Force Layout", "Optional layout override for this user."],
			[
				["", "dark", "light", "user", "blufor", "opfor", "independent", "civilian"],
				["None", "Dark", "Light", "User", "BLUFOR", "OPFOR", "Independent", "Civilian"],
				0
			],
			false
		]
	],
	{
		params ["_dialogValues", "_object"];
		_dialogValues params ["_username", "_password", "_email", "_background", "_backgroundCustom", "_forceTheme"];

		if (_backgroundCustom isNotEqualTo "") then {
			_background = _backgroundCustom;
		};

		private _targets = if (isNull _object) then {
			if (GVAR(registeredComputers) isEqualType []) then {GVAR(registeredComputers)} else {[]}
		} else {
			[_object]
		};

		{
			[_x, _username, _password, _email, _background, _forceTheme] remoteExecCall [QFUNC(addUser), 0, true];
		} forEach _targets;
		[objNull, "USER ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
	},
	{},
	_objectUnderCursor
] call zen_dialog_fnc_create;
