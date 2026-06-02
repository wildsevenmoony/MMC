#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds mission-maker seeded mail to the selected user's inbox/outbox and mirrors
 * matching copies to sender, recipient, and CC users where they exist.
 */

params [
	["_object", objNull, [objNull]],
	["_username", "", [""]],
	["_direction", "inbox", [""]],
	["_counterpartEmail", "sender@mmc.local", [""]],
	["_cc", "", [""]],
	["_subject", "Mission Update", [""]],
	["_body", "Mail body goes here.", [""]],
	["_dateInput", "", [""]],
	["_timeInput", "", [""]],
	["_attachment", "", [""]],
	["_attachmentDescription", "", [""]]
];

if (isNull _object || {_username isEqualTo ""}) exitWith {false};

_direction = toLowerANSI _direction;
if !(_direction in ["inbox", "outbox"]) then {
	_direction = "inbox";
};

if (_attachment isNotEqualTo "" && {!fileExists _attachment}) exitWith {
	diag_log format ["[MMC] Add Mail attachment not found: %1", _attachment];
	false
};

(call FUNC(formatMailDate)) params ["_fallbackDate", "_fallbackTime"];

private _isDateValid = {
	params [["_value", "", [""]]];
	private _chars = toArray _value;
	(count _chars == 10)
		&& {(_chars select 4) isEqualTo 45}
		&& {(_chars select 7) isEqualTo 45}
		&& {(_chars select [0, 4]) findIf {!(_x in [48,49,50,51,52,53,54,55,56,57])} < 0}
		&& {(_chars select [5, 2]) findIf {!(_x in [48,49,50,51,52,53,54,55,56,57])} < 0}
		&& {(_chars select [8, 2]) findIf {!(_x in [48,49,50,51,52,53,54,55,56,57])} < 0}
};

private _isTimeValid = {
	params [["_value", "", [""]]];
	private _chars = toArray _value;
	(count _chars == 5)
		&& {(_chars select 2) isEqualTo 58}
		&& {(_chars select [0, 2]) findIf {!(_x in [48,49,50,51,52,53,54,55,56,57])} < 0}
		&& {(_chars select [3, 2]) findIf {!(_x in [48,49,50,51,52,53,54,55,56,57])} < 0}
};

private _date = [_fallbackDate, _dateInput] select ([_dateInput] call _isDateValid);
private _time = [_fallbackTime, _timeInput] select ([_timeInput] call _isTimeValid);
private _content = [_body] call FUNC(normalizeStructuredText);
private _attachmentDescriptionNormalized = [_attachmentDescription] call FUNC(normalizeStructuredText);

private _data = _object getVariable [QGVAR(data), [createHashMap] call FUNC(createDefaultData)];
private _users = _data getOrDefault ["users", []];
private _selectedIndex = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username};
if (_selectedIndex < 0) exitWith {false};

private _selectedUser = _users select _selectedIndex;
private _selectedEmail = _selectedUser getOrDefault ["email", ""];
private _from = [_counterpartEmail, _selectedEmail] select (_direction isEqualTo "outbox");
private _to = [_selectedEmail, _counterpartEmail] select (_direction isEqualTo "outbox");
private _mail = createHashMapFromArray [
	["from", _from],
	["to", _to],
	["subject", _subject],
	["body", _content],
	["date", _date],
	["time", _time],
	["cc", _cc],
	["attachment", _attachment],
	["attachmentDescription", _attachmentDescriptionNormalized],
	["read", _direction isEqualTo "outbox"]
];

private _splitAddresses = {
	params [["_addresses", "", [""]]];
	private _result = [];
	{
		private _address = (_x splitString " 	") joinString "";
		if (_address isNotEqualTo "") then {
			_result pushBackUnique (toLowerANSI _address);
		};
	} forEach (_addresses splitString ",");
	_result
};

private _ccAddresses = [_cc] call _splitAddresses;
private _recipientAddresses = [toLowerANSI _to] + _ccAddresses;
private _senderAddress = toLowerANSI _from;
private _attachmentName = "";
if (_attachment isNotEqualTo "") then {
	private _parts = _attachment splitString "\/";
	_attachmentName = _parts param [((count _parts) - 1) max 0, "attachment.paa"];
};

private _addAttachment = {
	params ["_user"];
	if (_attachment isEqualTo "") exitWith {_user};
	private _files = _user getOrDefault ["files", []];
	_files pushBack createHashMapFromArray [
		["name", _attachmentName],
		["type", "picture"],
		["path", format ["\Pictures\%1", _attachmentName]],
		["content", _attachmentDescriptionNormalized],
		["texture", _attachment]
	];
	_user set ["files", _files];
	_user
};

private _changed = false;
{
	private _user = _x;
	private _email = toLowerANSI (_user getOrDefault ["email", ""]);
	private _isSelected = _forEachIndex isEqualTo _selectedIndex;

	if ((_isSelected && {_direction isEqualTo "inbox"}) || {_email in _recipientAddresses}) then {
		private _inbox = _user getOrDefault ["mail", []];
		_inbox pushBack +_mail;
		_user set ["mail", _inbox];
		_user = [_user] call _addAttachment;
		_users set [_forEachIndex, _user];
		_changed = true;
	};

	if ((_isSelected && {_direction isEqualTo "outbox"}) || {_email isEqualTo _senderAddress}) then {
		private _outbox = _user getOrDefault ["outbox", []];
		_outbox pushBack +_mail;
		_user set ["outbox", _outbox];
		_users set [_forEachIndex, _user];
		_changed = true;
	};
} forEach _users;

if (!_changed) exitWith {false};

_data set ["users", _users];
_object setVariable [QGVAR(data), _data, true];
true
