#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Renders one of the desktop applications.
 *
 * Arguments:
 * 0: App id or "select" <STRING>
 * 1: Selection event data <ARRAY, optional>
 */

params [
	["_app", "desktop", [""]],
	["_event", [], [[]]]
];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _data = _display getVariable [QGVAR(data), createHashMap];
private _poweredOn = _computer getVariable [QGVAR(poweredOn), true];
private _activeUser = [_computer] call FUNC(getActiveUser);

private _title = _display displayCtrl IDC_MMC_APP_TITLE;
private _list = _display displayCtrl IDC_MMC_APP_LIST;
private _body = _display displayCtrl IDC_MMC_APP_BODY;

if (!_poweredOn) exitWith {
	[_display, true, ["MMC", "System powered off", ""], -1] call FUNC(setSystemOverlay);
	_title ctrlSetText "";
	lbClear _list;
	_body ctrlSetStructuredText parseText "";
};

[_display, false] call FUNC(setSystemOverlay);

if (count _activeUser == 0) exitWith {
	[_display] call FUNC(showLogin);
};

if (_app isEqualTo "select") then {
	_app = _display getVariable [QGVAR(currentApp), "desktop"];
} else {
	_display setVariable [QGVAR(currentApp), _app];
};

private _index = if (_event isEqualTo []) then {lbCurSel _list} else {_event select 1};
lbClear _list;

private _setBody = {
	params ["_text"];
	_body ctrlSetStructuredText parseText _text;
};
private _noContent = "<t size='1.25'>No Content available</t>";

switch (_app) do {
	case "files": {
		_title ctrlSetText "Files";
		private _files = (_data getOrDefault ["files", []]) + (_activeUser getOrDefault ["files", []]);
		if (_files isEqualTo []) exitWith {
			[_noContent] call _setBody;
		};
		{
			private _row = _list lbAdd format ["%1  (%2)", _x getOrDefault ["name", "Untitled"], _x getOrDefault ["type", "file"]];
			_list lbSetTooltip [_row, format [
				"%1%2Type: %3",
				_x getOrDefault ["path", _x getOrDefault ["name", "Untitled"]],
				toString [10],
				_x getOrDefault ["type", "file"]
			]];
		} forEach _files;
		if (_index < 0) then {_index = 0};
		_list lbSetCurSel _index;
		private _file = _files param [_index, createHashMap];
		[format [
			"<t size='1.25'>%1</t><br/><t color='#9fb6d8'>%2</t><br/><br/>%3",
			_file getOrDefault ["name", "No file selected"],
			_file getOrDefault ["path", ""],
			_file getOrDefault ["content", ""]
		]] call _setBody;
	};
	case "mail": {
		_title ctrlSetText "Mail";
		private _email = toLowerANSI (_activeUser getOrDefault ["email", ""]);
		private _mail = ((_data getOrDefault ["mail", []]) + (_activeUser getOrDefault ["mail", []])) select {
			private _to = toLowerANSI (_x getOrDefault ["to", ""]);
			_to in ["", "*"] || {_to isEqualTo _email}
		};
		if (_mail isEqualTo []) exitWith {
			[_noContent] call _setBody;
		};
		{
			private _row = _list lbAdd format ["%1 - %2", _x getOrDefault ["from", "Unknown"], _x getOrDefault ["subject", "No subject"]];
			_list lbSetTooltip [_row, format [
				"From: %1%4To: %2%4Subject: %3",
				_x getOrDefault ["from", "Unknown"],
				_x getOrDefault ["to", ""],
				_x getOrDefault ["subject", "No subject"],
				toString [10]
			]];
		} forEach _mail;
		if (_index < 0) then {_index = 0};
		_list lbSetCurSel _index;
		private _message = _mail param [_index, createHashMap];
		[format [
			"<t size='1.25'>%1</t><br/><t color='#9fb6d8'>From: %2<br/>To: %3<br/>Date: %4</t><br/><br/>%5",
			_message getOrDefault ["subject", "No subject"],
			_message getOrDefault ["from", "Unknown"],
			_message getOrDefault ["to", ""],
			_message getOrDefault ["date", ""],
			_message getOrDefault ["body", ""]
		]] call _setBody;
	};
	case "messages": {
		_title ctrlSetText "Messenger";
		private _email = toLowerANSI (_activeUser getOrDefault ["email", ""]);
		private _username = toLowerANSI (_activeUser getOrDefault ["username", ""]);
		private _messages = (_data getOrDefault ["messages", []]) select {
			private _to = toLowerANSI (_x getOrDefault ["to", ""]);
			_to in ["", "*"] || {_to in [_email, _username]}
		};
		if (_messages isEqualTo []) exitWith {
			[_noContent] call _setBody;
		};
		{
			_list lbAdd format ["%1  %2", _x getOrDefault ["date", ""], _x getOrDefault ["from", "Unknown"]];
		} forEach _messages;
		if (_index < 0) then {_index = 0};
		_list lbSetCurSel _index;
		private _threadText = _messages apply {
			format [
				"<t color='#9fb6d8'>[%1] %2</t><br/>%3",
				_x getOrDefault ["date", ""],
				_x getOrDefault ["from", "Unknown"],
				_x getOrDefault ["body", ""]
			]
		};
		[_threadText joinString "<br/><br/>"] call _setBody;
	};
	case "notes": {
		_title ctrlSetText "Notes";
		private _notes = _data getOrDefault ["notes", []];
		if (_notes isEqualTo []) exitWith {
			[_noContent] call _setBody;
		};
		{
			_list lbAdd (_x getOrDefault ["title", "Untitled note"]);
		} forEach _notes;
		if (_index < 0) then {_index = 0};
		_list lbSetCurSel _index;
		private _note = _notes param [_index, createHashMap];
		[format [
			"<t size='1.25'>%1</t><br/><br/>%2",
			_note getOrDefault ["title", "No note selected"],
			_note getOrDefault ["body", ""]
		]] call _setBody;
	};
	default {
		_title ctrlSetText "Desktop";
		["<t size='1.35'>Welcome</t><br/><br/>Select an app on the left. Files, Mail, Messenger, and Notes are wired to the computer data model now.<br/><br/>The Start button controls power state."] call _setBody;
	};
};
