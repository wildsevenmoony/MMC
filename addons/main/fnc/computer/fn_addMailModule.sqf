#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a configured email to synced MMC computers.
 */

private _logic = objNull;
private _objects = [];
private _activated = true;

if ((_this param [0, objNull]) isEqualType "") then {
	private _mode = _this param [0, "", [""]];
	private _input = _this param [1, [], [[]]];

	if !(_mode in ["init", "attributesChanged3DEN", "registeredToWorld3DEN", "connectionChanged3DEN"]) exitWith {true};

	_input params [
		["_logicInput", objNull, [objNull]],
		["_activatedInput", true, [true]]
	];

	_logic = _logicInput;
	_activated = _activatedInput;

	if (is3DEN) exitWith {true};
} else {
	_this params [
		["_logicInput", objNull, [objNull]],
		["_objectsInput", [], [[]]],
		["_activatedInput", true, [true]]
	];

	_logic = _logicInput;
	_objects = _objectsInput;
	_activated = _activatedInput;
};

if (!_activated || {isNull _logic}) exitWith {true};

_objects append (synchronizedObjects _logic);
_objects = _objects arrayIntersect _objects;

private _direction = _logic getVariable [QGVAR(mailDirection), "inbox"];
private _counterpart = _logic getVariable [QGVAR(mailCounterpart), _logic getVariable [QGVAR(mailFrom), "sender@mmc.local"]];
private _cc = _logic getVariable [QGVAR(mailCc), ""];
private _subject = _logic getVariable [QGVAR(mailSubject), "Mission Update"];
private _body = _logic getVariable [QGVAR(mailBody), "Mail body goes here."];
private _date = _logic getVariable [QGVAR(mailDate), ""];
private _time = _logic getVariable [QGVAR(mailTime), ""];
private _attachment = _logic getVariable [QGVAR(mailAttachment), ""];
private _attachmentDescription = _logic getVariable [QGVAR(mailAttachmentDescription), ""];
private _recipientRead = _logic getVariable [QGVAR(mailRecipientRead), false];
private _senderRead = _logic getVariable [QGVAR(mailSenderRead), true];
private _ccRead = _logic getVariable [QGVAR(mailCcRead), false];
private _profileModules = _objects select {
	private _type = typeOf _x;
	(_x getVariable [QGVAR(isMobileProfileModule), false]) || {_type in [QGVAR(mobileProfile), QGVAR(assignMobileProfile)]}
};
private _userModules = _objects select {_x getVariable [QGVAR(isUserModule), false]};

["Modules", "Add Mail module resolving targets", createHashMapFromArray [
	["module", _logic],
	["direction", _direction],
	["counterpart", _counterpart],
	["cc", _cc],
	["subject", _subject],
	["synced", _objects apply {format ["%1:%2", typeOf _x, _x]}],
	["profileModules", count _profileModules],
	["userModules", count _userModules]
]] call FUNC(debugLog);

{
	private _profile = _x getVariable [QGVAR(mobileProfileConfig), createHashMap];
	if !(_profile isEqualType createHashMap) then {
		_profile = createHashMap;
	};
	private _sourceModule = netId _logic;
	private _mails = _profile getOrDefault ["mails", []];
	_mails = _mails select {!(_x isEqualType createHashMap) || {_x getOrDefault ["sourceModule", ""] isNotEqualTo _sourceModule}};
	_mails pushBack createHashMapFromArray [
		["sourceModule", _sourceModule],
		["direction", _direction],
		["counterpart", _counterpart],
		["cc", _cc],
		["subject", _subject],
		["body", _body],
		["date", _date],
		["time", _time],
		["attachment", _attachment],
		["attachmentDescription", _attachmentDescription],
		["recipientRead", _recipientRead],
		["senderRead", _senderRead],
		["ccRead", _ccRead]
	];
	_profile set ["mails", _mails];
	_x setVariable [QGVAR(mobileProfileConfig), _profile, true];
	private _profileId = _profile getOrDefault ["id", _x getVariable [QGVAR(mobileProfileId), "mobile_profile"]];
	[_profileId, _profile] call FUNC(registerMobileProfile);
	[_profileId, _profile] remoteExecCall [QFUNC(registerMobileProfile), 0, format [QGVAR(mobileProfile_%1), _profileId]];
	["Modules", "Add Mail enriched mobile profile", createHashMapFromArray [
		["profileModule", _x],
		["profileId", _profileId],
		["subject", _subject],
		["mailCount", count _mails]
	]] call FUNC(debugLog);
} forEach _profileModules;

if (_userModules isNotEqualTo []) then {
	{
		private _userConfig = _x getVariable [QGVAR(userConfig), createHashMap];
		private _username = _userConfig getOrDefault ["username", ""];
		private _userSyncs = synchronizedObjects _x;
		private _targets = _userSyncs select {_x getVariable [QGVAR(isComputer), false]};
		private _registerModules = _userSyncs select {typeOf _x isEqualTo QGVAR(registerComputer)};
		{
			private _registeredObjects = _x getVariable [QGVAR(registeredComputerObjects), []];
			if (_registeredObjects isEqualTo []) then {
				_registeredObjects = (synchronizedObjects _x) select {!(_x isKindOf "Logic")};
			};
			_targets append _registeredObjects;
		} forEach _registerModules;
		_targets = _targets arrayIntersect _targets;
		if (_targets isEqualTo []) then {
			_targets = [] call FUNC(getRegisteredComputers);
		};

		{
			private _added = [_x, _username, _direction, _counterpart, _cc, _subject, _body, _date, _time, _attachment, _attachmentDescription, _recipientRead, _senderRead, _ccRead] call FUNC(seedMail);
			if (!_added) then {
				diag_log format ["[MMC] Add Mail module failed for user '%1' on %2", _username, _x];
			};
		} forEach _targets;
	} forEach _userModules;
} else {
	private _from = _logic getVariable [QGVAR(mailFrom), _counterpart];
	private _to = _logic getVariable [QGVAR(mailTo), "operator@mmc.local"];
	private _dateTime = format ["%1 %2", _date, _time];
	private _targets = _objects select {_x getVariable [QGVAR(isComputer), false]};
	private _registerModules = _objects select {typeOf _x isEqualTo QGVAR(registerComputer)};
	{
		private _registeredObjects = _x getVariable [QGVAR(registeredComputerObjects), []];
		if (_registeredObjects isEqualTo []) then {
			_registeredObjects = (synchronizedObjects _x) select {_x getVariable [QGVAR(isComputer), false]};
		};
		_targets append _registeredObjects;
	} forEach _registerModules;
	_targets = _targets arrayIntersect _targets;

	{
		private _target = _x;
		if (!isNull _target) then {
			private _data = _target getVariable [QGVAR(data), createHashMap];
			private _users = (_data getOrDefault ["users", []]) select {_x isEqualType createHashMap};
			if (_users isEqualTo []) then {
				[_target, _from, _to, _subject, _body, _dateTime, _cc, _attachment, _attachmentDescription] call FUNC(addMail);
			} else {
				{
					private _username = _x getOrDefault ["username", ""];
					if (_username isNotEqualTo "") then {
						[_target, _username, _direction, _counterpart, _cc, _subject, _body, _date, _time, _attachment, _attachmentDescription, _recipientRead, _senderRead, _ccRead] call FUNC(seedMail);
					};
				} forEach _users;
			};
		};
	} forEach _targets;
};

if (!is3DEN) then {
	deleteVehicle _logic;
};

true
