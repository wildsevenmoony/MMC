#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Sends a Messenger message between registered MMC devices.
 *
 * Arguments:
 * 0: Sender identity id <STRING>
 * 1: Sender display name <STRING>
 * 2: Recipient identity id <STRING>
 * 3: Recipient display name <STRING>
 * 4: Message body <STRING>
 * 5: Sender metadata <HASHMAP, default: empty>
 * 6: Recipient metadata <HASHMAP, default: empty>
 *
 * Return Value:
 * Sent <BOOL>
 */

params [
	["_fromId", "", [""]],
	["_fromName", "Unknown", [""]],
	["_toId", "", [""]],
	["_toName", "Unknown", [""]],
	["_body", "", [""]],
	["_fromMeta", createHashMap, [createHashMap]],
	["_toMeta", createHashMap, [createHashMap]]
];

_body = [_body] call CBA_fnc_trim;
if (_fromId isEqualTo "" || {_toId isEqualTo "" || {_body isEqualTo ""}}) exitWith {false};

if (!isServer) exitWith {
	private _localMessages = missionNamespace getVariable [QGVAR(messengerMessages), GVAR(messengerMessages)];
	if !(_localMessages isEqualType []) then {
		_localMessages = [];
	};
	private _dateTime = [] call FUNC(formatMailDate);
	_localMessages pushBack createHashMapFromArray [
		["id", format ["local_msg_%1_%2", diag_tickTime, floor random 100000]],
		["from", _fromId],
		["fromName", _fromName],
		["fromEmail", _fromMeta getOrDefault ["email", ""]],
		["fromUsername", _fromMeta getOrDefault ["username", ""]],
		["to", _toId],
		["toName", _toName],
		["toEmail", _toMeta getOrDefault ["email", ""]],
		["toUsername", _toMeta getOrDefault ["username", ""]],
		["body", _body],
		["date", _dateTime select 0],
		["time", _dateTime select 1]
	];
	missionNamespace setVariable [QGVAR(messengerMessages), _localMessages, false];
	_this remoteExecCall [QFUNC(sendMessengerMessage), 2];
	true
};

if !(GVAR(messengerMessages) isEqualType []) then {
	GVAR(messengerMessages) = [];
};

private _dateTime = [] call FUNC(formatMailDate);
private _message = createHashMapFromArray [
	["id", format ["msg_%1_%2", diag_tickTime, floor random 100000]],
	["from", _fromId],
	["fromName", _fromName],
	["fromEmail", _fromMeta getOrDefault ["email", ""]],
	["fromUsername", _fromMeta getOrDefault ["username", ""]],
	["to", _toId],
	["toName", _toName],
	["toEmail", _toMeta getOrDefault ["email", ""]],
	["toUsername", _toMeta getOrDefault ["username", ""]],
	["body", _body],
	["date", _dateTime select 0],
	["time", _dateTime select 1]
];

GVAR(messengerMessages) pushBack _message;
missionNamespace setVariable [QGVAR(messengerMessages), GVAR(messengerMessages), true];
[GVAR(messengerMessages)] remoteExecCall [QFUNC(syncMessengerMessagesLocal), 0];

private _notifyTargets = [];
private _targetObject = _toMeta getOrDefault ["object", objNull];
if (!isNull _targetObject) then {
	private _ownerUid = _targetObject getVariable [QGVAR(mobileOwnerUid), ""];
	if (_ownerUid isNotEqualTo "") then {
		{
			if (getPlayerUID _x isEqualTo _ownerUid) then {
				_notifyTargets pushBackUnique _x;
			};
		} forEach allPlayers;
	};

	private _inUseBy = _targetObject getVariable [QGVAR(inUseBy), ""];
	if (_inUseBy isNotEqualTo "") then {
		{
			if (getPlayerUID _x isEqualTo _inUseBy) then {
				_notifyTargets pushBackUnique _x;
			};
		} forEach allPlayers;
	};
};
if (_notifyTargets isNotEqualTo []) then {
	["message", _fromName, _body] remoteExecCall [QFUNC(showNotificationLocal), _notifyTargets];
};

["Messenger", "Message sent", createHashMapFromArray [
	["from", _fromName],
	["to", _toName],
	["bodyLength", count _body],
	["messageCount", count GVAR(messengerMessages)]
]] call FUNC(debugLog);

true
