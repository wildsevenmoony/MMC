#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Renders the MMC hacking word puzzle overlay.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * Rendered <BOOL>
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {false};

private _state = _display getVariable [QGVAR(hackingState), createHashMap];
if (count _state == 0) exitWith {false};

[_display, false, false] call FUNC(hackingClose);
[_display, true] call FUNC(hackingSetScreenLocked);

private _panel = [0.005, 0.035, 0.018, 0.96];
private _panelStrong = [0.002, 0.006, 0.004, 0.985];
private _text = [0.66, 1, 0.76, 1];
private _button = [0.012, 0.11, 0.045, 0.98];
private _buttonText = [0.72, 1, 0.80, 1];
private _border = [0.16, 0.95, 0.38, 0.95];
private _accent = [0.18, 1, 0.46, 0.95];
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

private _boxW = if (_isMobile) then {_screenW * 0.84} else {safeZoneW * 0.42};
private _boxH = if (_isMobile) then {_screenH * ([0.66, 0.78] select (_orientation isEqualTo "vertical"))} else {safeZoneH * 0.58};
private _boxX = _screenX + ((_screenW - _boxW) / 2);
private _boxY = _screenY + ((_screenH - _boxH) / 2);

private _controls = [];
private _background = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc)];
private _frame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
private _title = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
private _status = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
private _historyText = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
private _cancel = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
private _cancelFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];

_background ctrlSetBackgroundColor _panelStrong;
_background ctrlSetPosition [_boxX, _boxY, _boxW, _boxH];
_background ctrlCommit 0;
_frame ctrlSetTextColor _border;
_frame ctrlEnable false;
_frame ctrlSetPosition [_boxX, _boxY, _boxW, _boxH];
_frame ctrlCommit 0;

_title ctrlSetTextColor _text;
_title ctrlSetBackgroundColor [0, 0, 0, 0];
_title ctrlEnable false;
_title ctrlSetStructuredText parseText format [
	"<t align='center' size='1.13' font='EtelkaMonospaceProBold' color='#80ff9d'>xX MMC Intrusion Tool v3.5.6 Xx</t><br/><t align='center' size='0.78' font='EtelkaMonospacePro' color='#49d36e'>target // %1</t><br/><t align='center' size='0.58' font='EtelkaMonospacePro' color='#2f8f4a'>[entropy bloom] [bruteforce lattice] [checksum ghost]</t>",
	_state getOrDefault ["targetLabel", "Unknown"]
];
_title ctrlSetPosition [_boxX + 0.012, _boxY + 0.012, _boxW - 0.024, 0.096];
_title ctrlCommit 0;

private _attemptsLeft = _state getOrDefault ["attemptsLeft", 0];
private _attemptsMax = _state getOrDefault ["attemptsMax", 1];
private _lockedOut = _state getOrDefault ["lockedOut", false];
private _statusLine = if (_lockedOut) then {
	"<t align='center' color='#ff5050' font='RobotoCondensedBold'>ACCESS LOCKED OUT</t>"
} else {
	format ["<t align='center' font='EtelkaMonospacePro'>attempts remaining :: %1 / %2</t>", _attemptsLeft, _attemptsMax]
};

_status ctrlSetTextColor _text;
_status ctrlSetBackgroundColor _panel;
_status ctrlEnable false;
_status ctrlSetStructuredText parseText _statusLine;
_status ctrlSetPosition [_boxX + 0.018, _boxY + 0.116, _boxW - 0.036, 0.036];
_status ctrlCommit 0;

private _history = _state getOrDefault ["history", []];
private _historyLines = _history apply {
	_x params ["_word", "_match"];
	format ["%1  -  likeness %2/6", _word, _match]
};
if (_historyLines isEqualTo []) then {
	_historyLines = ["select candidate // correct positions are reported as LIKENESS"];
};
_historyText ctrlSetTextColor _text;
_historyText ctrlSetBackgroundColor [0, 0, 0, 0.18];
_historyText ctrlEnable false;
_historyText ctrlSetStructuredText parseText format ["<t size='0.76' font='EtelkaMonospacePro' color='#ffd27a'>%1</t>", _historyLines joinString "<br/>"];
_historyText ctrlSetPosition [_boxX + 0.018, _boxY + _boxH - 0.182, _boxW - 0.036, 0.118];
_historyText ctrlCommit 0;

_cancel ctrlSetText "Cancel";
_cancel ctrlSetTooltip "Close hacking interface.";
[_cancel] call _setTerminalButton;
_cancel ctrlAddEventHandler ["ButtonClick", {
	params ["_control"];
	[ctrlParent _control] call MMC_fnc_hackingClose;
}];
_cancel ctrlSetPosition [_boxX + ((_boxW - 0.12) / 2), _boxY + _boxH - 0.052, 0.12, 0.036];
_cancel ctrlCommit 0;
_cancelFrame ctrlSetTextColor _border;
_cancelFrame ctrlEnable false;
_cancelFrame ctrlSetPosition [_boxX + ((_boxW - 0.12) / 2), _boxY + _boxH - 0.052, 0.12, 0.036];
_cancelFrame ctrlCommit 0;

_controls append [_background, _frame, _title, _status, _historyText, _cancel, _cancelFrame];

private _words = _state getOrDefault ["words", []];
private _cols = [4, 3] select (_isMobile && {_orientation isEqualTo "vertical"});
private _gap = 0.006;
private _wordAreaX = _boxX + 0.018;
private _wordAreaY = _boxY + 0.17;
private _wordAreaW = _boxW - 0.036;
private _wordAreaH = (_boxH - 0.37) max 0.16;
private _rows = ceil ((count _words) / _cols);
private _buttonW = (_wordAreaW - ((_cols - 1) * _gap)) / _cols;
private _buttonH = ((_wordAreaH - ((_rows - 1) * _gap)) / (_rows max 1)) min 0.038;
private _blockH = (_rows * _buttonH) + (((_rows - 1) max 0) * _gap);
_wordAreaY = _wordAreaY + (((_wordAreaH - _blockH) max 0) / 2);

{
	private _word = if (_x isEqualType "") then {_x} else {str _x};
	private _row = floor (_forEachIndex / _cols);
	private _col = _forEachIndex mod _cols;
	private _wordButton = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
	private _wordFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
	private _pos = [
		_wordAreaX + (_col * (_buttonW + _gap)),
		_wordAreaY + (_row * (_buttonH + _gap)),
		_buttonW,
		_buttonH
	];

	_wordButton ctrlSetText _word;
	_wordButton ctrlSetTooltip "Probe this candidate password.";
	[_wordButton] call _setTerminalButton;
	_wordButton ctrlEnable (!_lockedOut && {_attemptsLeft > 0});
	_wordButton setVariable [QGVAR(hackingWord), _word];
	_wordButton ctrlAddEventHandler ["ButtonClick", {
		params ["_control"];
		private _word = _control getVariable [QGVAR(hackingWord), ""];
		[ctrlParent _control, _word] call MMC_fnc_hackingSelect;
	}];
	_wordButton ctrlSetPosition _pos;
	_wordButton ctrlCommit 0;

	_wordFrame ctrlSetTextColor _border;
	_wordFrame ctrlEnable false;
	_wordFrame ctrlSetPosition _pos;
	_wordFrame ctrlCommit 0;

	_controls append [_wordButton, _wordFrame];
} forEach _words;

_display setVariable [QGVAR(hackingControls), _controls];
true
