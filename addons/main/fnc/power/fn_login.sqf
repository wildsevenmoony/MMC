#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Attempts to log in to the active MMC computer.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

if (_display getVariable [QGVAR(mobileLockScreen), false]) exitWith {
	call FUNC(unlockMobile);
};

private _computer = _display getVariable [QGVAR(computer), objNull];
if (isNull _computer || {!(_computer getVariable [QGVAR(poweredOn), true])}) exitWith {};

private _data = _computer getVariable [QGVAR(data), _display getVariable [QGVAR(data), createHashMap]];
_display setVariable [QGVAR(data), _data];

private _username = ctrlText (_display displayCtrl IDC_MMC_LOGIN_USERNAME);
private _password = if (_display getVariable [QGVAR(passwordVisible), false]) then {
	ctrlText (_display displayCtrl IDC_MMC_LOGIN_PASSWORD_VISIBLE)
} else {
	_display getVariable [QGVAR(loginPassword), ""]
};
private _error = _display displayCtrl IDC_MMC_LOGIN_ERROR;
private _setError = {
	params ["_text"];
	_error ctrlSetStructuredText parseText format ["<t align='center' size='1.08' font='RobotoCondensedBold'>%1</t>", _text];
};

if (_username isEqualTo "") exitWith {
	["Enter a username."] call _setError;
};

private _users = _data getOrDefault ["users", []];
private _closedSystem = _data getOrDefault ["closedSystem", false];
private _lookup = toLowerANSI _username;
private _knownIndex = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
private _user = createHashMap;

if (_knownIndex >= 0) then {
	_user = _users select _knownIndex;
};

if (count _user == 0) exitWith {
	[["Unknown user.", "Unknown user on closed system."] select _closedSystem] call _setError;
};

if ((_user getOrDefault ["password", ""]) isNotEqualTo _password) exitWith {
	["Invalid password."] call _setError;
};

_computer setVariable [QGVAR(activeUser), _user, true];
_display setVariable [QGVAR(activeUser), _user];

[_display] call FUNC(applyTheme);
[_display] call FUNC(hideLogin);
["desktop"] call FUNC(renderApp);
