#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Opens the mail row clicked in the mail table.
 *
 * Arguments:
 * 0: Mail table control <CONTROL, optional>
 * 1: Selected row <NUMBER, optional>
 *
 * Return Value:
 * Opened mail <BOOL>
 */

params [
	["_control", controlNull, [controlNull]],
	["_selectedRow", -1, [0]]
];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};
if (!isNull _control) then {
	_display = ctrlParent _control;
};
private _validClick = _display getVariable [QGVAR(mailTableClickValid), false];
_display setVariable [QGVAR(mailTableClickValid), false];
if (!_validClick) exitWith {false};

if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
	_display setVariable [QGVAR(startMenuOpen), false];
	_display setVariable [QGVAR(mobileNavOpen), false];
	_display setVariable [QGVAR(mobileCustomAppsOpen), false];
};

private _table = [(_display displayCtrl IDC_MMC_MAIL_TABLE), _control] select (!isNull _control);
private _index = _selectedRow;
if (_index < 0) then {
	_index = lnbCurSelRow _table;
};
private _rows = _display getVariable [QGVAR(mailRows), []];
if (_index <= 0 || {_index >= count _rows}) exitWith {false};

private _mail = _rows param [_index, createHashMap];
if (count _mail == 0) exitWith {false};

_display setVariable [QGVAR(selectedMail), _mail];
_display setVariable [QGVAR(selectedMailFolder), _display getVariable [QGVAR(mailFolder), "inbox"]];
if ((_display getVariable [QGVAR(mailFolder), "inbox"]) isEqualTo "inbox") then {
	[_mail] call FUNC(markMailRead);
} else {
	_mail set ["read", true];
	_display setVariable [QGVAR(selectedMail), _mail];
	private _activeUser = [_display getVariable [QGVAR(computer), objNull]] call FUNC(getActiveUser);
	private _outbox = _activeUser getOrDefault ["outbox", []];
	private _mailIndex = _outbox findIf {
		(_x getOrDefault ["from", ""]) isEqualTo (_mail getOrDefault ["from", ""])
		&& {(_x getOrDefault ["to", ""]) isEqualTo (_mail getOrDefault ["to", ""])}
		&& {(_x getOrDefault ["subject", ""]) isEqualTo (_mail getOrDefault ["subject", ""])}
		&& {(_x getOrDefault ["date", ""]) isEqualTo (_mail getOrDefault ["date", ""])}
		&& {(_x getOrDefault ["time", ""]) isEqualTo (_mail getOrDefault ["time", ""])}
	};
	if (_mailIndex >= 0) then {
		_outbox set [_mailIndex, _mail];
		_activeUser set ["outbox", _outbox];
		private _computer = _display getVariable [QGVAR(computer), objNull];
		if (!isNull _computer) then {
			_computer setVariable [QGVAR(activeUser), _activeUser, true];
		};
		_display setVariable [QGVAR(activeUser), _activeUser];
	};
};
_display setVariable [QGVAR(mailMode), "read"];
["read"] call FUNC(renderMail);
true
