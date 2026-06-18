#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Returns the Messenger identity for a specific stored user on a registered MMC computer.
 *
 * Arguments:
 * 0: Computer or mobile logic object <OBJECT>
 * 1: User data <HASHMAP>
 *
 * Return Value:
 * Identity data <HASHMAP>
 */

params [
	["_object", objNull, [objNull]],
	["_user", createHashMap, [createHashMap]]
];

if (isNull _object || {count _user == 0}) exitWith {createHashMap};

private _data = _object getVariable [QGVAR(data), createHashMap];
private _username = _user getOrDefault ["username", ""];
if (_username isEqualTo "") exitWith {createHashMap};

private _netId = netId _object;
if (_netId isEqualTo "") then {
	_netId = str _object;
};

private _name = _user getOrDefault ["messengerName", _user getOrDefault ["displayName", ""]];
if (_name isEqualTo "") then {
	_name = _username;
};

private _sideText = _user getOrDefault ["messengerSide", _user getOrDefault ["side", ""]];
if (_sideText isEqualTo "") then {
	_sideText = _object getVariable [QGVAR(messengerSide), _data getOrDefault ["messengerSide", ""]];
};
if (_sideText isEqualTo "") then {
	private _layout = _user getOrDefault ["customLayout", createHashMap];
	if !(_layout isEqualType createHashMap) then {
		_layout = createHashMap;
	};
	if (count _layout == 0) then {
		_layout = _data getOrDefault ["layout", createHashMap];
		if !(_layout isEqualType createHashMap) then {
			_layout = createHashMap;
		};
	};
	_sideText = [_user getOrDefault ["theme", ""], _layout] call FUNC(getMessengerSideFromTheme);
};

createHashMapFromArray [
	["id", format ["%1:%2", _netId, _username]],
	["name", _name],
	["side", _sideText],
	["object", _object],
	["user", _user],
	["username", _username],
	["email", _user getOrDefault ["email", ""]],
	["isMobile", _object getVariable [QGVAR(isMobileComputer), false]]
]
