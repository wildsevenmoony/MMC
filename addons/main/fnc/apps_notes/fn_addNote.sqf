#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a note to a computer/device or to a specific user on that computer/device.
 *
 * Arguments:
 * 0: Computer/device object <OBJECT>
 * 1: Note title <STRING, default: "Untitled note">
 * 2: Note body <STRING, default: "">
 * 3: Username to receive the note <STRING, optional>
 * 4: Note id <STRING, optional>
 *
 * Return Value:
 * Added <BOOL>
 */

params [
	["_object", objNull, [objNull]],
	["_title", "Untitled note", [""]],
	["_body", "", [""]],
	["_username", "", [""]],
	["_id", "", [""]]
];

if (isNull _object) exitWith {false};

_title = [_title] call CBA_fnc_trim;
if (_title isEqualTo "") then {
	_title = "Untitled note";
};

if (_id isEqualTo "") then {
	_id = format ["note_%1_%2", floor (diag_tickTime * 1000), floor random 1000000];
};

private _stamp = call FUNC(formatMailDate);
private _note = createHashMapFromArray [
	["id", _id],
	["title", _title],
	["body", _body],
	["createdDate", _stamp select 0],
	["createdTime", _stamp select 1],
	["modifiedDate", _stamp select 0],
	["modifiedTime", _stamp select 1]
];

private _data = _object getVariable [QGVAR(data), [createHashMap] call FUNC(createDefaultData)];
private _added = false;

if (_username isNotEqualTo "") then {
	private _users = _data getOrDefault ["users", []];
	private _index = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username};
	if (_index >= 0) then {
		private _user = _users select _index;
		private _notes = +(_user getOrDefault ["notes", []]);
		_notes pushBack _note;
		_user set ["notes", _notes];
		_users set [_index, _user];
		_data set ["users", _users];
		if ((_object getVariable [QGVAR(activeUser), createHashMap]) getOrDefault ["username", ""] isEqualTo (_user getOrDefault ["username", ""])) then {
			_object setVariable [QGVAR(activeUser), _user, true];
		};
		_added = true;
	};
} else {
	private _notes = +(_data getOrDefault ["notes", []]);
	_notes pushBack _note;
	_data set ["notes", _notes];
	_added = true;
};

if (_added) then {
	_object setVariable [QGVAR(data), _data, true];
};

["Notes", "Added note", createHashMapFromArray [
	["object", _object],
	["username", _username],
	["title", _title],
	["added", _added]
]] call FUNC(debugLog);

_added
