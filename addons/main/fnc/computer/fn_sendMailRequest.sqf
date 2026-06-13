#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Validates and sends a composed email on the server, then reports the result to the requesting player.
 *
 * Arguments:
 * 0: Requesting player <OBJECT>
 * 1: Active computer <OBJECT>
 * 2: Sender email <STRING>
 * 3: Recipient email <STRING>
 * 4: Subject <STRING>
 * 5: Body <STRING>
 * 6: Attachment path <STRING>
 * 7: CC list <STRING>
 * 8: Attachment description <STRING>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [
	["_player", objNull, [objNull]],
	["_computer", objNull, [objNull]],
	["_fromEmail", "", [""]],
	["_toEmail", "", [""]],
	["_subject", "", [""]],
	["_body", "", [""]],
	["_attachment", "", [""]],
	["_cc", "", [""]],
	["_attachmentDescription", "", [""]]
];

if (!isServer || {isNull _player}) exitWith {};

_fromEmail = [_fromEmail] call CBA_fnc_trim;
_toEmail = [_toEmail] call CBA_fnc_trim;
_attachment = [_attachment] call CBA_fnc_trim;
_cc = [_cc] call CBA_fnc_trim;

private _success = false;
private _message = "";

if (_fromEmail isEqualTo "") exitWith {
	[false, "No sender account is active.", _computer, createHashMap] remoteExecCall [QFUNC(mailSendResult), _player];
};

if (_toEmail isEqualTo "") exitWith {
	[false, "Enter a recipient address.", _computer, createHashMap] remoteExecCall [QFUNC(mailSendResult), _player];
};

if (count ([_toEmail] call FUNC(findUserByEmail)) == 0) exitWith {
	[false, "Recipient address does not exist.", _computer, createHashMap] remoteExecCall [QFUNC(mailSendResult), _player];
};

if (_subject isEqualTo "") exitWith {
	[false, "Enter a subject.", _computer, createHashMap] remoteExecCall [QFUNC(mailSendResult), _player];
};

if (_body isEqualTo "") exitWith {
	[false, "Enter a message.", _computer, createHashMap] remoteExecCall [QFUNC(mailSendResult), _player];
};

if (_attachment isNotEqualTo "" && {!fileExists _attachment}) exitWith {
	[false, "Attachment file does not exist.", _computer, createHashMap] remoteExecCall [QFUNC(mailSendResult), _player];
};

_success = [_fromEmail, _toEmail, _subject, _body, _attachment, _cc, _attachmentDescription] call FUNC(sendMail);
_message = ["Could not send mail.", "Mail sent."] select _success;
private _computerData = if (!isNull _computer) then {
	_computer getVariable [QGVAR(data), createHashMap]
} else {
	createHashMap
};

[_success, _message, _computer, _computerData] remoteExecCall [QFUNC(mailSendResult), _player];
