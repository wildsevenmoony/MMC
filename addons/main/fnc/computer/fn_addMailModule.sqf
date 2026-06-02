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

if (_objects isEqualTo []) then {
	_objects = synchronizedObjects _logic;
};

private _direction = _logic getVariable [QGVAR(mailDirection), "inbox"];
private _counterpart = _logic getVariable [QGVAR(mailCounterpart), _logic getVariable [QGVAR(mailFrom), "sender@mmc.local"]];
private _cc = _logic getVariable [QGVAR(mailCc), ""];
private _subject = _logic getVariable [QGVAR(mailSubject), "Mission Update"];
private _body = _logic getVariable [QGVAR(mailBody), "Mail body goes here."];
private _date = _logic getVariable [QGVAR(mailDate), ""];
private _time = _logic getVariable [QGVAR(mailTime), ""];
private _attachment = _logic getVariable [QGVAR(mailAttachment), ""];
private _attachmentDescription = _logic getVariable [QGVAR(mailAttachmentDescription), ""];
private _userModules = _objects select {_x getVariable [QGVAR(isUserModule), false]};

if (_userModules isNotEqualTo []) then {
	{
		private _userConfig = _x getVariable [QGVAR(userConfig), createHashMap];
		private _username = _userConfig getOrDefault ["username", ""];
		private _targets = (synchronizedObjects _x) select {_x getVariable [QGVAR(isComputer), false]};
		if (_targets isEqualTo []) then {
			_targets = if (GVAR(registeredComputers) isEqualType []) then {GVAR(registeredComputers)} else {[]};
		};

		{
			private _added = [_x, _username, _direction, _counterpart, _cc, _subject, _body, _date, _time, _attachment, _attachmentDescription] call FUNC(seedMail);
			if (!_added) then {
				diag_log format ["[MMC] Add Mail module failed for user '%1' on %2", _username, _x];
			};
		} forEach _targets;
	} forEach _userModules;
} else {
	private _from = _logic getVariable [QGVAR(mailFrom), _counterpart];
	private _to = _logic getVariable [QGVAR(mailTo), "operator@mmc.local"];
	private _dateTime = format ["%1 %2", _date, _time];
	{
		if (!isNull _x) then {
			[_x, _from, _to, _subject, _body, _dateTime] call FUNC(addMail);
		};
	} forEach (_objects select {_x getVariable [QGVAR(isComputer), false]});
};

if (!is3DEN) then {
	deleteVehicle _logic;
};

true
