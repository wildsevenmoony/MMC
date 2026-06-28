/*
 * Author: Moony
 * Records an intrusion report on a hacker-owned mobile device or falls back to a diary entry.
 *
 * Arguments:
 * 0: Hacked target object <OBJECT>
 * 1: Report title <STRING>
 * 2: Report body <STRING>
 * 3: Hacker <OBJECT, default: player>
 * 4: Text file name <STRING, default: intrusion_report.txt>
 * 5: Mobile preparation attempts <NUMBER, default: 2>
 *
 * Return Value:
 * Report queued or recorded <BOOL>
 *
 * Public: No
 */

#include "..\..\script_component.hpp"

params [
	["_target", objNull, [objNull]],
	["_title", "Intrusion Report", [""]],
	["_body", "", [""]],
	["_hacker", player, [objNull]],
	["_fileName", "intrusion_report.txt", [""]],
	["_prepareAttempts", 2, [0]]
];

if (!hasInterface || {isNull _hacker} || {_hacker isNotEqualTo player}) exitWith {false};

private _recordDevice = objNull;
private _hackerUid = getPlayerUID _hacker;
private _candidates = missionNamespace getVariable [QGVAR(mobileDeviceObjects), []];
private _currentMobile = _hacker getVariable [QGVAR(mobileComputer), objNull];
if (!isNull _currentMobile) then {
	_candidates pushBackUnique _currentMobile;
};
private _bestScore = -1;

{
	if (
		_x isEqualType objNull
		&& {!isNull _x}
		&& {_x isNotEqualTo _target}
		&& {_x getVariable [QGVAR(isMobileComputer), false]}
		&& {(_x getVariable [QGVAR(mobileOwnerUid), ""]) isEqualTo _hackerUid}
	) then {
		private _activeUser = [_x] call FUNC(getActiveUser);
		private _notesEnabled = [_x, "notes", _activeUser] call FUNC(isStandardAppEnabled);
		private _filesEnabled = [_x, "files", _activeUser] call FUNC(isStandardAppEnabled);
		if (_notesEnabled || _filesEnabled) then {
			private _source = _x getVariable [QGVAR(mobileSource), ""];
			private _score = 0;
			if (_source isEqualTo "personal") then {_score = _score + 50};
			if (_source isNotEqualTo "picked") then {_score = _score + 20};
			if (_notesEnabled) then {_score = _score + 5};
			if (_filesEnabled) then {_score = _score + 5};
			if (_score > _bestScore) then {
				_bestScore = _score;
				_recordDevice = _x;
			};
		};
	};
} forEach _candidates;

private _recordedToDevice = false;
private _recordDeviceName = "";

if (!isNull _recordDevice) then {
	private _activeUser = [_recordDevice] call FUNC(getActiveUser);
	private _username = _activeUser getOrDefault ["username", ""];
	_recordDeviceName = (_recordDevice getVariable [QGVAR(data), createHashMap]) getOrDefault ["systemName", _recordDevice getVariable [QGVAR(mobileDeviceLabel), "Hacker Device"]];

	if ([_recordDevice, "notes", _activeUser] call FUNC(isStandardAppEnabled)) then {
		_recordedToDevice = [_recordDevice, _title, _body, _username] call FUNC(addNote);
	};

	if ([_recordDevice, "files", _activeUser] call FUNC(isStandardAppEnabled)) then {
		private _fileAdded = if (_username isEqualTo "") then {
			[_recordDevice, _fileName, _body, "text"] call FUNC(addFile)
		} else {
			[_recordDevice, _username, _fileName, _body, "text"] call FUNC(addFileToUser)
		};
		_recordedToDevice = _recordedToDevice || _fileAdded;
	};
};

if (_recordedToDevice) exitWith {
	["Hacking", "Recorded intrusion report on mobile device", createHashMapFromArray [
		["target", _target],
		["title", _title],
		["recordDevice", _recordDevice],
		["recordDeviceName", _recordDeviceName]
	]] call FUNC(debugLog);
	true
};

if (_prepareAttempts > 0) then {
	if (call FUNC(ensureUniqueMobileDevicesLocal)) exitWith {
		[
			{
				params ["_target", "_title", "_body", "_hacker", "_fileName", "_attempts"];
				[_target, _title, _body, _hacker, _fileName, _attempts] call MMC_fnc_hackingRecordReport;
			},
			[_target, _title, _body, _hacker, _fileName, _prepareAttempts - 1],
			1.5
		] call CBA_fnc_waitAndExecute;
		true
	};

	private _inventoryDevices = [] call FUNC(getMobileInventoryDevices);
	if (_inventoryDevices isNotEqualTo []) exitWith {
		[_hacker, _inventoryDevices select 0, false] remoteExecCall [QFUNC(openMobileServer), 2];
		[
			{
				params ["_target", "_title", "_body", "_hacker", "_fileName", "_attempts"];
				[_target, _title, _body, _hacker, _fileName, _attempts] call MMC_fnc_hackingRecordReport;
			},
			[_target, _title, _body, _hacker, _fileName, _prepareAttempts - 1],
			0.85
		] call CBA_fnc_waitAndExecute;
		true
	};
};

player createDiarySubject [QGVAR(intrusionReports), "MMC Intrusion"];
private _diaryBody = (_body splitString (toString [13, 10])) joinString "<br/>";
player createDiaryRecord [QGVAR(intrusionReports), [_title, _diaryBody]];

["Hacking", "Recorded intrusion report as diary fallback", createHashMapFromArray [
	["target", _target],
	["title", _title],
	["hasInventoryDevice", ([] call FUNC(getMobileInventoryDevices)) isNotEqualTo []]
]] call FUNC(debugLog);

true
