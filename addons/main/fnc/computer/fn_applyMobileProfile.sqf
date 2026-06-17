#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Applies server-side data from a mobile profile to a personal mobile computer.
 *
 * Arguments:
 * 0: Mobile computer object <OBJECT>
 * 1: Player <OBJECT>
 * 2: Mobile profile <HASHMAP>
 * 3: Username <STRING>
 * 4: Apply seeded content <BOOL, default: true>
 *
 * Return Value:
 * Applied <BOOL>
 */

params [
	["_device", objNull, [objNull]],
	["_player", objNull, [objNull]],
	["_profile", createHashMap, [createHashMap]],
	["_username", "", [""]],
	["_applySeedContent", true, [false]]
];

if (isNull _device || {_username isEqualTo ""}) exitWith {false};

private _data = _device getVariable [QGVAR(data), [createHashMap] call FUNC(createDefaultData)];
private _users = _data getOrDefault ["users", []];
private _userIndex = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username};
if (_userIndex < 0) exitWith {
	["MobileProfile", "Apply profile failed because user was not found on device", createHashMapFromArray [
		["device", _device],
		["username", _username],
		["profileId", _profile getOrDefault ["id", ""]],
		["deviceUsers", _users apply {_x getOrDefault ["username", ""]}]
	]] call FUNC(debugLog);
	false
};

private _user = _users select _userIndex;
private _email = _user getOrDefault ["email", ""];
private _profileEmail = [_profile getOrDefault ["primaryEmail", _profile getOrDefault ["email", ""]]] call CBA_fnc_trim;
if (_profileEmail isNotEqualTo "") then {
	_email = _profileEmail;
};
private _theme = _profile getOrDefault ["theme", _user getOrDefault ["theme", "default"]];
private _layout = _profile getOrDefault ["layout", _user getOrDefault ["customLayout", createHashMap]];
if !(_layout isEqualType createHashMap) then {
	_layout = createHashMap;
};
private _disabledApps = if ("disabledApps" in keys _profile) then {
	[_profile getOrDefault ["disabledApps", []]] call FUNC(normalizeStandardAppIds)
} else {
	_user getOrDefault ["disabledApps", []]
};
if (_device getVariable [QGVAR(isMobileComputer), false]) then {
	_data set ["disabledApps", []];
	_device setVariable [QGVAR(data), _data, true];
};

["MobileProfile", "Applying mobile profile to server-side device user", createHashMapFromArray [
	["device", _device],
	["username", _username],
	["profileId", _profile getOrDefault ["id", ""]],
	["email", _email],
	["theme", _theme],
	["hasLayout", count _layout > 0],
	["disabledApps", _disabledApps],
	["applySeedContent", _applySeedContent],
	["profileFiles", count (_profile getOrDefault ["files", []])],
	["profileMails", count (_profile getOrDefault ["mails", _profile getOrDefault ["mail", []]])]
]] call FUNC(debugLog);

private _addUserResult = [_device, _username, _user getOrDefault ["password", ""], _email, _theme, _layout, "direct", _disabledApps] call FUNC(addUser);
if (!_addUserResult) exitWith {
	["MobileProfile", "Apply profile failed because addUser rejected the user", createHashMapFromArray [
		["device", _device],
		["username", _username],
		["profileId", _profile getOrDefault ["id", ""]],
		["email", _email],
		["loginRequired", _data getOrDefault ["loginRequired", true]],
		["autoLoginUsername", _data getOrDefault ["autoLoginUsername", ""]]
	]] call FUNC(debugLog);
	false
};

_data = _device getVariable [QGVAR(data), _data];
_users = _data getOrDefault ["users", []];
_userIndex = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username};
if (_userIndex >= 0) then {
	private _currentUser = _users select _userIndex;
	private _sideText = _profile getOrDefault ["messengerSide", _profile getOrDefault ["side", ""]];
	if (_sideText isEqualTo "" && {!isNull _player}) then {
		_sideText = str (side group _player);
	};
	private _displayName = _profile getOrDefault ["messengerName", _profile getOrDefault ["displayName", ""]];
	if (_displayName isEqualTo "" && {!isNull _player}) then {
		_displayName = name _player;
	};
	if (_displayName isEqualTo "") then {
		_displayName = _username;
	};
	if (_sideText isNotEqualTo "") then {
		_currentUser set ["side", _sideText];
		_currentUser set ["messengerSide", _sideText];
		_device setVariable [QGVAR(messengerSide), _sideText, true];
	};
	_currentUser set ["displayName", _displayName];
	_currentUser set ["messengerName", _displayName];
	_device setVariable [QGVAR(messengerName), _displayName, true];
	_users set [_userIndex, _currentUser];
	_data set ["users", _users];
	_device setVariable [QGVAR(data), _data, true];
	if ((_device getVariable [QGVAR(activeUser), createHashMap]) getOrDefault ["username", ""] isEqualTo _username) then {
		_device setVariable [QGVAR(activeUser), _currentUser, true];
	};
};

