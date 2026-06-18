#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Deletes the selected personal note for the active MMC user.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Deleted <BOOL>
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

private _computer = _display getVariable [QGVAR(computer), objNull];
if (isNull _computer) exitWith {false};

private _id = _display getVariable [QGVAR(selectedNoteId), ""];
private _source = _display getVariable [QGVAR(selectedNoteSource), "user"];
if (_id isEqualTo "" || {_source isNotEqualTo "user"}) exitWith {
	_display setVariable [QGVAR(notesStatus), "Only saved personal notes can be deleted."];
	["render"] call FUNC(renderNotes);
	false
};

private _data = _computer getVariable [QGVAR(data), createHashMap];
private _activeUser = [_computer] call FUNC(getActiveUser);
private _username = _activeUser getOrDefault ["username", ""];
private _users = _data getOrDefault ["users", []];
private _userIndex = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username};
if (_userIndex < 0) exitWith {false};

private _user = _users select _userIndex;
private _notes = +(_user getOrDefault ["notes", []]);
private _oldCount = count _notes;
_notes = _notes select {(_x getOrDefault ["id", ""]) isNotEqualTo _id};
if ((count _notes) isEqualTo _oldCount) exitWith {false};

_user set ["notes", _notes];
_users set [_userIndex, _user];
_data set ["users", _users];
_computer setVariable [QGVAR(data), _data, true];
_computer setVariable [QGVAR(activeUser), _user, true];
_display setVariable [QGVAR(data), _data];
_display setVariable [QGVAR(activeUser), _user];
_display setVariable [QGVAR(selectedNoteId), ""];
_display setVariable [QGVAR(selectedNoteSource), "user"];
_display setVariable [QGVAR(notesStatus), "Note deleted."];
_display setVariable [QGVAR(notesDraftId), "__none"];
_display setVariable [QGVAR(notesDraftSource), "user"];
_display setVariable [QGVAR(notesDraftTitle), ""];
_display setVariable [QGVAR(notesDraftBody), ""];

["Notes", "Deleted note", createHashMapFromArray [
	["computer", _computer],
	["username", _username],
	["noteCount", count _notes]
]] call FUNC(debugLog);

["render"] call FUNC(renderNotes);
true
