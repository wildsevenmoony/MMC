#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Builds dynamic ACE Zeus child actions for all registered MMC computers.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * ACE action children <ARRAY>
 */

private _actions = [];
private _computers = ([] call FUNC(getRegisteredComputers)) select {
	!isNull _x
	&& {_x getVariable [QGVAR(isComputer), false]}
};

if (_computers isEqualTo []) exitWith {
	private _action = [
		QGVAR(zeusNoComputers),
		"No registered computers",
		"",
		{},
		{false}
	] call ace_interact_menu_fnc_createAction;
	[[_action, [], objNull]]
};

private _entries = [];
{
	private _name = vehicleVarName _x;
	if (_name isEqualTo "") then {
		_name = getText (configOf _x >> "displayName");
	};
	if (_name isEqualTo "") then {
		_name = typeOf _x;
	};

	_entries pushBack [format ["%1_%2", toLowerANSI _name, _forEachIndex], _name, _x];
} forEach _computers;
_entries sort true;

{
	_x params ["_sortName", "_name", "_computer"];

	private _status = if (!alive _computer || {_computer getVariable [QGVAR(destroyed), false]}) then {
		"Destroyed"
	} else {
		if (_computer getVariable [QGVAR(booting), false]) then {
			"Booting"
		} else {
			["Off", "On"] select (_computer getVariable [QGVAR(poweredOn), true])
		}
	};

	private _inUseBy = _computer getVariable [QGVAR(inUseBy), ""];
	private _useText = [" | In use", ""] select (_inUseBy isEqualTo "");
	private _label = format ["%1 [%2%3] %4", _name, _status, _useText, mapGridPosition _computer];
	private _actionId = format ["MMC_main_zeusOpenComputer_%1", _forEachIndex];

	private _action = [
		_actionId,
		_label,
		"\a3\ui_f\data\igui\cfg\simpleTasks\types\computer_ca.paa",
		{
			params ["_target", "_player", "_params"];
			_params params [["_computer", objNull, [objNull]]];
			[_computer] call MMC_fnc_openFromZeus;
		},
		{
			params ["_target", "_player", "_params"];
			_params params [["_computer", objNull, [objNull]]];
			!isNull _computer
			&& {_computer getVariable ["MMC_main_isComputer", false]}
			&& {alive _computer}
			&& {!(_computer getVariable ["MMC_main_destroyed", false])}
		},
		{},
		[_computer],
		[0, 0, 0],
		100,
		[false, false, false, false, true]
	] call ace_interact_menu_fnc_createAction;

	_actions pushBack [_action, [], _computer];
} forEach _entries;

_actions