if ("systemName" in keys _profile) then {
	_data = _device getVariable [QGVAR(data), _data];
	_data set ["systemName", _profile getOrDefault ["systemName", _data getOrDefault ["systemName", "Mobile Device"]]];
	_device setVariable [QGVAR(data), _data, true];
};

private _desktopTitle = _profile getOrDefault ["desktopTitle", ""];
private _desktopContent = _profile getOrDefault ["desktopContent", ""];
private _desktopAlign = _profile getOrDefault ["desktopAlign", "left"];
private _desktopScript = _profile getOrDefault ["desktopScript", ""];
if (_desktopTitle isNotEqualTo "" || {_desktopContent isNotEqualTo "" || {_desktopScript isNotEqualTo ""}}) then {
	_data = _device getVariable [QGVAR(data), _data];
	_users = _data getOrDefault ["users", []];
	_userIndex = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username};
	if (_userIndex >= 0) then {
		private _currentUser = _users select _userIndex;
		if (_desktopTitle isEqualTo "") then {
			_desktopTitle = _currentUser getOrDefault ["desktopTitle", _data getOrDefault ["desktopTitle", "Mobile Computer"]];
		};
		if (_desktopContent isEqualTo "") then {
			_desktopContent = _currentUser getOrDefault ["desktopContent", _data getOrDefault ["desktopContent", ""]];
		};
		if (_desktopScript isEqualTo "") then {
			_desktopScript = _currentUser getOrDefault ["desktopScript", _data getOrDefault ["desktopScript", ""]];
		};
	};
	[_device, _username, _desktopTitle, _desktopContent, _desktopAlign, _desktopScript] call FUNC(modifyDesktop);
};

private _aliases = _profile getOrDefault ["aliases", []];
if (_aliases isEqualType "") then {
	_aliases = _aliases splitString ",";
};
if (_aliases isNotEqualTo []) then {
	[_device, _username, _aliases, false] call FUNC(setUserEmailAliases);
	["MobileProfile", "Applied mobile profile aliases", createHashMapFromArray [
		["username", _username],
		["aliases", _aliases]
	]] call FUNC(debugLog);
};

private _filesAdded = 0;
private _mailsSeeded = 0;
if (_applySeedContent) then {
	{
		private _file = if (_x isEqualType createHashMap) then {_x} else {createHashMapFromArray _x};
		[
			_device,
			_username,
			_file getOrDefault ["name", "file.txt"],
			_file getOrDefault ["content", _file getOrDefault ["description", ""]],
			_file getOrDefault ["type", "text"],
			_file getOrDefault ["path", ""],
			_file getOrDefault ["texture", ""]
		] call FUNC(addFileToUser);
		_filesAdded = _filesAdded + 1;
	} forEach (_profile getOrDefault ["files", []]);

	{
		private _mail = if (_x isEqualType createHashMap) then {_x} else {createHashMapFromArray _x};
		[
			_device,
			_username,
			_mail getOrDefault ["direction", "inbox"],
			_mail getOrDefault ["counterpart", _mail getOrDefault ["fromTo", _mail getOrDefault ["from", "sender@mmc.local"]]],
			_mail getOrDefault ["cc", ""],
			_mail getOrDefault ["subject", "Mission Update"],
			_mail getOrDefault ["body", ""],
			_mail getOrDefault ["date", ""],
			_mail getOrDefault ["time", ""],
			_mail getOrDefault ["attachment", ""],
			_mail getOrDefault ["attachmentDescription", ""],
			_mail getOrDefault ["recipientRead", false],
			_mail getOrDefault ["senderRead", true],
			_mail getOrDefault ["ccRead", false]
		] call FUNC(seedMail);
		_mailsSeeded = _mailsSeeded + 1;
	} forEach (_profile getOrDefault ["mails", _profile getOrDefault ["mail", []]]);
};

_data = _device getVariable [QGVAR(data), _data];
_users = _data getOrDefault ["users", []];
_userIndex = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username};
if (_userIndex >= 0) then {
	private _finalUser = _users select _userIndex;
	["MobileProfile", "Applied mobile profile result", createHashMapFromArray [
		["username", _username],
		["profileId", _profile getOrDefault ["id", ""]],
		["email", _finalUser getOrDefault ["email", ""]],
		["aliases", _finalUser getOrDefault ["emailAliases", []]],
		["theme", _finalUser getOrDefault ["theme", ""]],
		["filesAddedThisPass", _filesAdded],
		["mailsSeededThisPass", _mailsSeeded],
		["filesTotal", count (_finalUser getOrDefault ["files", []])],
		["inboxTotal", count (_finalUser getOrDefault ["mail", []])],
		["outboxTotal", count (_finalUser getOrDefault ["outbox", []])]
	]] call FUNC(debugLog);
};

true
