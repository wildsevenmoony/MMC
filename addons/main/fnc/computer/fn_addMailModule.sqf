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

private _from = _logic getVariable [QGVAR(mailFrom), "sender@mmc.local"];
private _to = _logic getVariable [QGVAR(mailTo), "operator@mmc.local"];
private _subject = _logic getVariable [QGVAR(mailSubject), "Mission Update"];
private _body = _logic getVariable [QGVAR(mailBody), "Mail body goes here."];
private _date = _logic getVariable [QGVAR(mailDate), "2035-06-01 08:00"];

{
	if (!isNull _x) then {
		[_x, _from, _to, _subject, _body, _date] call FUNC(addMail);
	};
} forEach _objects;

if (!is3DEN) then {
	deleteVehicle _logic;
};

true
