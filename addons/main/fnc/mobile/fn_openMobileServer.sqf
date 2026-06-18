#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Creates or refreshes a server-owned personal MMC mobile computer for a player.
 *
 * Arguments:
 * 0: Player <OBJECT>
 * 1: Selected mobile device record <HASHMAP>
 *
 * Return Value:
 * Mobile computer <OBJECT>
 */

params [
	["_player", objNull, [objNull]],
	["_deviceInfo", createHashMap, [createHashMap]],
	["_openDisplay", true, [true]]
];

if (!isServer || {isNull _player}) exitWith {objNull};

["Mobile", "Open mobile request on server", createHashMapFromArray [
	["player", format ["%1:%2:%3", name _player, getPlayerUID _player, typeOf _player]],
	["deviceInfo", _deviceInfo],
	["openDisplay", _openDisplay]
]] call FUNC(debugLog);

private _uid = getPlayerUID _player;
if (_uid isEqualTo "") exitWith {objNull};

private _itemClass = _deviceInfo getOrDefault ["itemClass", ""];
private _type = [_itemClass] call FUNC(getMobileDeviceType);
if (count _type == 0) exitWith {objNull};
private _source = _deviceInfo getOrDefault ["source", "personal"];
private _isUniqueInventoryDevice = _type getOrDefault ["unique", false];
private _usesPersistentItemStore = _isUniqueInventoryDevice && {_source in ["personal", "picked"]};

private _inventory = (items _player) + (assignedItems _player);
if !(_itemClass in _inventory) exitWith {objNull};

["Mobile", "Validated mobile item", createHashMapFromArray [
	["itemClass", _itemClass],
	["type", _type],
	["source", _source],
	["usesPersistentStore", _usesPersistentItemStore],
	["inventoryCount", count _inventory]
]] call FUNC(debugLog);

if !(GVAR(mobileDevices) isEqualType createHashMap) then {
	GVAR(mobileDevices) = createHashMap;
};

private _deviceKey = _deviceInfo getOrDefault ["key", ""];
if (_deviceKey isEqualTo "") then {
	_deviceKey = if (_usesPersistentItemStore) then {
		_itemClass
	} else {
		if (_source isEqualTo "picked") then {
			_deviceInfo getOrDefault ["id", format ["picked_%1", _itemClass]]
		} else {
			"personal"
		}
	};
};
private _storeKey = if (_usesPersistentItemStore) then {_deviceKey} else {format ["%1:%2", _uid, _deviceKey]};
private _orientation = _deviceInfo getOrDefault ["orientation", _type getOrDefault ["orientation", "horizontal"]];
private _label = _deviceInfo getOrDefault ["label", _type getOrDefault ["label", "Mobile Device"]];

private _device = GVAR(mobileDevices) getOrDefault [_storeKey, objNull];
if (isNull _device) then {
	private _logicGroup = createGroup sideLogic;
	_device = _logicGroup createUnit ["Logic", [0, 0, 0], [], 0, "NONE"];
	_device setVariable [QGVAR(isComputer), true, true];
	_device setVariable [QGVAR(isMobileComputer), true, true];
	_device setVariable [QGVAR(mobileOwnerUid), _uid, true];
	_device setVariable [QGVAR(mobileDeviceKey), _deviceKey, true];
	_device setVariable [QGVAR(destroyed), false, true];
	_device setVariable [QGVAR(poweredOn), true, true];
	_device setVariable [QGVAR(booting), false, true];
	_device setVariable [QGVAR(activeUser), createHashMap, true];
};
["Mobile", "Resolved mobile logic object", createHashMapFromArray [
	["storeKey", _storeKey],
	["deviceKey", _deviceKey],
	["device", _device],
	["existingDataKeys", keys (_device getVariable [QGVAR(data), createHashMap])]
]] call FUNC(debugLog);
GVAR(mobileDevices) set [_storeKey, _device];
private _publicMobileDevices = missionNamespace getVariable [QGVAR(mobileDeviceObjects), []];
_publicMobileDevices pushBackUnique _device;
missionNamespace setVariable [QGVAR(mobileDeviceObjects), _publicMobileDevices, true];

private _publicComputers = missionNamespace getVariable [QGVAR(registeredComputerObjects), []];
_publicComputers pushBackUnique _device;
missionNamespace setVariable [QGVAR(registeredComputerObjects), _publicComputers, true];
_player setVariable [QGVAR(mobileComputer), _device, true];
_device setVariable [QGVAR(destroyed), false, true];
_device setVariable [QGVAR(poweredOn), true, true];
_device setVariable [QGVAR(booting), false, true];
_device setVariable [QGVAR(mobileDefaultOrientation), _orientation, true];
_device setVariable [QGVAR(mobileDeviceLabel), _label, true];
_device setVariable [QGVAR(mobileItemClass), _itemClass, true];
_device setVariable [QGVAR(mobileSource), _source, true];

