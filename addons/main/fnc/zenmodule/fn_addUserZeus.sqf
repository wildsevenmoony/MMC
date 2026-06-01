#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a user to the MMC computer under the Zeus cursor.
 */

params [
	["_position", [], [[]]],
	["_objectUnderCursor", objNull, [objNull]]
];

if (isNull _objectUnderCursor || {!(_objectUnderCursor getVariable [QGVAR(isComputer), false])}) exitWith {
	[objNull, "PLACE ON AN MMC COMPUTER"] call BIS_fnc_showCuratorFeedbackMessage;
};

[
	"Add User",
	[
		["EDIT", ["Username", "Login username for this account."], "operator", false],
		["EDIT", ["Password", "Leave empty to allow login with an empty password field."], "", false],
		["EDIT", ["E-Mail Address", "Mail addressed to this value appears in this user's inbox."], "operator@mccsystems.com", false],
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
		["EDIT", ["Custom Background Texture", "Optional texture path. If filled, this overrides the Background selection above."], "", false]
	],
	{
		params ["_dialogValues", "_object"];
		_dialogValues params ["_username", "_password", "_email", "_background", "_backgroundCustom"];

		if (_backgroundCustom isNotEqualTo "") then {
			_background = _backgroundCustom;
		};

		[_object, _username, _password, _email, _background] remoteExecCall [QFUNC(addUser), 0, true];
		[objNull, "USER ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
	},
	{},
	_objectUnderCursor
] call zen_dialog_fnc_create;
