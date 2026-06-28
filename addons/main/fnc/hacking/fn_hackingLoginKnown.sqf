#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Logs into a desktop account if the local hacker has already cracked it.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Username <STRING>
 *
 * Return Value:
 * Logged in <BOOL>
 */

params [
	["_display", displayNull, [displayNull]],
	["_username", "", [""]]
];

if (isNull _display || {_username isEqualTo ""}) exitWith {false};

private _computer = _display getVariable [QGVAR(computer), objNull];
if (isNull _computer) exitWith {false};

private _data = _computer getVariable [QGVAR(data), _display getVariable [QGVAR(data), createHashMap]];
private _lookup = toLowerANSI _username;
private _users = (_data getOrDefault ["users", []]) select {
	_x isEqualType createHashMap
	&& {(_x getOrDefault ["scope", "global"]) isEqualTo "direct"}
};
private _index = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo _lookup};
if (_index < 0) exitWith {
	_display setVariable [QGVAR(hackingLastStatus), "Cached user is not linked to this terminal."];
	[_display] call FUNC(hackingRenderAccountList);
	false
};

private _user = _users select _index;
private _knownCredentials = missionNamespace getVariable [QGVAR(hackingKnownCredentials), createHashMap];
private _hasKnown = _lookup in keys _knownCredentials;
private _known = createHashMap;
if (_hasKnown) then {
	_known = _knownCredentials get _lookup;
};
if (
	!_hasKnown
	|| {!(_known isEqualType createHashMap)}
	|| {(_known getOrDefault ["password", ""]) isNotEqualTo (_user getOrDefault ["password", ""])}
) exitWith {
	_display setVariable [QGVAR(hackingLastStatus), "Cached credential no longer matches."];
	[_display] call FUNC(hackingRenderAccountList);
	false
};

["Hacking", "Logging in with cracked credential", createHashMapFromArray [
	["username", _username]
]] call FUNC(debugLog);

[_display, true, true] call FUNC(hackingClose);
_computer setVariable [QGVAR(activeUser), _user, true];
_display setVariable [QGVAR(activeUser), _user];

[_display] call FUNC(applyTheme);
[_display] call FUNC(hideLogin);
["desktop"] call FUNC(renderApp);

true
