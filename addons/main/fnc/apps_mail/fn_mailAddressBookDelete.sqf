#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Deletes the selected address book entry.
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
private _data = _computer getVariable [QGVAR(data), _display getVariable [QGVAR(data), createHashMap]];
private _activeUser = [_computer] call FUNC(getActiveUser);
private _username = _activeUser getOrDefault ["username", ""];
private _selected = _display getVariable [QGVAR(selectedAddressBookIndex), -1];
private _entries = [_activeUser getOrDefault ["addressBook", []]] call FUNC(normalizeAddressBook);
private _selectedEntry = _display getVariable [QGVAR(selectedAddressBookEntry), createHashMap];
if (count _selectedEntry == 0) exitWith {
	_display setVariable [QGVAR(mailAddressBookStatus), "Select an e-mail address first."];
	["addressbook"] call FUNC(renderMail);
	false
};
if (_selectedEntry getOrDefault ["dynamic", false]) exitWith {
	_display setVariable [QGVAR(mailAddressBookStatus), "Visible player addresses are not saved locally."];
	["addressbook"] call FUNC(renderMail);
	false
};
if (_selected < 0 || {_selected >= count _entries}) exitWith {false};

_entries deleteAt _selected;
_activeUser set ["addressBook", _entries];
private _users = _data getOrDefault ["users", []];
private _index = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username};
if (_index < 0) exitWith {false};
_users set [_index, _activeUser];
_data set ["users", _users];
_computer setVariable [QGVAR(data), _data, true];
_computer setVariable [QGVAR(activeUser), _activeUser, true];
_display setVariable [QGVAR(data), _data];
_display setVariable [QGVAR(activeUser), _activeUser];
_display setVariable [QGVAR(selectedAddressBookIndex), -1];
_display setVariable [QGVAR(mailAddressBookStatus), "Address deleted."];

["addressbook"] call FUNC(renderMail);
true