private _rawName = name _player;
private _localPart = toLowerANSI _rawName;
private _allowed = toArray "abcdefghijklmnopqrstuvwxyz0123456789._-";
private _chars = [];
{
	private _char = toLowerANSI toString [_x];
	if ((toArray _char) param [0, -1] in _allowed) then {
		_chars pushBack _char;
	} else {
		if (_chars isEqualTo [] || {_chars select -1 isNotEqualTo "."}) then {
			_chars pushBack ".";
		};
	};
} forEach toArray _localPart;
_localPart = _chars joinString "";
while {_localPart isNotEqualTo "" && {(_localPart select [0, 1]) isEqualTo "."}} do {
	_localPart = _localPart select [1];
};
while {_localPart isNotEqualTo "" && {(_localPart select [((count _localPart) - 1), 1]) isEqualTo "."}} do {
	_localPart = _localPart select [0, (count _localPart) - 1];
};
if (_localPart isEqualTo "") then {
	_localPart = format ["user%1", _uid select [((count _uid) - 4) max 0]];
};

private _username = _rawName;
private _email = format ["%1@mmcsystems.com", _localPart];
private _playerSideText = str (side group _player);
private _sourceData = _deviceInfo getOrDefault ["data", createHashMap];
private _data = createHashMap;
private _dataWasEmpty = false;
private _existingData = _device getVariable [QGVAR(data), createHashMap];

if (_sourceData isEqualType createHashMap && {count _sourceData > 0} && {!_usesPersistentItemStore || {count _existingData == 0}}) then {
	_data = _sourceData;
	_device setVariable [QGVAR(data), _data, true];
	_device setVariable [QGVAR(activeUser), createHashMap, true];
} else {
	_data = _existingData;
	_dataWasEmpty = count _data == 0;
	if (count _data == 0) then {
		_data = [createHashMapFromArray [
			["systemName", format ["%1 Mobile", _rawName]],
			["closedSystem", true],
			["loginRequired", false],
			["autoLoginUsername", _username],
			["desktopTitle", "Mobile Computer"],
			["desktopContent", "Personal mobile MMC session.<br/><br/>Files and mail linked to this player are available here."],
			["disabledApps", []]
		]] call FUNC(createDefaultData);
		_device setVariable [QGVAR(data), _data, true];
		[_device, _username, "", _email, "default", createHashMap, "direct", []] call FUNC(addUser);
	} else {
		if (!_usesPersistentItemStore) then {
			_data set ["systemName", format ["%1 Mobile", _rawName]];
			_data set ["loginRequired", false];
			_data set ["closedSystem", true];
			_data set ["autoLoginUsername", _username];
			_device setVariable [QGVAR(data), _data, true];
		};
	};
};

_data = _device getVariable [QGVAR(data), createHashMap];
private _mobileUsers = _data getOrDefault ["users", []];
private _mobileUserIndex = _mobileUsers findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username};
private _preserveStoredIdentity = _source isEqualTo "picked" || {_usesPersistentItemStore && {!_dataWasEmpty}};
if (!_preserveStoredIdentity) then {
	_device setVariable [QGVAR(messengerSide), _playerSideText, true];
	_device setVariable [QGVAR(messengerName), name _player, true];
};
if (_mobileUserIndex >= 0 && {!_preserveStoredIdentity}) then {
	private _mobileUser = _mobileUsers select _mobileUserIndex;
	_mobileUser set ["side", _playerSideText];
	_mobileUser set ["messengerSide", _playerSideText];
	_mobileUser set ["displayName", name _player];
	_mobileUser set ["messengerName", name _player];
	_mobileUsers set [_mobileUserIndex, _mobileUser];
	_data set ["users", _mobileUsers];
	_device setVariable [QGVAR(data), _data, true];
};

if (_source isNotEqualTo "picked" && {!_usesPersistentItemStore}) then {
	_data = _device getVariable [QGVAR(data), createHashMap];
	_data set ["systemName", format ["%1 Mobile", _rawName]];
	_data set ["loginRequired", false];
	_data set ["closedSystem", true];
	_data set ["autoLoginUsername", _username];
	_data set ["disabledApps", []];
	_device setVariable [QGVAR(data), _data, true];
};

private _profileUsername = _username;
_data = _device getVariable [QGVAR(data), createHashMap];
if (_source isEqualTo "picked" || {_usesPersistentItemStore && {!_dataWasEmpty}}) then {
	_profileUsername = _data getOrDefault ["autoLoginUsername", ""];
	if (_profileUsername isEqualTo "") then {
		private _users = _data getOrDefault ["users", []];
		if (_users isNotEqualTo []) then {
			_profileUsername = (_users select 0) getOrDefault ["username", _username];
		};
	};
};
if (_profileUsername isEqualTo "") then {
	_profileUsername = _username;
};

