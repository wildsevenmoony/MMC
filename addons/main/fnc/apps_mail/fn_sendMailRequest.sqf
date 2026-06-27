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
 * 9: Attachments <ARRAY>
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
	["_attachmentDescription", "", [""]],
	["_attachments", [], [[]]]
];

if (!isServer || {isNull _player}) exitWith {};

_fromEmail = [_fromEmail] call CBA_fnc_trim;
_toEmail = [_toEmail] call CBA_fnc_trim;
_attachment = [_attachment] call CBA_fnc_trim;
_cc = [_cc] call CBA_fnc_trim;
_attachments = [_attachment, _attachmentDescription, _attachments] call FUNC(mailNormalizeAttachments);

["Mail", "Send mail request received", createHashMapFromArray [
	["player", format ["%1:%2", name _player, getPlayerUID _player]],
	["computer", _computer],
	["from", _fromEmail],
	["to", _toEmail],
	["cc", _cc],
	["subject", _subject],
	["attachmentCount", count _attachments]
]] call FUNC(debugLog);

if (_fromEmail isEqualTo "") exitWith {
	["Mail", "Send mail rejected", createHashMapFromArray [["reason", "missing sender"], ["to", _toEmail]]] call FUNC(debugLog);
	[false, "No sender account is active.", _computer, createHashMap] remoteExecCall [QFUNC(mailSendResult), _player];
};

if (_toEmail isEqualTo "") exitWith {
	["Mail", "Send mail rejected", createHashMapFromArray [["reason", "missing recipient"], ["from", _fromEmail]]] call FUNC(debugLog);
	[false, "Enter a recipient address.", _computer, createHashMap] remoteExecCall [QFUNC(mailSendResult), _player];
};

if (count ([_toEmail] call FUNC(findUserByEmail)) == 0) exitWith {
	["Mail", "Send mail rejected", createHashMapFromArray [["reason", "recipient not found"], ["from", _fromEmail], ["to", _toEmail]]] call FUNC(debugLog);
	[false, "Recipient address does not exist.", _computer, createHashMap] remoteExecCall [QFUNC(mailSendResult), _player];
};

if (_subject isEqualTo "") exitWith {
	["Mail", "Send mail rejected", createHashMapFromArray [["reason", "missing subject"], ["from", _fromEmail], ["to", _toEmail]]] call FUNC(debugLog);
	[false, "Enter a subject.", _computer, createHashMap] remoteExecCall [QFUNC(mailSendResult), _player];
};

if (_body isEqualTo "") exitWith {
	["Mail", "Send mail rejected", createHashMapFromArray [["reason", "missing body"], ["from", _fromEmail], ["to", _toEmail]]] call FUNC(debugLog);
	[false, "Enter a message.", _computer, createHashMap] remoteExecCall [QFUNC(mailSendResult), _player];
};

if (_attachments isEqualTo [] && {_attachment isNotEqualTo "" && {!fileExists _attachment}}) exitWith {
	["Mail", "Send mail rejected", createHashMapFromArray [["reason", "missing attachment"], ["attachment", _attachment]]] call FUNC(debugLog);
	[false, "Attachment file does not exist.", _computer, createHashMap] remoteExecCall [QFUNC(mailSendResult), _player];
};

private _success = [_fromEmail, _toEmail, _subject, _body, _attachment, _cc, _attachmentDescription, _attachments] call FUNC(sendMail);
private _message = ["Could not send mail.", "Mail sent."] select _success;
["Mail", "Send mail result", createHashMapFromArray [
	["success", _success],
	["from", _fromEmail],
	["to", _toEmail],
	["cc", _cc],
	["subject", _subject]
]] call FUNC(debugLog);
private _computerData = if (isNull _computer) then {
	createHashMap
} else {
	_computer getVariable [QGVAR(data), createHashMap]
};

[_success, _message, _computer, _computerData] remoteExecCall [QFUNC(mailSendResult), _player];
