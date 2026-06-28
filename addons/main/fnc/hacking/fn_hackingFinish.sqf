#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Applies a successful MMC hacking result.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Success <BOOL>
 *
 * Return Value:
 * Result applied <BOOL>
 */

params [
	["_display", displayNull, [displayNull]],
	["_success", false, [false]]
];

if (isNull _display || {!_success}) exitWith {false};

private _state = _display getVariable [QGVAR(hackingState), createHashMap];
if (count _state == 0) exitWith {false};

private _mode = _state getOrDefault ["mode", "login"];

["Hacking", "Hacking attempt succeeded", createHashMapFromArray [
	["mode", _mode],
	["target", _state getOrDefault ["targetLabel", ""]]
]] call FUNC(debugLog);

[_display, true, true] call FUNC(hackingClose);

private _computer = _display getVariable [QGVAR(computer), objNull];
if (isNull _computer) exitWith {false};

if (_mode isEqualTo "mobile") exitWith {
	private _expected = _display getVariable [QGVAR(mobileLockCode), missionNamespace getVariable [QGVAR(mobileLockCode), ""]];
	[_computer, _expected, _state getOrDefault ["hacker", player]] call FUNC(hackingRecordMobileCode);
	[_display, _expected] call FUNC(setMobileLockInput);
	call FUNC(unlockMobile);
	true
};

private _user = _state getOrDefault ["targetUser", createHashMap];
if (count _user == 0) exitWith {
	_display setVariable [QGVAR(hackingLastStatus), "Credential target vanished during crack."];
	[_display] call FUNC(hackingRenderAccountList);
	false
};

private _username = _user getOrDefault ["username", ""];
private _password = _user getOrDefault ["password", ""];
private _hacker = _state getOrDefault ["hacker", player];
private _knownCredentials = missionNamespace getVariable [QGVAR(hackingKnownCredentials), createHashMap];
if !(_knownCredentials isEqualType createHashMap) then {
	_knownCredentials = createHashMap;
};
_knownCredentials set [toLowerANSI _username, createHashMapFromArray [
	["username", _username],
	["password", _password]
]];
missionNamespace setVariable [QGVAR(hackingKnownCredentials), _knownCredentials];

private _data = _computer getVariable [QGVAR(data), _display getVariable [QGVAR(data), createHashMap]];
private _computerName = _data getOrDefault ["systemName", "Computer"];
if (_computerName isEqualTo "") then {
	_computerName = "Computer";
};
private _passwordLine = if (_password isEqualTo "") then {
	"No Password"
} else {
	format ["Password: %1", _password]
};
private _title = format ["Intrusion Report - %1", _username];
private _body = format [
	"MMC Intrusion Tool v3.5.6%1%1System: %2%1Account: %3%1%4%1%1Credential cached for future access.",
	toString [13, 10],
	_computerName,
	_username,
	_passwordLine
];
private _safeName = ((format ["%1_%2", _computerName, _username]) splitString " :/\") joinString "_";
[_computer, _title, _body, _hacker, format ["intrusion_%1.txt", _safeName]] call FUNC(hackingRecordReport);

_display setVariable [QGVAR(hackingLastStatus), format ["Credential cracked: %1", _username]];
["Hacking", "Saved cracked desktop credential", createHashMapFromArray [
	["username", _username]
]] call FUNC(debugLog);

[_display] call FUNC(hackingRenderAccountList);

true
