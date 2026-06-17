#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Script API for mission makers to link extra e-mail addresses to a player's mobile account.
 *
 * Arguments:
 * 0: Player, UID, player name, or unit variable name <OBJECT or STRING>
 * 1: Aliases <ARRAY or STRING>
 * 2: Replace existing aliases <BOOL, default: false>
 *
 * Return Value:
 * Request sent or aliases updated <BOOL>
 *
 * Example:
 * [player, ["bravo1-4@aaf.ass", "radio-watch@aaf.ass"]] call MMC_fnc_setMobileEmailAliases
 */

params [
	["_target", objNull, [objNull, ""]],
	["_aliases", [], [[], ""]],
	["_replace", false, [false]]
];

if (_aliases isEqualType "") then {
	_aliases = _aliases splitString ",";
};

if (!isServer) exitWith {
	[_target, _aliases, _replace] remoteExecCall [QFUNC(setMobileEmailAliases), 2];
	true
};

private _player = objNull;
if (_target isEqualType objNull) then {
	_player = _target;
} else {
	private _lookup = toLowerANSI _target;
	_player = (allPlayers select {
		toLowerANSI (getPlayerUID _x) isEqualTo _lookup
		|| {toLowerANSI (name _x) isEqualTo _lookup}
		|| {toLowerANSI (vehicleVarName _x) isEqualTo _lookup}
	}) param [0, objNull];
};

if (isNull _player) exitWith {false};

private _uid = getPlayerUID _player;
private _device = _player getVariable [QGVAR(mobileComputer), objNull];
if (isNull _device && {GVAR(mobileDevices) isEqualType createHashMap}) then {
	_device = GVAR(mobileDevices) getOrDefault [_uid, objNull];
};
if (isNull _device) exitWith {
	private _pending = _player getVariable [QGVAR(mobilePendingAliases), []];
	if (_replace) then {
		_pending = [];
	};
	{
		private _alias = [_x] call CBA_fnc_trim;
		if (_alias isNotEqualTo "") then {
			_pending pushBackUnique _alias;
		};
	} forEach _aliases;
	_player setVariable [QGVAR(mobilePendingAliases), _pending, true];
	true
};

private _data = _device getVariable [QGVAR(data), createHashMap];
private _username = _data getOrDefault ["autoLoginUsername", ""];
[_device, _username, _aliases, _replace] call FUNC(setUserEmailAliases)
