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
	["_attachmentDescription", "", [""]],
	["_recipientRead", false, [false]],
	["_senderRead", true, [false]],
	["_ccRead", false, [false]]
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
if (_selectedIndex < 0) exitWith {
	["Mail", "Seed mail failed because user was not found", createHashMapFromArray [
		["object", _object],
		["username", _username],
		["subject", _subject],
		["direction", _direction],
		["knownUsers", _users apply {_x getOrDefault ["username", ""]}]
	]] call FUNC(debugLog);
	false
};

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
private _primaryRecipientAddress = toLowerANSI _to;
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
	private _isPrimaryRecipient = (_isSelected && {_direction isEqualTo "inbox"}) || {_email isEqualTo _primaryRecipientAddress};
	private _isCcRecipient = _email in _ccAddresses;

	if (_isPrimaryRecipient || _isCcRecipient) then {
		private _inboxMail = +_mail;
		_inboxMail set ["read", [_recipientRead, _ccRead] select (!_isPrimaryRecipient && _isCcRecipient)];
		private _inbox = _user getOrDefault ["mail", []];
		_inbox pushBack _inboxMail;
		_user set ["mail", _inbox];
		_user = [_user] call _addAttachment;
		_users set [_forEachIndex, _user];
		_changed = true;
	};

	if ((_isSelected && {_direction isEqualTo "outbox"}) || {_email isEqualTo _senderAddress}) then {
		private _outboxMail = +_mail;
		_outboxMail set ["read", _senderRead];
		private _outbox = _user getOrDefault ["outbox", []];
		_outbox pushBack _outboxMail;
		_user set ["outbox", _outbox];
		_users set [_forEachIndex, _user];
		_changed = true;
	};
} forEach _users;

if (!_changed) exitWith {
	["Mail", "Seed mail did not match any mailbox", createHashMapFromArray [
		["object", _object],
		["username", _username],
		["direction", _direction],
		["from", _from],
		["to", _to],
		["cc", _cc],
		["subject", _subject],
		["users", _users apply {createHashMapFromArray [
			["username", _x getOrDefault ["username", ""]],
			["email", _x getOrDefault ["email", ""]]
		]}]
	]] call FUNC(debugLog);
	false
};

_data set ["users", _users];
_object setVariable [QGVAR(data), _data, true];
["Mail", "Seeded mail", createHashMapFromArray [
	["object", _object],
	["username", _username],
	["direction", _direction],
	["from", _from],
	["to", _to],
	["cc", _cc],
	["subject", _subject],
	["users", _users apply {createHashMapFromArray [
		["username", _x getOrDefault ["username", ""]],
		["email", _x getOrDefault ["email", ""]],
		["inbox", count (_x getOrDefault ["mail", []])],
		["outbox", count (_x getOrDefault ["outbox", []])]
	]}]
]] call FUNC(debugLog);
true
