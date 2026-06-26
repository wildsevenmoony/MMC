#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Selects an address book row and fills the editor fields.
 *
 * Arguments:
 * 0: Table control <CONTROL, optional>
 * 1: Row index <NUMBER, optional>
 *
 * Return Value:
 * Selected <BOOL>
 */

params [
	["_control", controlNull, [controlNull]],
	["_selectedRow", -1, [0]]
];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (!isNull _control) then {
	_display = ctrlParent _control;
};
if (isNull _display) exitWith {false};

private _table = [(_display displayCtrl IDC_MMC_MAIL_TABLE), _control] select (!isNull _control);
private _row = _selectedRow;
if (_row < 0) then {
	_row = lnbCurSelRow _table;
};
private _entries = _display getVariable [QGVAR(addressBookRows), []];
if (_row <= 0 || {_row >= count _entries}) exitWith {
	_display setVariable [QGVAR(selectedAddressBookIndex), -1];
	_display setVariable [QGVAR(selectedAddressBookEntry), createHashMap];
	{
		(_display displayCtrl _x) ctrlEnable false;
	} forEach [IDC_MMC_MAIL_REPLY, IDC_MMC_MAIL_FORWARD, IDC_MMC_MAIL_CANCEL];
	[_display] call FUNC(mailAddressBookUpdateSaveState);
	false
};

private _entry = _entries param [_row, createHashMap];
_display setVariable [QGVAR(selectedAddressBookIndex), _row - 1];
_display setVariable [QGVAR(selectedAddressBookEntry), _entry];
(_display displayCtrl IDC_MMC_MAIL_RECIPIENT) ctrlSetText (_entry getOrDefault ["name", ""]);
(_display displayCtrl IDC_MMC_MAIL_SUBJECT) ctrlSetText (_entry getOrDefault ["email", ""]);
{
	(_display displayCtrl _x) ctrlEnable true;
} forEach [IDC_MMC_MAIL_REPLY, IDC_MMC_MAIL_FORWARD, IDC_MMC_MAIL_CANCEL];
[_display] call FUNC(mailAddressBookUpdateSaveState);
true
