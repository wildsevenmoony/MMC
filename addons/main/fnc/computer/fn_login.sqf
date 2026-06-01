#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Attempts to log in to the active MMC computer.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _data = _display getVariable [QGVAR(data), createHashMap];
if (isNull _computer || {!(_computer getVariable [QGVAR(poweredOn), true])}) exitWith {};

private _username = ctrlText (_display displayCtrl IDC_MMC_LOGIN_USERNAME);
private _password = ctrlText (_display displayCtrl IDC_MMC_LOGIN_PASSWORD);
private _error = _display displayCtrl IDC_MMC_LOGIN_ERROR;

if (_username isEqualTo "") exitWith {
	_error ctrlSetText "Enter a username.";
};

private _users = _data getOrDefault ["users", []];
private _closedSystem = _data getOrDefault ["closedSystem", false];
private _lookup = toLowerANSI _username;
private _knownIndex = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
private _user = createHashMap;

if (_knownIndex >= 0) then {
	_user = _users select _knownIndex;
} else {
	private _profileUser = [] call FUNC(createProfileUser);
	if (!_closedSystem && {toLowerANSI (_profileUser getOrDefault ["username", ""]) isEqualTo _lookup}) then {
		_user = _profileUser;
	};
};

if (count _user == 0) exitWith {
	_error ctrlSetText (["Unknown user.", "Unknown user on closed system."] select _closedSystem);
};

if ((_user getOrDefault ["password", ""]) isNotEqualTo _password) exitWith {
	_error ctrlSetText "Invalid password.";
};

_computer setVariable [QGVAR(activeUser), _user, true];
_display setVariable [QGVAR(activeUser), _user];

[_display] call FUNC(hideLogin);
["desktop"] call FUNC(renderApp);
