#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Builds the visible address book for a user, including persistent entries and
 * side-visible player/device mail addresses.
 *
 * Arguments:
 * 0: Current computer or mobile logic object <OBJECT>
 * 1: Active user <HASHMAP>
 *
 * Return Value:
 * Address entries <ARRAY>
 */

params [
	["_current", objNull, [objNull]],
	["_activeUser", createHashMap, [createHashMap]]
];

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

private _entries = [_activeUser getOrDefault ["addressBook", []]] call FUNC(normalizeAddressBook);
private _knownEmails = _entries apply {toLowerANSI ([_x getOrDefault ["email", ""]] call CBA_fnc_trim)};
private _ownEmails = [];
{
	private _email = toLowerANSI ([_x] call CBA_fnc_trim);
	if (_email isNotEqualTo "") then {
		_ownEmails pushBackUnique _email;
	};
} forEach ([_activeUser getOrDefault ["email", ""]] + (_activeUser getOrDefault ["emailAliases", []]));

private _ownSideText = _activeUser getOrDefault ["messengerSide", _activeUser getOrDefault ["side", ""]];
if (_ownSideText isEqualTo "" && {!isNull _current}) then {
	_ownSideText = _current getVariable [QGVAR(messengerSide), ""];
};
if (_ownSideText isEqualTo "" && {!isNull player}) then {
	_ownSideText = str (side group player);
};
private _ownSide = [_ownSideText] call _toSide;
private _includeFriendly = missionNamespace getVariable [QGVAR(mailAddressBookIncludeFriendlySides), true];
private _excludeCivilians = missionNamespace getVariable [QGVAR(mailAddressBookExcludeCivilians), true];

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

{
	private _computer = _x;
	private _data = _computer getVariable [QGVAR(data), createHashMap];
	{
		if (_x isEqualType createHashMap) then {
			private _email = [_x getOrDefault ["email", ""]] call CBA_fnc_trim;
			private _emailKey = toLowerANSI _email;
			if (_email isNotEqualTo "" && {!(_emailKey in _ownEmails) && {!(_emailKey in _knownEmails)}}) then {
				private _name = _x getOrDefault ["displayName", _x getOrDefault ["messengerName", _x getOrDefault ["username", (_email splitString "@") param [0, _email]]]];
				private _nameLower = toLowerANSI _name;
				private _targetSideText = _x getOrDefault ["messengerSide", _x getOrDefault ["side", _data getOrDefault ["messengerSide", ""]]];
				private _targetSide = [_targetSideText] call _toSide;
				private _allowed = _ownSide isNotEqualTo sideUnknown && {_targetSide isNotEqualTo sideUnknown};
				if (_allowed && {(_nameLower select [0, 8]) isEqualTo "terminal"}) then {
					_allowed = false;
				};
				if (_allowed && {_name in ["MMC Workstation", "MMC Mobile Device"]}) then {
					_allowed = false;
				};
				if (_allowed && {_excludeCivilians && {_ownSide isNotEqualTo civilian && {_targetSide isEqualTo civilian}}}) then {
					_allowed = false;
				};
				if (_allowed) then {
					_allowed = if (_includeFriendly) then {
						(_ownSide getFriend _targetSide) >= 0.6
					} else {
						_ownSide isEqualTo _targetSide
					};
				};
				if (_allowed) then {
					_entries pushBack (createHashMapFromArray [
						["name", _name],
						["email", _email],
						["dynamic", true]
					]);
					_knownEmails pushBackUnique _emailKey;
				};
			};
		};
	} forEach (_data getOrDefault ["users", []]);
} forEach _computers;

_entries
