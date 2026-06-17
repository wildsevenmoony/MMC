#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Returns Messenger contacts visible to the active computer/device.
 *
 * Arguments:
 * 0: Current computer or mobile logic object <OBJECT>
 *
 * Return Value:
 * Contact identities <ARRAY>
 */

params [["_current", objNull, [objNull]]];

private _toSide = {
	params [["_sideText", "", [""]]];
	switch (toLowerANSI _sideText) do {
		case "west": {west};
		case "blufor": {west};
		case "east": {east};
		case "opfor": {east};
		case "resistance": {resistance};
		case "independent": {resistance};
		case "guer": {resistance};
		case "civilian": {civilian};
		case "civ": {civilian};
		default {sideUnknown};
	};
};

private _own = [_current] call FUNC(getMessengerIdentity);
private _ownId = _own getOrDefault ["id", ""];
private _ownSideText = _own getOrDefault ["side", ""];
if (_ownSideText isEqualTo "" && {!isNull player}) then {
	_ownSideText = str (side group player);
};
private _ownSide = [_ownSideText] call _toSide;
private _identityKey = {
	params [["_identity", createHashMap, [createHashMap]]];

	private _email = toLowerANSI (_identity getOrDefault ["email", ""]);
	if (_email isNotEqualTo "") exitWith {format ["email:%1", _email]};

	private _username = toLowerANSI (_identity getOrDefault ["username", ""]);
	private _name = toLowerANSI (_identity getOrDefault ["name", ""]);
	if (_username isNotEqualTo "" || {_name isNotEqualTo ""}) exitWith {
		format ["name:%1:%2", _username, _name]
	};

	private _id = _identity getOrDefault ["id", ""];
	if (_id isNotEqualTo "") exitWith {format ["id:%1", _id]};

	""
};
private _ownDedupeKey = [_own] call _identityKey;

private _computers = [] call FUNC(getRegisteredComputers);
{
	if (!isNull _x) then {
		_computers pushBackUnique _x;
	};
} forEach (missionNamespace getVariable [QGVAR(mobileDeviceObjects), []]);
if (GVAR(mobileDevices) isEqualType createHashMap) then {
	{
		private _device = GVAR(mobileDevices) getOrDefault [_x, objNull];
		if (!isNull _device) then {
			_computers pushBackUnique _device;
		};
	} forEach (keys GVAR(mobileDevices));
};

private _scope = missionNamespace getVariable [QGVAR(messengerScope), "ownSide"];
private _excludeCivilians = missionNamespace getVariable [QGVAR(messengerExcludeCivilians), true];
private _contacts = [];
private _candidateIdentities = [];

{
	private _computer = _x;
	private _data = _computer getVariable [QGVAR(data), createHashMap];
	private _users = _data getOrDefault ["users", []];
	if (_users isEqualType [] && {_users isNotEqualTo []}) then {
		{
			private _user = _x;
			if (_user isEqualType createHashMap) then {
				private _identity = [_computer, _user] call FUNC(getMessengerIdentityForUser);
				if (count _identity > 0) then {
					_candidateIdentities pushBack _identity;
				};
			};
		} forEach _users;
	} else {
		if (_computer getVariable [QGVAR(isMobileComputer), false]) then {
			private _identity = [_computer] call FUNC(getMessengerIdentity);
			if (count _identity > 0) then {
				_candidateIdentities pushBack _identity;
			};
		};
	};
} forEach _computers;

{
	private _identity = _x;
	private _targetId = _identity getOrDefault ["id", ""];
	private _targetName = _identity getOrDefault ["name", ""];
	private _isMobile = _identity getOrDefault ["isMobile", false];
	private _targetEmail = _identity getOrDefault ["email", ""];
	private _targetUser = _identity getOrDefault ["user", createHashMap];
	private _targetSideText = _identity getOrDefault ["side", ""];
	private _targetSide = [_targetSideText] call _toSide;
	private _dedupeKey = [_identity] call _identityKey;
	private _allowed = _targetId isNotEqualTo "" && {_targetId isNotEqualTo _ownId} && {_dedupeKey isNotEqualTo ""} && {_dedupeKey isNotEqualTo _ownDedupeKey} && {_targetSideText isNotEqualTo "hidden"} && {_targetSide isNotEqualTo sideUnknown};
	if (_allowed && {!_isMobile && {((toLowerANSI _targetName) select [0, 8]) isEqualTo "terminal"}}) then {
		_allowed = false;
	};
	if (_allowed && {!_isMobile && {_targetName in ["MMC Workstation", "MMC Mobile Device"]}}) then {
		_allowed = false;
	};
	if (_allowed && {!_isMobile && {count _targetUser == 0}}) then {
		_allowed = false;
	};
	if (_allowed && {!_isMobile && {_targetEmail isEqualTo ""}}) then {
		_allowed = false;
	};

	if (_allowed && {_excludeCivilians && {_ownSide isNotEqualTo civilian && {_targetSide isEqualTo civilian}}}) then {
		_allowed = false;
	};

	if (_allowed) then {
		_allowed = if (_scope isEqualTo "friendly") then {
			_ownSide isNotEqualTo sideUnknown && {(_ownSide getFriend _targetSide) >= 0.6}
		} else {
			_ownSide isNotEqualTo sideUnknown && {_ownSide isEqualTo _targetSide}
		};
	};

	if (_allowed) then {
		if (_contacts findIf {
			([_x] call _identityKey) isEqualTo _dedupeKey
		} < 0) then {
			_contacts pushBack _identity;
		};
	};
} forEach _candidateIdentities;

private _contactDebug = _contacts apply {
	private _object = _x getOrDefault ["object", objNull];
	private _user = _x getOrDefault ["user", createHashMap];
	[
		_x getOrDefault ["name", ""],
		_x getOrDefault ["email", ""],
		_x getOrDefault ["side", ""],
		_x getOrDefault ["isMobile", false],
		typeOf _object,
		_user getOrDefault ["source", ""]
	]
};
private _candidateDebug = _candidateIdentities apply {
	private _object = _x getOrDefault ["object", objNull];
	private _user = _x getOrDefault ["user", createHashMap];
	[
		_x getOrDefault ["name", ""],
		_x getOrDefault ["email", ""],
		_x getOrDefault ["side", ""],
		_x getOrDefault ["isMobile", false],
		typeOf _object,
		_user getOrDefault ["source", ""]
	]
};
private _debugSignature = str _contactDebug;
if (_debugSignature isNotEqualTo (uiNamespace getVariable [QGVAR(lastMessengerContactDebugSignature), ""])) then {
	uiNamespace setVariable [QGVAR(lastMessengerContactDebugSignature), _debugSignature];
	["Messenger", "Resolved visible messenger contacts", createHashMapFromArray [
		["candidateCount", count _candidateIdentities],
		["visibleCount", count _contacts],
		["scope", _scope],
		["excludeCivilians", _excludeCivilians],
		["ownSide", str _ownSide],
		["contacts", _contactDebug],
		["candidates", _candidateDebug]
	]] call FUNC(debugLog);
};

_contacts
