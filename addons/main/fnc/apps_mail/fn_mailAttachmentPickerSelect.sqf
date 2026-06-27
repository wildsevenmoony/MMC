#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Handles folder and file selection in the mail attachment picker.
 *
 * Arguments:
 * 0: Mail table control <CONTROL, optional>
 * 1: Selected row <NUMBER, optional>
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

private _rows = _display getVariable [QGVAR(mailAttachmentPickerRows), []];
if (_row < 0 || {_row >= count _rows}) exitWith {false};

private _rowData = _rows param [_row, createHashMap];
private _action = _rowData getOrDefault ["action", ""];
switch (_action) do {
	case "folder": {
		_display setVariable [QGVAR(mailAttachmentPickerFolder), _rowData getOrDefault ["folder", ""]];
		["attachments"] call FUNC(renderMail);
		true
	};
	case "back": {
		_display setVariable [QGVAR(mailAttachmentPickerFolder), ""];
		["attachments"] call FUNC(renderMail);
		true
	};
	case "file": {
		private _file = _rowData getOrDefault ["file", createHashMap];
		if (count _file == 0) exitWith {false};
		private _attachments = _display getVariable [QGVAR(mailComposeAttachments), []];
		if !(_attachments isEqualType []) then {
			_attachments = [];
		};
		private _signature = format [
			"%1|%2|%3",
			toLowerANSI (_file getOrDefault ["name", ""]),
			toLowerANSI (_file getOrDefault ["path", ""]),
			toLowerANSI (_file getOrDefault ["texture", ""])
		];
		private _exists = _attachments findIf {
			format [
				"%1|%2|%3",
				toLowerANSI (_x getOrDefault ["name", ""]),
				toLowerANSI (_x getOrDefault ["path", ""]),
				toLowerANSI (_x getOrDefault ["texture", ""])
			] isEqualTo _signature
		};
		if (_exists < 0) then {
			_attachments pushBack (+_file);
			_display setVariable [QGVAR(mailComposeAttachments), _attachments];
			_display setVariable [QGVAR(mailAttachmentPickerStatus), format ["Added: %1", _file getOrDefault ["name", "Attachment"]]];
		} else {
			_display setVariable [QGVAR(mailAttachmentPickerStatus), "Attachment already added."];
		};
		["attachments"] call FUNC(renderMail);
		true
	};
	default {false};
}
