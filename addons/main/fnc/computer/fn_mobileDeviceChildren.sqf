#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Builds dynamic ACE self-action children for carried MMC mobile devices.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * ACE action children <ARRAY>
 */

if (call FUNC(ensureUniqueMobileDevicesLocal)) exitWith {
	private _action = [
		QGVAR(preparingMobileDevices),
		"Preparing mobile device...",
		"",
		{},
		{false}
	] call ace_interact_menu_fnc_createAction;
	[[_action, [], objNull]]
};

private _devices = [] call FUNC(getMobileInventoryDevices);
private _actions = [];

if (_devices isEqualTo []) exitWith {
	private _action = [
		QGVAR(noMobileDevices),
		"No mobile devices",
		"",
		{},
		{false}
	] call ace_interact_menu_fnc_createAction;
	[[_action, [], objNull]]
};

{
	private _device = _x;
	private _label = _device getOrDefault ["label", "Mobile Device"];
	private _source = _device getOrDefault ["source", "personal"];
	private _suffix = ["", " (Picked up)"] select (_source isEqualTo "picked");
	private _actionId = format ["MMC_main_openMobile_%1_%2", _device getOrDefault ["id", "device"], _forEachIndex];

	private _action = [
		_actionId,
		format ["Open %1%2", _label, _suffix],
		_device getOrDefault ["icon", "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa"],
		{
			params ["_target", "_player", "_params"];
			_params params [["_device", createHashMap, [createHashMap]]];
			[_device] call MMC_fnc_openMobile;
		},
		{true},
		{},
		[_device],
		[0, 0, 0],
		100,
		[false, false, false, false, true]
	] call ace_interact_menu_fnc_createAction;

	_actions pushBack [_action, [], player];
} forEach _devices;

_actions
