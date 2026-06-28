#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Renders the desktop hacking account index with redacted and cracked users.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * Rendered <BOOL>
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {false};

[_display, false, false] call FUNC(hackingClose);
[_display, true] call FUNC(hackingSetScreenLocked);

private _computer = _display getVariable [QGVAR(computer), objNull];
if (isNull _computer) exitWith {false};

private _data = _computer getVariable [QGVAR(data), _display getVariable [QGVAR(data), createHashMap]];
private _users = (_data getOrDefault ["users", []]) select {
	_x isEqualType createHashMap
	&& {(_x getOrDefault ["scope", "global"]) isEqualTo "direct"}
};

private _knownCredentials = missionNamespace getVariable [QGVAR(hackingKnownCredentials), createHashMap];
if !(_knownCredentials isEqualType createHashMap) then {
	_knownCredentials = createHashMap;
	missionNamespace setVariable [QGVAR(hackingKnownCredentials), _knownCredentials];
};

private _bg = [0.002, 0.006, 0.004, 0.985];
private _panel = [0.005, 0.035, 0.018, 0.96];
private _panelStrong = [0.0, 0.018, 0.01, 0.985];
private _text = [0.66, 1, 0.76, 1];
private _dim = [0.28, 0.72, 0.42, 1];
private _accent = [0.18, 1, 0.46, 0.95];
private _amber = [1, 0.72, 0.28, 1];
private _red = [1, 0.22, 0.18, 1];
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

private _boxW = safeZoneW * 0.54;
private _boxH = safeZoneH * 0.68;
private _boxX = safeZoneX + ((safeZoneW - _boxW) / 2);
private _boxY = safeZoneY + ((safeZoneH - _boxH) / 2);
private _controls = [];

private _background = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc)];
private _frame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
private _title = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
private _status = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
private _cancel = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
private _cancelFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];

_background ctrlSetBackgroundColor _bg;
_background ctrlSetPosition [_boxX, _boxY, _boxW, _boxH];
_background ctrlCommit 0;
_frame ctrlSetTextColor _border;
_frame ctrlEnable false;
_frame ctrlSetPosition [_boxX, _boxY, _boxW, _boxH];
_frame ctrlCommit 0;
_title ctrlSetTextColor _text;
_title ctrlEnable false;
_title ctrlSetStructuredText parseText "<t align='center' size='1.22' font='EtelkaMonospaceProBold' shadow='0' color='#80ff9d'>xX MMC Intrusion Tool v3.5.6 Xx</t><br/><t align='center' size='0.78' font='EtelkaMonospacePro' color='#49d36e'>// local account index recovered //</t>";
_title ctrlSetPosition [_boxX + 0.016, _boxY + 0.016, _boxW - 0.032, 0.074];
_title ctrlCommit 0;

private _statusText = _display getVariable [QGVAR(hackingLastStatus), ""];
if (_statusText isEqualTo "") then {
	_statusText = format ["%1 linked account%2 detected.", count _users, ["s", ""] select ((count _users) == 1)];
};
_status ctrlSetTextColor _amber;
_status ctrlEnable false;
_status ctrlSetStructuredText parseText format ["<t align='center' size='0.82' font='EtelkaMonospacePro'>%1</t>", _statusText];
_status ctrlSetPosition [_boxX + 0.022, _boxY + 0.094, _boxW - 0.044, 0.034];
_status ctrlCommit 0;
_display setVariable [QGVAR(hackingLastStatus), ""];

_cancel ctrlSetText "Close";
_cancel ctrlSetTooltip "Close intrusion interface.";
[_cancel] call _setTerminalButton;
_cancel ctrlSetPosition [_boxX + ((_boxW - 0.12) / 2), _boxY + _boxH - 0.052, 0.12, 0.034];
_cancel ctrlCommit 0;
_cancel ctrlAddEventHandler ["ButtonClick", {
	params ["_control"];
	[ctrlParent _control] call MMC_fnc_hackingClose;
}];
_cancelFrame ctrlSetTextColor _border;
_cancelFrame ctrlEnable false;
_cancelFrame ctrlSetPosition [_boxX + ((_boxW - 0.12) / 2), _boxY + _boxH - 0.052, 0.12, 0.034];
_cancelFrame ctrlCommit 0;

_controls append [_background, _frame, _title, _status, _cancel, _cancelFrame];

private _scramble = {
	params ["_username", "_index"];
	private _chars = ["X", "#", "$", "%", "&", "?", "7", "4", "0", "A", "Z", "/", "\\", "+", "*"];
	private _out = "";
	for "_i" from 1 to 12 do {
		_out = _out + selectRandom _chars;
	};
	format ["USR-%1 :: %2", str (_index + 1), _out]
};

private _listX = _boxX + 0.026;
private _listY = _boxY + 0.14;
private _listW = _boxW - 0.052;
private _rowGap = 0.007;
private _rowH = if (_users isNotEqualTo []) then {
	((((_boxH - 0.22) - (((count _users) - 1) * _rowGap)) / (count _users)) min 0.074) max 0.052
} else {
	0.074
};

