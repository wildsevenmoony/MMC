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
	["_attachment", "", [""]]
];

private _fromUser = [_fromEmail] call FUNC(findUserByEmail);
private _toUser = [_toEmail] call FUNC(findUserByEmail);
if (count _fromUser == 0 || {count _toUser == 0}) exitWith {false};

(call FUNC(formatMailDate)) params ["_date", "_time"];
private _message = createHashMapFromArray [
	["from", _fromEmail],
	["to", _toEmail],
	["subject", _subject],
	["body", _body],
	["date", _date],
	["time", _time],
	["attachment", _attachment],
	["read", false]
];

private _fromName = _fromUser getOrDefault ["username", ""];
private _toName = _toUser getOrDefault ["username", ""];

{
	private _computer = _x;
	private _data = _computer getVariable [QGVAR(data), createHashMap];
	private _users = _data getOrDefault ["users", []];
	private _changed = false;

	{
		private _user = _x;
		private _username = _user getOrDefault ["username", ""];
		if (_username isEqualTo _toName) then {
			private _mail = _user getOrDefault ["mail", []];
			_mail pushBack +_message;
			_user set ["mail", _mail];

			if (_attachment isNotEqualTo "") then {
				private _files = _user getOrDefault ["files", []];
				_files pushBack createHashMapFromArray [
					["name", format ["%1 attachment.jpg", _subject]],
					["type", "picture"],
					["path", format ["\Pictures\%1 attachment.jpg", _subject]],
					["content", format ["Attachment from: %1", _subject]],
					["texture", _attachment]
				];
				_user set ["files", _files];
			};
			_users set [_forEachIndex, _user];
			_changed = true;
		};

		if (_username isEqualTo _fromName) then {
			private _outbox = _user getOrDefault ["outbox", []];
			_outbox pushBack +_message;
			_user set ["outbox", _outbox];
			_users set [_forEachIndex, _user];
			_changed = true;
		};
	} forEach _users;

	if (_changed) then {
		_data set ["users", _users];
		_computer setVariable [QGVAR(data), _data, true];
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
} forEach (GVAR(registeredComputers) select {!isNull _x});

true
