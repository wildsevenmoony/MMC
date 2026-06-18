#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Hides or restores standard MMC apps on a computer or one user of a computer.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: App ids <STRING or ARRAY> ("files", "mail", "messages", "notes")
 * 2: Hidden <BOOL, default: true>
 * 3: Username <STRING, default: "">; empty changes the computer default
 *
 * Return Value:
 * Changed <BOOL>
 */

params [
	["_computer", objNull, [objNull]],
	["_apps", [], ["", []]],
	["_hidden", true, [false]],
	["_username", "", [""]]
];

if (isNull _computer) exitWith {false};

private _appIds = [_apps] call FUNC(normalizeStandardAppIds);
if (_appIds isEqualTo []) exitWith {false};

private _apply = {
	params ["_map", "_appIds", "_hidden"];
	private _disabled = [_map getOrDefault ["disabledApps", []]] call MMC_fnc_normalizeStandardAppIds;
	{
		if (_hidden) then {
			_disabled pushBackUnique _x;
		} else {
			private _index = _disabled find _x;
			while {_index >= 0} do {
				_disabled deleteAt _index;
				_index = _disabled find _x;
			};
		};
	} forEach _appIds;
	_map set ["disabledApps", _disabled];
	_map
};

private _changed = false;
private _data = _computer getVariable [QGVAR(data), createHashMap];

if (_username isEqualTo "") then {
	[_data, _appIds, _hidden] call _apply;
	_changed = true;
} else {
	private _users = _data getOrDefault ["users", []];
	private _lookup = toLowerANSI _username;
	private _index = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
	if (_index >= 0) then {
		private _user = _users select _index;
		[_user, _appIds, _hidden] call _apply;
		_users set [_index, _user];
		_data set ["users", _users];
		_changed = true;

		private _globalIndex = GVAR(registeredUsers) findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
		if (_globalIndex >= 0) then {
			GVAR(registeredUsers) set [_globalIndex, _user];
		};
	};
};

if (!_changed) exitWith {false};

_computer setVariable [QGVAR(data), _data, true];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (!isNull _display && {_computer isEqualTo (_display getVariable [QGVAR(computer), objNull])}) then {
	private _activeUser = [_computer] call FUNC(getActiveUser);
	private _currentApp = _display getVariable [QGVAR(currentApp), "desktop"];
	if (_currentApp in _appIds && {!([_computer, _currentApp, _activeUser] call FUNC(isStandardAppEnabled))}) then {
		["desktop"] call FUNC(renderApp);
	} else {
		[_display] call FUNC(refreshStandardApps);
		[_display] call FUNC(refreshAppButtons);
	};
};

true
