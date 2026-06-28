#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Records a recovered mobile device code locally and, where possible, on a hacker-owned mobile device.
 *
 * Arguments:
 * 0: Hacked mobile device/computer object <OBJECT>
 * 1: Recovered code <STRING>
 * 2: Hacker <OBJECT, default: player>
 *
 * Return Value:
 * Recorded <BOOL>
 */

params [
	["_device", objNull, [objNull]],
	["_code", "", [""]],
	["_hacker", player, [objNull]]
];

if (isNull _device) exitWith {false};

private _data = _device getVariable [QGVAR(data), createHashMap];
private _deviceName = _data getOrDefault ["systemName", _device getVariable [QGVAR(mobileDeviceLabel), "Mobile Device"]];
if (_deviceName isEqualTo "") then {
	_deviceName = "Mobile Device";
};

private _cache = missionNamespace getVariable [QGVAR(hackingKnownMobileCodes), createHashMap];
if !(_cache isEqualType createHashMap) then {
	_cache = createHashMap;
};
private _key = netId _device;
if (_key isEqualTo "") then {
	_key = str _device;
};
_cache set [_key, createHashMapFromArray [
	["device", _device],
	["name", _deviceName],
	["code", _code]
]];
missionNamespace setVariable [QGVAR(hackingKnownMobileCodes), _cache];

private _shownCode = [_code, "<empty>"] select (_code isEqualTo "");
private _title = format ["Intrusion Report - %1", _deviceName];
private _body = format [
	"MMC Intrusion Tool v3.5.6%1%1Device: %2%1Recovered lock code: %3%1%1Store this before handing the device away.",
	toString [13, 10],
	_deviceName,
	_shownCode
];
private _safeName = (_deviceName splitString " ") joinString "_";
private _fileName = format ["intrusion_%1.txt", _safeName];

private _recorded = [_device, _title, _body, _hacker, _fileName] call FUNC(hackingRecordReport);

[
	format [
		"Recovered code for %1<br/><t size='0.9'>%2</t>",
		_deviceName,
		_shownCode
	],
	2.8,
	player,
	12
] call ace_common_fnc_displayTextStructured;

["Hacking", "Recorded mobile code", createHashMapFromArray [
	["device", _device],
	["name", _deviceName],
	["codeEmpty", _code isEqualTo ""],
	["recordQueued", _recorded]
]] call FUNC(debugLog);

true
