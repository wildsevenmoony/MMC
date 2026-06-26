#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Attempts to unlock the active mobile MMC device.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Unlocked <BOOL>
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};
if !(_display getVariable [QGVAR(mobileLockScreen), false]) exitWith {false};

private _onlyDigits = {
	params [["_value", "", ["", 0]]];
	private _digits = toArray "0123456789";
	if !(_value isEqualType "") then {
		_value = str _value;
	};
	toString ((toArray _value) select {_x in _digits})
};

private _expected = [_display getVariable [QGVAR(mobileLockCode), missionNamespace getVariable [QGVAR(mobileLockCode), ""]]] call _onlyDigits;
private _input = if (_display getVariable [QGVAR(passwordVisible), false]) then {
	ctrlText (_display displayCtrl IDC_MMC_LOGIN_PASSWORD_VISIBLE)
} else {
	_display getVariable [QGVAR(loginPassword), ""]
};
_input = [_input] call _onlyDigits;

private _lockMap = _display getVariable [QGVAR(mobileLockControlMap), createHashMap];
private _error = _lockMap getOrDefault ["error", _display displayCtrl IDC_MMC_LOGIN_ERROR];
private _valid = (_expected isEqualTo "") || {_input isEqualTo _expected};
if (!_valid) exitWith {
	if (!isNull _error) then {
		_error ctrlSetStructuredText parseText "<t align='center' size='1.05' font='RobotoCondensedBold'>Invalid code.</t>";
	};
	["Mobile", "Mobile unlock rejected", createHashMapFromArray [
		["source", _display getVariable [QGVAR(mobileLockCodeSource), "clientSetting"]],
		["inputLength", count toArray _input],
		["expectedLength", count toArray _expected]
	]] call FUNC(debugLog);
	false
};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _data = _computer getVariable [QGVAR(data), _display getVariable [QGVAR(data), createHashMap]];
private _activeUser = [_computer] call FUNC(getActiveUser);
private _loginRequired = _data getOrDefault ["loginRequired", true];

_display setVariable [QGVAR(mobileLockScreen), false];
_display setVariable [QGVAR(mobileUnlocked), true];
_computer setVariable [QGVAR(mobileUnlocked), true];

{
	if (!isNull _x) then {
		ctrlDelete _x;
	};
} forEach (_display getVariable [QGVAR(mobileLockControls), []]);
_display setVariable [QGVAR(mobileLockControls), []];
_display setVariable [QGVAR(mobileLockControlMap), createHashMap];
_display setVariable [QGVAR(mobileLockInput), ""];
_display setVariable [QGVAR(loginPassword), ""];

["Mobile", "Mobile device unlocked", createHashMapFromArray [
	["device", _computer],
	["source", _display getVariable [QGVAR(mobileLockCodeSource), "clientSetting"]],
	["loginRequired", _loginRequired],
	["hasActiveUser", count _activeUser > 0]
]] call FUNC(debugLog);

if (count _activeUser == 0) then {
	if (_loginRequired) then {
		[_display] call FUNC(showLogin);
	} else {
		[_display] call FUNC(showNoUser);
	};
} else {
	[_display] call FUNC(hideLogin);
	["desktop"] call FUNC(renderApp);
};

if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
	[_display] call FUNC(applyMobileDisplayLayout);
};

true
