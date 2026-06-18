#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Saves the currently edited note for the active MMC user.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Saved <BOOL>
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

private _computer = _display getVariable [QGVAR(computer), objNull];
if (isNull _computer) exitWith {false};

private _titleControl = _display getVariable [QGVAR(notesTitleControl), controlNull];
private _bodyControl = _display getVariable [QGVAR(notesBodyControl), controlNull];
if (isNull _titleControl || {isNull _bodyControl}) exitWith {false};

private _title = [ctrlText _titleControl] call CBA_fnc_trim;
private _body = ctrlText _bodyControl;
private _trimmedBody = [_body] call CBA_fnc_trim;
if (_title isEqualTo "" && {_trimmedBody isEqualTo ""}) exitWith {
	_display setVariable [QGVAR(notesStatus), "Write a title or body before saving."];
	["render"] call FUNC(renderNotes);
	false
};

if (_title isEqualTo "") then {
	private _lines = _body splitString (toString [10, 13]);
	_title = [_lines param [0, "Untitled note"]] call CBA_fnc_trim;
	if (_title isEqualTo "") then {
		_title = "Untitled note";
	};
	if (count _title > 44) then {
		_title = format ["%1...", _title select [0, 41]];
	};
};

private _data = _computer getVariable [QGVAR(data), createHashMap];
private _activeUser = [_computer] call FUNC(getActiveUser);
private _username = _activeUser getOrDefault ["username", ""];
if (_username isEqualTo "") exitWith {false};

private _users = _data getOrDefault ["users", []];
private _userIndex = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username};
if (_userIndex < 0) exitWith {false};

private _user = _users select _userIndex;
private _notes = +(_user getOrDefault ["notes", []]);
private _id = _display getVariable [QGVAR(selectedNoteId), ""];
private _source = _display getVariable [QGVAR(selectedNoteSource), "user"];
if (_source isNotEqualTo "user") then {
	_id = "";
};

private _noteIndex = if (_id isEqualTo "") then {-1} else {
	_notes findIf {(_x getOrDefault ["id", ""]) isEqualTo _id}
};
private _stamp = call FUNC(formatMailDate);
private _note = if (_noteIndex >= 0) then {
	_notes select _noteIndex
} else {
	_id = format ["note_%1_%2", floor (diag_tickTime * 1000), floor random 1000000];
	createHashMapFromArray [
		["id", _id],
		["createdDate", _stamp select 0],
		["createdTime", _stamp select 1]
	]
};

if !("createdDate" in keys _note) then {
	_note set ["createdDate", _stamp select 0];
};
if !("createdTime" in keys _note) then {
	_note set ["createdTime", _stamp select 1];
};
_note set ["id", _id];
_note set ["title", _title];
_note set ["body", _body];
_note set ["modifiedDate", _stamp select 0];
_note set ["modifiedTime", _stamp select 1];

if (_noteIndex >= 0) then {
	_notes set [_noteIndex, _note];
} else {
	_notes pushBack _note;
};

_user set ["notes", _notes];
_users set [_userIndex, _user];
_data set ["users", _users];
_computer setVariable [QGVAR(data), _data, true];
_computer setVariable [QGVAR(activeUser), _user, true];
_display setVariable [QGVAR(data), _data];
_display setVariable [QGVAR(activeUser), _user];
_display setVariable [QGVAR(selectedNoteId), _id];
_display setVariable [QGVAR(selectedNoteSource), "user"];
_display setVariable [QGVAR(notesStatus), "Note saved."];
_display setVariable [QGVAR(notesDraftId), "__none"];
_display setVariable [QGVAR(notesDraftSource), "user"];
_display setVariable [QGVAR(notesDraftTitle), ""];
_display setVariable [QGVAR(notesDraftBody), ""];

["Notes", "Saved note", createHashMapFromArray [
	["computer", _computer],
	["username", _username],
	["title", _title],
	["noteCount", count _notes]
]] call FUNC(debugLog);

["render"] call FUNC(renderNotes);
true
