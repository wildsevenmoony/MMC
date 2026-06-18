#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Returns the Messenger identity for a registered MMC computer or mobile device.
 *
 * Arguments:
 * 0: Computer or mobile logic object <OBJECT>
 *
 * Return Value:
 * Identity data <HASHMAP>
 */

params [["_object", objNull, [objNull]]];

if (isNull _object) exitWith {createHashMap};

private _data = _object getVariable [QGVAR(data), createHashMap];
private _user = [_object] call FUNC(getActiveUser);
if (count _user > 0) exitWith {
	[_object, _user] call FUNC(getMessengerIdentityForUser)
};

private _id = _object getVariable [QGVAR(messengerId), ""];
if (_id isEqualTo "") then {
	private _netId = netId _object;
	if (_netId isEqualTo "") then {
		_netId = str _object;
	};
	_id = format ["%1:%2", _netId, _user getOrDefault ["username", _data getOrDefault ["autoLoginUsername", "device"]]];
	_object setVariable [QGVAR(messengerId), _id, true];
};

private _name = _user getOrDefault ["messengerName", _user getOrDefault ["displayName", ""]];
if (_name isEqualTo "") then {
	_name = _object getVariable [QGVAR(messengerName), ""];
};
if (_name isEqualTo "") then {
	_name = _user getOrDefault ["username", ""];
};
if (_name isEqualTo "") then {
	_name = _data getOrDefault ["systemName", _object getVariable [QGVAR(mobileDeviceLabel), typeOf _object]];
};

private _sideText = _object getVariable [QGVAR(messengerSide), ""];
if (_sideText isEqualTo "") then {
	_sideText = _user getOrDefault ["messengerSide", _user getOrDefault ["side", _data getOrDefault ["messengerSide", ""]]];
};
if (_sideText isEqualTo "") then {
	private _layout = _data getOrDefault ["layout", createHashMap];
	if !(_layout isEqualType createHashMap) then {
		_layout = createHashMap;
	};
	_sideText = [_user getOrDefault ["theme", _data getOrDefault ["theme", ""]], _layout] call FUNC(getMessengerSideFromTheme);
};

createHashMapFromArray [
	["id", _id],
	["name", _name],
	["side", _sideText],
	["object", _object],
	["user", _user],
	["isMobile", _object getVariable [QGVAR(isMobileComputer), false]]
]