[] call FUNC(refreshMobileProfilesFromModules);

private _profiles = [_player, _deviceInfo] call FUNC(selectMobileProfiles);
private _profileIds = _profiles apply {_x getOrDefault ["id", ""]} select {_x isNotEqualTo ""};

["Mobile", "Profiles selected for mobile open", createHashMapFromArray [
	["profileUsername", _profileUsername],
	["profileIds", _profileIds],
	["profiles", _profiles apply {
		createHashMapFromArray [
			["id", _x getOrDefault ["id", ""]],
			["theme", _x getOrDefault ["theme", ""]],
			["files", count (_x getOrDefault ["files", []])],
			["mails", count (_x getOrDefault ["mails", []])],
			["appScripts", _x getOrDefault ["appScripts", []]],
			["hasLayout", count (_x getOrDefault ["layout", createHashMap]) > 0]
		]
	}]
]] call FUNC(debugLog);
private _appliedContentProfiles = _device getVariable [QGVAR(mobileAppliedContentProfiles), []];
if !(_appliedContentProfiles isEqualType []) then {
	_appliedContentProfiles = [];
};

private _ownerUid = _device getVariable [QGVAR(mobileOwnerUid), _uid];
private _canRefreshProfiles = !_usesPersistentItemStore || {_dataWasEmpty || {_ownerUid isEqualTo _uid}};
if (_canRefreshProfiles) then {
	["Mobile", "Applying selected profiles", createHashMapFromArray [
		["canRefreshProfiles", _canRefreshProfiles],
		["appliedContentProfilesBefore", _appliedContentProfiles]
	]] call FUNC(debugLog);
	{
		private _profileId = _x getOrDefault ["id", ""];
		private _hasSeedContent = (_x getOrDefault ["files", []]) isNotEqualTo []
			|| {(_x getOrDefault ["mails", _x getOrDefault ["mail", []]]) isNotEqualTo []};
		private _shouldApplySeedContent = !(_profileId in _appliedContentProfiles) || {_x getOrDefault ["reapplyContent", false]};
		[_device, _player, _x, _profileUsername, _shouldApplySeedContent] call FUNC(applyMobileProfile);
		private _hasProfileId = _profileId isNotEqualTo "";
		if (_shouldApplySeedContent && _hasProfileId && _hasSeedContent) then {
			_appliedContentProfiles pushBackUnique _profileId;
		};
	} forEach _profiles;
	_device setVariable [QGVAR(mobileAppliedProfiles), _profileIds, true];
} else {
	_profileIds = _device getVariable [QGVAR(mobileAppliedProfiles), []];
	["Mobile", "Skipped profile refresh for persistent device", createHashMapFromArray [
		["ownerUid", _ownerUid],
		["requestUid", _uid],
		["profileIds", _profileIds]
	]] call FUNC(debugLog);
};
_device setVariable [QGVAR(mobileAppliedContentProfiles), _appliedContentProfiles, true];

[_device] call FUNC(ensureAutoLoginUser);

if !(GVAR(registeredComputers) isEqualType []) then {
	GVAR(registeredComputers) = [];
};
GVAR(registeredComputers) pushBackUnique _device;

private _aliases = [];
{
	_aliases pushBackUnique _x;
} forEach (_player getVariable [QGVAR(mobilePendingAliases), []]);

private _shouldApplyPendingAliases = _source isNotEqualTo "picked" && (!_usesPersistentItemStore || _dataWasEmpty) && {_aliases isNotEqualTo []};
if (_shouldApplyPendingAliases) then {
	[_device, _username, _aliases, false] call FUNC(setUserEmailAliases);
};

if (_openDisplay) then {
	private _deviceData = _device getVariable [QGVAR(data), createHashMap];
	private _localProfiles = _profiles apply {
		createHashMapFromArray [
			["id", _x getOrDefault ["id", ""]],
			["apps", _x getOrDefault ["apps", []]],
			["appScripts", _x getOrDefault ["appScripts", []]]
		]
	};
	["Mobile", "Sending mobile data to client", createHashMapFromArray [
		["device", _device],
		["users", (_deviceData getOrDefault ["users", []]) apply {
			createHashMapFromArray [
				["username", _x getOrDefault ["username", ""]],
				["email", _x getOrDefault ["email", ""]],
				["theme", _x getOrDefault ["theme", ""]],
				["files", count (_x getOrDefault ["files", []])],
				["mail", count (_x getOrDefault ["mail", []])],
				["outbox", count (_x getOrDefault ["outbox", []])],
				["aliases", _x getOrDefault ["emailAliases", []]]
			]
		}],
		["localProfiles", _localProfiles]
	]] call FUNC(debugLog);
	[_device, _deviceData, _orientation, _label, _localProfiles] remoteExecCall [QFUNC(openMobileLocal), _player];
};

_device
