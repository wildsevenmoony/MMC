#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Marks a selected inbox mail as read for the active user.
 */

params [["_mail", createHashMap, [createHashMap]]];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display || {count _mail == 0}) exitWith {false};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _data = _display getVariable [QGVAR(data), createHashMap];
private _activeUser = [_computer] call FUNC(getActiveUser);
private _username = _activeUser getOrDefault ["username", ""];
private _users = _data getOrDefault ["users", []];
private _userIndex = _users findIf {(_x getOrDefault ["username", ""]) isEqualTo _username};
if (_userIndex < 0) exitWith {false};

private _user = _users select _userIndex;
private _mailList = _user getOrDefault ["mail", []];
private _mailIndex = _mailList findIf {
	(_x getOrDefault ["from", ""]) isEqualTo (_mail getOrDefault ["from", ""])
	&& {(_x getOrDefault ["to", ""]) isEqualTo (_mail getOrDefault ["to", ""])}
	&& {(_x getOrDefault ["subject", ""]) isEqualTo (_mail getOrDefault ["subject", ""])}
	&& {(_x getOrDefault ["date", ""]) isEqualTo (_mail getOrDefault ["date", ""])}
	&& {(_x getOrDefault ["time", ""]) isEqualTo (_mail getOrDefault ["time", ""])}
};

if (_mailIndex < 0) exitWith {false};

private _storedMail = _mailList select _mailIndex;
_storedMail set ["read", true];
_mailList set [_mailIndex, _storedMail];
_user set ["mail", _mailList];
_users set [_userIndex, _user];
_data set ["users", _users];
_computer setVariable [QGVAR(data), _data, true];
_computer setVariable [QGVAR(activeUser), _user, true];
_display setVariable [QGVAR(data), _data];
_display setVariable [QGVAR(activeUser), _user];
_display setVariable [QGVAR(selectedMail), _storedMail];
true
