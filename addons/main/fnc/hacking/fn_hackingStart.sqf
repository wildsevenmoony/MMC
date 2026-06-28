#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Starts a timed MMC hacking attempt and validates the selected target.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Hacking mode, "login", "account", or "mobile" <STRING>
 * 2: Optional target user for account hacking <HASHMAP>
 *
 * Return Value:
 * Hacking started <BOOL>
 */

params [
	["_display", displayNull, [displayNull]],
	["_mode", "login", [""]],
	["_targetUser", createHashMap, [createHashMap]]
];

if (isNull _display) exitWith {false};

private _setError = {
	params ["_display", "_text", ["_mode", "login"]];

	if (_mode isEqualTo "mobile") then {
		private _lockMap = _display getVariable [QGVAR(mobileLockControlMap), createHashMap];
		private _error = _lockMap getOrDefault ["error", controlNull];
		if (!isNull _error) then {
			_error ctrlSetStructuredText parseText format ["<t align='center' size='1.05' font='RobotoCondensedBold'>%1</t>", _text];
		};
	} else {
		private _error = _display displayCtrl IDC_MMC_LOGIN_ERROR;
		if (!isNull _error) then {
			_error ctrlSetStructuredText parseText format ["<t align='center' size='1.08' font='RobotoCondensedBold'>%1</t>", _text];
		};
	};
};

if !([_display, _mode] call FUNC(hackingCanStart)) exitWith {
	private _requiredItem = [missionNamespace getVariable [QGVAR(hackingRequiredItem), QGVAR(hackingTool)]] call CBA_fnc_trim;
	private _itemName = if (_requiredItem isEqualTo "") then {
		"configured item"
	} else {
		getText (configFile >> "CfgWeapons" >> _requiredItem >> "displayName")
	};
	if (_itemName isEqualTo "") then {
		_itemName = _requiredItem;
	};
	[_display, format ["Requires %1.", _itemName], _mode] call _setError;
	false
};

private _computer = _display getVariable [QGVAR(computer), objNull];
if (isNull _computer) exitWith {false};

private _state = createHashMapFromArray [
	["mode", _mode],
	["computer", _computer],
	["hacker", player],
	["targetLabel", ["Linked Account Index", "Mobile Device"] select (_mode isEqualTo "mobile")],
	["targetUser", _targetUser],
	["history", []],
	["lockedOut", false]
];

if (_mode isEqualTo "login") then {
	_state set ["targetLabel", "Linked Account Index"];
};

if (_mode isEqualTo "account") then {
	if (count _targetUser == 0) then {
		[_display, "No account selected.", "login"] call _setError;
		_state set ["abort", true];
	} else {
		_state set ["targetLabel", "credential hash"];
		_state set ["targetUsername", _targetUser getOrDefault ["username", ""]];
	};
};

if (_state getOrDefault ["abort", false]) exitWith {false};

private _duration = round (missionNamespace getVariable [QGVAR(hackingDuration), 60]);
if (_mode isEqualTo "login") then {
	_duration = ((_duration * 0.25) max 2) min 12;
};
_duration = _duration max 0;

private _attemptId = format ["%1_%2", diag_tickTime, random 1];
_display setVariable [QGVAR(hackingBusy), true];
_display setVariable [QGVAR(hackingAttemptId), _attemptId];
_display setVariable [QGVAR(hackingCancelled), false];
_display setVariable [QGVAR(hackingCompleted), false];

["Hacking", "Hacking attempt started", createHashMapFromArray [
	["mode", _mode],
	["target", _state getOrDefault ["targetLabel", ""]],
	["duration", _duration]
]] call FUNC(debugLog);

if (_duration <= 0) exitWith {
	if (_mode isEqualTo "login") then {
		[_display] call FUNC(hackingRenderAccountList);
	} else {
		[_display, _state] call FUNC(hackingBegin);
	};
	true
};

[player, true] call FUNC(hackingSetEffectsLocal);

