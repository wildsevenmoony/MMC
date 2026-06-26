#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Saves the name/e-mail fields into the active user's address book.
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
private _data = _computer getVariable [QGVAR(data), _display getVariable [QGVAR(data), createHashMap]];
private _activeUser = [_computer] call FUNC(getActiveUser);
private _username = _activeUser getOrDefault ["username", ""];
private _name = ctrlText (_display displayCtrl IDC_MMC_MAIL_RECIPIENT);
private _email = ctrlText (_display displayCtrl IDC_MMC_MAIL_SUBJECT);

if !([_display] call FUNC(mailAddressBookUpdateSaveState)) exitWith {
	_display setVariable [QGVAR(mailAddressBookStatus), "Enter a name and e-mail address first."];
	["addressbook"] call FUNC(renderMail);
	false
};

if !([_activeUser, _name, _email] call FUNC(addAddressBookEntry)) exitWith {
	_display setVariable [QGVAR(mailAddressBookStatus), "Enter a valid e-mail address."];
	["addressbook"] call FUNC(renderMail);
	false
};

private _users = _data getOrDefault ["users", []];
private _index = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username};
if (_index < 0) exitWith {false};
_users set [_index, _activeUser];
_data set ["users", _users];
_computer setVariable [QGVAR(data), _data, true];
_computer setVariable [QGVAR(activeUser), _activeUser, true];
_display setVariable [QGVAR(data), _data];
_display setVariable [QGVAR(activeUser), _activeUser];
_display setVariable [QGVAR(mailAddressBookStatus), "Address saved."];

["Mail", "Saved address book entry", createHashMapFromArray [
	["username", _username],
	["name", _name],
	["email", _email]
]] call FUNC(debugLog);

["addressbook"] call FUNC(renderMail);
true