if (_users isEqualTo []) then {
	private _empty = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
	_empty ctrlSetTextColor _red;
	_empty ctrlEnable false;
	_empty ctrlSetStructuredText parseText "<t align='center' size='0.92' font='EtelkaMonospacePro'>!! NO DIRECT ACCOUNT LINKS FOUND !!</t>";
	_empty ctrlSetPosition [_listX, _listY + 0.12, _listW, 0.05];
	_empty ctrlCommit 0;
	_controls pushBack _empty;
} else {
	{
		private _user = _x;
		private _username = _user getOrDefault ["username", ""];
		private _password = _user getOrDefault ["password", ""];
		private _lookup = toLowerANSI _username;
		private _hasKnown = _lookup in keys _knownCredentials;
		private _known = createHashMap;
		if (_hasKnown) then {
			_known = _knownCredentials get _lookup;
		};
		private _cracked = _hasKnown && {_known isEqualType createHashMap} && {(_known getOrDefault ["password", ""]) isEqualTo _password};
		private _rowY = _listY + (_forEachIndex * (_rowH + _rowGap));
		private _rowBg = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc)];
		private _rowFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
		private _name = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];

		_rowBg ctrlSetBackgroundColor ([_panelStrong, _panel] select (_forEachIndex mod 2));
		_rowBg ctrlSetPosition [_listX, _rowY, _listW, _rowH];
		_rowBg ctrlCommit 0;
		_rowFrame ctrlSetTextColor _border;
		_rowFrame ctrlEnable false;
		_rowFrame ctrlSetPosition [_listX, _rowY, _listW, _rowH];
		_rowFrame ctrlCommit 0;
		_name ctrlSetTextColor ([_dim, _text] select _cracked);
		_name ctrlEnable false;
		_name ctrlSetStructuredText parseText (if (_cracked) then {
			private _passwordLine = if (_password isEqualTo "") then {
				"<t size='0.72' font='EtelkaMonospacePro' color='#ffd27a'>No Password</t>"
			} else {
				format ["<t size='0.72' font='EtelkaMonospacePro' color='#ffd27a'>PASS: %1</t>", _password]
			};
			format [
				"<t size='0.78' font='EtelkaMonospaceProBold' color='#80ff9d'>%1</t><br/>%2",
				_username,
				_passwordLine
			]
		} else {
			format [
				"<t size='0.82' font='EtelkaMonospacePro' color='#4fd870'>%1</t><br/><t size='0.62' font='EtelkaMonospacePro' color='#3c8f55'>credential hash locked</t>",
				[_username, _forEachIndex] call _scramble
			]
		});
		_name ctrlSetPosition [_listX + 0.012, _rowY + 0.005, _listW - 0.11, _rowH - 0.008];
		_name ctrlCommit 0;
		_controls append [_rowBg, _rowFrame, _name];

		if (_cracked) then {
			private _login = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
			private _loginFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
			_login ctrlSetText "Login";
			_login ctrlSetTooltip format ["Log in as %1.", _username];
			[_login] call _setTerminalButton;
			_login setVariable [QGVAR(hackingUsername), _username];
			_login ctrlAddEventHandler ["ButtonClick", {
				params ["_control"];
				[ctrlParent _control, _control getVariable [QGVAR(hackingUsername), ""]] call MMC_fnc_hackingLoginKnown;
			}];
			_login ctrlSetPosition [_listX + _listW - 0.088, _rowY + 0.009, 0.074, _rowH - 0.018];
			_login ctrlCommit 0;
			_loginFrame ctrlSetTextColor _border;
			_loginFrame ctrlEnable false;
			_loginFrame ctrlSetPosition [_listX + _listW - 0.088, _rowY + 0.009, 0.074, _rowH - 0.018];
			_loginFrame ctrlCommit 0;
			_controls append [_login, _loginFrame];
		} else {
			private _hackIcon = _display ctrlCreate ["RscPictureKeepAspect", [_display] call FUNC(nextDynamicIdc)];
			private _hack = _display ctrlCreate [QGVAR(RscComputerInvisibleButton), [_display] call FUNC(nextDynamicIdc)];
			private _hackFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
			private _hackPos = [_listX + _listW - 0.076, _rowY + 0.008, _rowH - 0.016, _rowH - 0.016];
			_hackIcon ctrlSetText PATHTOF(img\hack_white.paa);
			_hackIcon ctrlEnable false;
			_hackIcon ctrlSetPosition [
				(_hackPos select 0) + ((_hackPos select 2) * 0.18),
				(_hackPos select 1) + ((_hackPos select 3) * 0.18),
				(_hackPos select 2) * 0.64,
				(_hackPos select 3) * 0.64
			];
			_hackIcon ctrlCommit 0;
			_hackFrame ctrlSetTextColor _accent;
			_hackFrame ctrlEnable false;
			_hackFrame ctrlSetPosition _hackPos;
			_hackFrame ctrlCommit 0;
			_hack ctrlSetTooltip "Crack this account credential.";
			_hack setVariable [QGVAR(hackingUser), _user];
			_hack ctrlAddEventHandler ["ButtonClick", {
				params ["_control"];
				[ctrlParent _control, _control getVariable [QGVAR(hackingUser), createHashMap]] call MMC_fnc_hackingStartAccount;
			}];
			_hack ctrlSetPosition _hackPos;
			_hack ctrlCommit 0;
			_controls append [_hackIcon, _hackFrame, _hack];
		};
	} forEach _users;
};

_display setVariable [QGVAR(hackingControls), _controls];
true
