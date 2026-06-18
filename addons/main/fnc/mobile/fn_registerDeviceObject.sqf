#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Registers a placeable MMC phone or tablet object as a compact computer.
 *
 * Arguments:
 * 0: Device object, or CBA init event arguments <OBJECT or ARRAY>
 *
 * Return Value:
 * Registered <BOOL>
 */

private _object = objNull;
if (_this isEqualType objNull) then {
	_object = _this;
} else {
	if (_this isEqualType [] && {_this isNotEqualTo []}) then {
		_object = _this param [0, objNull, [objNull]];
	};
};

if (isNull _object) exitWith {false};
if (!isServer || {is3DEN}) exitWith {false};

[_object] spawn {
	params [["_object", objNull, [objNull]]];

	if (isNull _object) exitWith {};
	uiSleep 0.1;
	if (isNull _object) exitWith {};

	private _loginRequired = _object getVariable [QGVAR(loginRequired), false];
	private _username = [_object getVariable [QGVAR(userName), "operator"]] call CBA_fnc_trim;
	if (_username isEqualTo "") then {
		_username = "operator";
	};

	private _email = [_object getVariable [QGVAR(userEmail), ""]] call CBA_fnc_trim;
	if (_email isEqualTo "") then {
		_email = format ["%1@mmcsystems.com", toLowerANSI _username];
	};

	private _password = _object getVariable [QGVAR(userPassword), ""];
	private _theme = _object getVariable [QGVAR(userTheme), "default"];
	private _disabledApps = [_object] call FUNC(getDisabledAppsFromConfig);
	private _messengerSide = _object getVariable [QGVAR(messengerSide), ""];
	private _messengerVisible = _messengerSide isNotEqualTo "";
	private _messengerName = [_object getVariable [QGVAR(messengerName), ""]] call CBA_fnc_trim;
	if (_messengerName isEqualTo "") then {
		_messengerName = _username;
	};
	private _deviceType = [typeOf _object] call FUNC(getMobileDeviceType);
	private _orientation = _deviceType getOrDefault ["orientation", "horizontal"];

	private _config = createHashMapFromArray [
		["poweredOn", _object getVariable [QGVAR(poweredOn), true]],
		["loginRequired", _loginRequired],
		["closedSystem", _object getVariable [QGVAR(closedSystem), true]],
		["systemName", _object getVariable [QGVAR(systemName), "MMC Mobile Device"]],
		["messengerName", _messengerName],
		["messengerSide", _messengerSide],
		["disabledApps", _disabledApps]
	];

	if (!_loginRequired) then {
		_config set ["autoLoginUsername", _username];
	};

	_object setVariable [QGVAR(isMobileComputer), true, true];
	_object setVariable [QGVAR(mobileDefaultOrientation), _orientation, true];
	[_object, _config] call FUNC(registerObject);
	[_object, _username, _password, _email, _theme, createHashMap, "direct", _disabledApps, createHashMapFromArray [
		["displayName", _messengerName],
		["messengerName", _messengerName],
		["side", ["hidden", _messengerSide] select _messengerVisible],
		["messengerSide", ["hidden", _messengerSide] select _messengerVisible]
	]] call FUNC(addUser);
	if (_messengerSide isNotEqualTo "") then {
		private _data = _object getVariable [QGVAR(data), createHashMap];
		private _users = _data getOrDefault ["users", []];
		private _userIndex = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username};
		if (_userIndex >= 0) then {
			private _user = _users select _userIndex;
			_user set ["side", _messengerSide];
			_user set ["messengerSide", _messengerSide];
			_user set ["displayName", _messengerName];
			_user set ["messengerName", _messengerName];
			_users set [_userIndex, _user];
			_data set ["users", _users];
			_object setVariable [QGVAR(data), _data, true];
			_object setVariable [QGVAR(messengerSide), _messengerSide, true];
			_object setVariable [QGVAR(messengerName), _messengerName, true];
		};
	};
	[_object] call FUNC(ensureAutoLoginUser);
	[_object] remoteExecCall [QFUNC(addDevicePickupActionLocal), 0, _object];

	private _screenState = if (_object getVariable [QGVAR(poweredOn), true]) then {
		["desktop", "login"] select (_loginRequired)
	} else {
		"powered_off"
	};
	[_object, _screenState] call FUNC(setScreenState);
};

true