[_display, false, false] call FUNC(hackingClose);

private _panelStrong = [0.002, 0.006, 0.004, 0.985];
private _panel = [0.005, 0.035, 0.018, 0.96];
private _text = [0.66, 1, 0.76, 1];
private _accent = [0.18, 1, 0.46, 0.95];
private _button = [0.012, 0.11, 0.045, 0.98];
private _buttonText = [0.72, 1, 0.80, 1];
private _border = [0.16, 0.95, 0.38, 0.95];
private _setTerminalButton = {
	params ["_control"];
	_control setVariable [QGVAR(buttonColor), _button];
	_control setVariable [QGVAR(buttonHoverColor), [0.035, 0.045, 0.04, 0.98]];
	_control setVariable [QGVAR(buttonTextColor), _buttonText];
	_control setVariable [QGVAR(buttonHoverTextColor), _accent];
	_control ctrlSetBackgroundColor _button;
	_control ctrlSetTextColor _buttonText;
	_control ctrlSetActiveColor _accent;
};

private _isMobile = _display getVariable [QGVAR(isMobileDisplay), false];
private _orientation = _display getVariable [QGVAR(mobileOrientation), GVAR(mobileOrientation)];
private _bounds = if (_isMobile) then {
	if (_orientation isEqualTo "vertical") then {
		private _w = safeZoneW * 0.38;
		private _h = safeZoneH * 0.88;
		[safeZoneX + ((safeZoneW - _w) / 2), safeZoneY + ((safeZoneH - _h) / 2), _w, _h]
	} else {
		private _w = safeZoneW * 0.74;
		private _h = safeZoneH * 0.64;
		[safeZoneX + ((safeZoneW - _w) / 2), safeZoneY + ((safeZoneH - _h) / 2), _w, _h]
	}
} else {
	[safeZoneX, safeZoneY, safeZoneW, safeZoneH]
};
_bounds params ["_screenX", "_screenY", "_screenW", "_screenH"];

private _boxW = if (_isMobile) then {_screenW * 0.78} else {safeZoneW * 0.36};
private _boxH = if (_isMobile) then {0.16 max (_screenH * 0.20)} else {safeZoneH * 0.18};
private _boxX = _screenX + ((_screenW - _boxW) / 2);
private _boxY = _screenY + ((_screenH - _boxH) / 2);
private _progressX = _boxX + 0.024;
private _progressY = _boxY + (_boxH * 0.48);
private _progressW = _boxW - 0.048;
private _progressH = 0.018 max (_boxH * 0.11);

private _background = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc)];
private _frame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
private _title = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
private _track = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc)];
private _fill = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc)];
private _cancel = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
private _cancelFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
private _controls = [_background, _frame, _title, _track, _fill, _cancel, _cancelFrame];

_background ctrlSetBackgroundColor _panelStrong;
_background ctrlSetPosition [_boxX, _boxY, _boxW, _boxH];
_background ctrlCommit 0;
_frame ctrlSetTextColor _border;
_frame ctrlEnable false;
_frame ctrlSetPosition [_boxX, _boxY, _boxW, _boxH];
_frame ctrlCommit 0;
_title ctrlSetTextColor _text;
_title ctrlEnable false;
_title ctrlSetStructuredText parseText format [
	"<t align='center' size='0.98' font='EtelkaMonospaceProBold' color='#80ff9d'>xX MMC Intrusion Tool v3.5.6 Xx</t><br/><t align='center' size='0.66' font='EtelkaMonospacePro' color='#49d36e'>%1</t>",
	["scanning linked account index", "running mobile lock bypass"] select (_mode isEqualTo "mobile")
];
_title ctrlSetPosition [_boxX + 0.018, _boxY + 0.014, _boxW - 0.036, 0.06];
_title ctrlCommit 0;
_track ctrlSetBackgroundColor _panel;
_track ctrlSetPosition [_progressX, _progressY, _progressW, _progressH];
_track ctrlCommit 0;
_fill ctrlSetBackgroundColor _accent;
_fill ctrlSetPosition [_progressX, _progressY, 0.001, _progressH];
_fill ctrlCommit 0;
_cancel ctrlSetText "Cancel";
_cancel ctrlSetTooltip "Abort the intrusion attempt.";
[_cancel] call _setTerminalButton;
_cancel ctrlSetPosition [_boxX + ((_boxW - 0.12) / 2), _boxY + _boxH - 0.048, 0.12, 0.032];
_cancel ctrlCommit 0;
_cancelFrame ctrlSetTextColor _border;
_cancelFrame ctrlEnable false;
_cancelFrame ctrlSetPosition [_boxX + ((_boxW - 0.12) / 2), _boxY + _boxH - 0.048, 0.12, 0.032];
_cancelFrame ctrlCommit 0;

