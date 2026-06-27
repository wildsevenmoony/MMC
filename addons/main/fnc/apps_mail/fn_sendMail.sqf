#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Sends mail from one mission-defined user to another across registered computers.
 */

params [
	["_fromEmail", "", [""]],
	["_toEmail", "", [""]],
	["_subject", "", [""]],
	["_body", "", [""]],
	["_attachment", "", [""]],
	["_cc", "", [""]],
	["_attachmentDescription", "", [""]],
	["_attachments", [], [[]]]
];

private _fromUser = [_fromEmail] call FUNC(findUserByEmail);
private _toUser = [_toEmail] call FUNC(findUserByEmail);
if (count _fromUser == 0 || {count _toUser == 0}) exitWith {
	["Mail", "Send mail delivery failed during sender/recipient lookup", createHashMapFromArray [
		["from", _fromEmail],
		["to", _toEmail],
		["fromFound", count _fromUser > 0],
		["toFound", count _toUser > 0]
	]] call FUNC(debugLog);
	false
};

(call FUNC(formatMailDate)) params ["_date", "_time"];
_body = [_body] call FUNC(normalizeStructuredText);
_attachmentDescription = [_attachmentDescription] call FUNC(normalizeStructuredText);
_attachments = [_attachment, _attachmentDescription, _attachments] call FUNC(mailNormalizeAttachments);
if (_attachments isNotEqualTo []) then {
	_attachment = (_attachments select 0) getOrDefault ["texture", (_attachments select 0) getOrDefault ["path", ""]];
	_attachmentDescription = (_attachments select 0) getOrDefault ["content", _attachmentDescription];
};
private _message = createHashMapFromArray [
	["from", _fromEmail],
	["to", _toEmail],
	["subject", _subject],
	["body", _body],
	["date", _date],
	["time", _time],
	["cc", _cc],
	["attachment", _attachment],
	["attachmentDescription", _attachmentDescription],
	["attachments", _attachments],
	["read", false]
];

private _fromName = _fromUser getOrDefault ["username", ""];
private _toName = _toUser getOrDefault ["username", ""];
private _ccNames = [];
{
	private _ccAddress = (_x splitString " ") joinString "";
	private _ccUser = [_ccAddress] call FUNC(findUserByEmail);
	if (count _ccUser > 0) then {
		_ccNames pushBackUnique (_ccUser getOrDefault ["username", ""]);
	};
} forEach (_cc splitString ",");

private _notifyUser = {
	params [
		["_computer", objNull, [objNull]],
		["_user", createHashMap, [createHashMap]]
	];
	if (isNull _computer || {count _user == 0}) exitWith {};

	private _targets = [];
	private _ownerUid = _computer getVariable [QGVAR(mobileOwnerUid), ""];
	if (_ownerUid isNotEqualTo "") then {
		{
			if (getPlayerUID _x isEqualTo _ownerUid) then {
				_targets pushBackUnique _x;
			};
		} forEach allPlayers;
	};

	private _inUseBy = _computer getVariable [QGVAR(inUseBy), ""];
	if (_inUseBy isNotEqualTo "") then {
		private _activeUser = [_computer] call FUNC(getActiveUser);
		if (toLowerANSI (_activeUser getOrDefault ["username", ""]) isEqualTo toLowerANSI (_user getOrDefault ["username", ""])) then {
			{
				if (getPlayerUID _x isEqualTo _inUseBy) then {
					_targets pushBackUnique _x;
				};
			} forEach allPlayers;
		};
	};

	if (_targets isNotEqualTo []) then {
		["mail", _fromEmail, _subject] remoteExecCall [QFUNC(showNotificationLocal), _targets];
	};
};

["Mail", "Delivering mail to registered computers", createHashMapFromArray [
	["fromEmail", _fromEmail],
	["toEmail", _toEmail],
	["fromUser", _fromName],
	["toUser", _toName],
	["ccNames", _ccNames],
	["subject", _subject],
	["computerCount", count (([] call FUNC(getRegisteredComputers)) select {!isNull _x})]
]] call FUNC(debugLog);

{
	private _computer = _x;
	private _data = _computer getVariable [QGVAR(data), createHashMap];
	private _users = _data getOrDefault ["users", []];
	private _changed = false;

	{
		private _user = _x;
		private _username = _user getOrDefault ["username", ""];
		if (_username isEqualTo _toName || {_username in _ccNames}) then {
			private _mail = _user getOrDefault ["mail", []];
			_mail pushBack +_message;
			_user set ["mail", _mail];

			if (_attachments isNotEqualTo []) then {
				private _files = _user getOrDefault ["files", []];
				{
					_files pushBack (+_x);
				} forEach _attachments;
				_user set ["files", _files];
			};
			_users set [_forEachIndex, _user];
			_changed = true;
			[_computer, _user] call _notifyUser;
		};

		if (_username isEqualTo _fromName) then {
			private _outboxMessage = +_message;
			_outboxMessage set ["read", true];
			private _outbox = _user getOrDefault ["outbox", []];
			_outbox pushBack _outboxMessage;
			_user set ["outbox", _outbox];
			_users set [_forEachIndex, _user];
			_changed = true;
		};
	} forEach _users;

	if (_changed) then {
		_data set ["users", _users];
		_computer setVariable [QGVAR(data), _data, true];
		["Mail", "Delivered mail on computer", createHashMapFromArray [
			["computer", _computer],
			["systemName", _data getOrDefault ["systemName", ""]],
			["fromUser", _fromName],
			["toUser", _toName],
			["ccNames", _ccNames]
		]] call FUNC(debugLog);
		private _display = uiNamespace getVariable [QGVAR(display), displayNull];
		if (!isNull _display) then {
			if (_computer isEqualTo (_display getVariable [QGVAR(computer), objNull])) then {
				_display setVariable [QGVAR(data), _data];
				private _activeUser = [_computer] call FUNC(getActiveUser);
				private _activeName = _activeUser getOrDefault ["username", ""];
				private _activeIndex = _users findIf {(_x getOrDefault ["username", ""]) isEqualTo _activeName};
				if (_activeIndex >= 0) then {
					private _updatedActiveUser = _users select _activeIndex;
					_computer setVariable [QGVAR(activeUser), _updatedActiveUser, true];
					_display setVariable [QGVAR(activeUser), _updatedActiveUser];
				};
			};
		};
	};
} forEach (([] call FUNC(getRegisteredComputers)) select {!isNull _x});

true
