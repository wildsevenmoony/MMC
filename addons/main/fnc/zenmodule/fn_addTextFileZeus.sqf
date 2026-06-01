#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a text file to selected MMC users.
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
	["CHECKBOX", [_username, "Select the Users to add the file to."], false, false]
};

[
	"Add Text File",
	([
		["EDIT", ["File Name", "Displayed in the computer's Files app."], "intel.txt", false],
		["EDIT", ["File Path", "Displayed path in the Files app."], "\Desktop\intel.txt", false],
		["EDIT", ["Content", "Text shown when the file is selected."], "Mission intel goes here.", false]
	] + _userFields),
	{
		params ["_dialogValues", "_args"];
		_args params ["_users"];

		private _name = _dialogValues param [0, "intel.txt", [""]];
		private _path = _dialogValues param [1, "\Desktop\intel.txt", [""]];
		private _content = _dialogValues param [2, "Mission intel goes here.", [""]];
		private _selected = [];

		for "_i" from 0 to ((count _users) - 1) do {
			if (_dialogValues param [_i + 3, false, [false]]) then {
				_selected pushBack ((_users select _i) getOrDefault ["username", ""]);
			};
		};

		if (_selected isEqualTo []) exitWith {
			[objNull, "NO USERS SELECTED"] call BIS_fnc_showCuratorFeedbackMessage;
		};

		{
			private _computer = _x;
			{
				[_computer, _x, _name, _content, "text", _path] remoteExecCall [QFUNC(addFileToUser), 0, true];
			} forEach _selected;
		} forEach GVAR(registeredComputers);
		[objNull, "TEXT FILE ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
	},
	{},
	[_users]
] call zen_dialog_fnc_create;