_display setVariable [QGVAR(hackingProgressControls), _controls];
[_display, true] call FUNC(hackingSetScreenLocked);

_cancel ctrlAddEventHandler ["ButtonClick", {
	params ["_control"];
	private _display = ctrlParent _control;
	if (!isNull _display) then {
		["Hacking", "MMC progress cancelled by player"] call MMC_fnc_debugLog;
		[player, false] call MMC_fnc_hackingSetEffectsLocal;
		_display setVariable [QGVAR(hackingCancelled), true];
		_display setVariable [QGVAR(hackingBusy), false];
		[_display, true, false] call MMC_fnc_hackingClose;
	};
}];

private _startTime = diag_tickTime;
[
	{
		params ["_args", "_handle"];
		_args params ["_display", "_state", "_attemptId", "_startTime", "_duration", "_fill", "_progressX", "_progressY", "_progressW", "_progressH"];

		if (
			isNull _display
			|| {!(_display getVariable [QGVAR(hackingBusy), false])}
			|| {_display getVariable [QGVAR(hackingCancelled), false]}
			|| {(_display getVariable [QGVAR(hackingAttemptId), ""]) isNotEqualTo _attemptId}
		) exitWith {
			[_handle] call CBA_fnc_removePerFrameHandler;
			[_state getOrDefault ["hacker", player], false] call MMC_fnc_hackingSetEffectsLocal;
		};

		private _progress = ((diag_tickTime - _startTime) / (_duration max 0.001)) min 1;
		if (!isNull _fill) then {
			_fill ctrlSetPosition [_progressX, _progressY, (_progressW * _progress) max 0.001, _progressH];
			_fill ctrlCommit 0;
		};

		if (_progress >= 1) then {
			[_handle] call CBA_fnc_removePerFrameHandler;
			if !(_display getVariable [QGVAR(hackingCompleted), false]) then {
				["Hacking", "MMC progress completed; opening puzzle", createHashMapFromArray [
					["attemptId", _attemptId]
				]] call MMC_fnc_debugLog;
				_display setVariable [QGVAR(hackingCompleted), true];
				(_display getVariable [QGVAR(hackingProgressControls), []]) call {
					private _controls = _this;
					{
						if (_x isEqualType controlNull && {!isNull _x}) then {
							ctrlDelete _x;
						};
					} forEach _controls;
				};
				_display setVariable [QGVAR(hackingProgressControls), []];
				[_state getOrDefault ["hacker", player], false] call MMC_fnc_hackingSetEffectsLocal;
				if ((_state getOrDefault ["mode", ""]) isEqualTo "login") then {
					_display setVariable [QGVAR(hackingBusy), false];
					[_display] call MMC_fnc_hackingRenderAccountList;
				} else {
					[_display, _state] call MMC_fnc_hackingBegin;
				};
			};
		};
	},
	0,
	[_display, _state, _attemptId, _startTime, _duration, _fill, _progressX, _progressY, _progressW, _progressH]
] call CBA_fnc_addPerFrameHandler;

true
