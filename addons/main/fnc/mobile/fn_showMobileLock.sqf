#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Shows the native mobile lock screen before the device home screen is accessible.
 *
 * Arguments:
 * 0: Mobile display <DISPLAY>
 *
 * Return Value:
 * Lock screen shown <BOOL>
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {false};

private _deleteControls = {
	private _controls = _this;
	if !(_controls isEqualType []) exitWith {};
	private _pending = +_controls;
	while {count _pending > 0} do {
		private _control = _pending deleteAt 0;
		if (_control isEqualType []) then {
			_pending append _control;
		} else {
			if (_control isEqualType controlNull && {!isNull _control}) then {
				ctrlDelete _control;
			};
		};
	};
};

[_display getVariable [QGVAR(mobileLockControls), []]] call _deleteControls;
_display setVariable [QGVAR(mobileLockControls), []];
_display setVariable [QGVAR(mobileLockControlMap), createHashMap];

[_display] call FUNC(clearCustomControls);
[_display, false] call FUNC(setSystemOverlay);

[_display getVariable [QGVAR(standardAppIconControls), []]] call _deleteControls;
_display setVariable [QGVAR(standardAppIconControls), []];

_display setVariable [QGVAR(mobileLockScreen), true];
_display setVariable [QGVAR(startMenuOpen), false];
_display setVariable [QGVAR(mobileNavOpen), false];
_display setVariable [QGVAR(mobileCustomAppsOpen), false];

private _computer = _display getVariable [QGVAR(computer), objNull];
private _themeConfig = [_display] call FUNC(getThemeConfig);
(_display displayCtrl IDC_MMC_DESKTOP_IMAGE) ctrlSetText (_themeConfig getOrDefault ["backgroundTexture", PATHTOF(img\desktop_default_dark.paa)]);
[_display] call FUNC(applyTheme);

{
	(_display displayCtrl _x) ctrlShow false;
} forEach [
	IDC_MMC_TASKBAR,
	IDC_MMC_START_BUTTON,
	IDC_MMC_USER,
	IDC_MMC_CLOCK,
	IDC_MMC_BTN_DESKTOP,
	IDC_MMC_BTN_FILES,
	IDC_MMC_BTN_MAIL,
	IDC_MMC_BTN_MESSAGES,
	IDC_MMC_BTN_NOTES,
	IDC_MMC_APP_TITLE,
	IDC_MMC_BTN_CLOSE_APP,
	IDC_MMC_APP_LIST,
	IDC_MMC_APP_BODY,
	IDC_MMC_MEDIA_BAR,
	IDC_MMC_MEDIA_PREV,
	IDC_MMC_MEDIA_PLAY,
	IDC_MMC_MEDIA_STOP,
	IDC_MMC_MEDIA_NEXT,
	IDC_MMC_MEDIA_STATUS,
	IDC_MMC_DESKTOP_CONTENT_GROUP,
	IDC_MMC_FILE_PREVIEW_IMAGE,
	IDC_MMC_FILE_DESCRIPTION_GROUP,
	IDC_MMC_MAIL_HEADER,
	IDC_MMC_MAIL_TABLE,
	IDC_MMC_MAIL_REPLY,
	IDC_MMC_MAIL_FORWARD,
	IDC_MMC_MAIL_SCROLL_LEFT,
	IDC_MMC_MAIL_SCROLL_RIGHT,
	IDC_MMC_FRAME_MAIL_SCROLL_LEFT,
	IDC_MMC_FRAME_MAIL_SCROLL_RIGHT,
	IDC_MMC_MAIL_FROM_LABEL,
	IDC_MMC_MAIL_FROM,
	IDC_MMC_MAIL_RECIPIENT_LABEL,
	IDC_MMC_MAIL_RECIPIENT,
	IDC_MMC_MAIL_CC_LABEL,
	IDC_MMC_MAIL_CC,
	IDC_MMC_MAIL_SUBJECT_LABEL,
	IDC_MMC_MAIL_SUBJECT,
	IDC_MMC_MAIL_ATTACHMENT_LABEL,
	IDC_MMC_MAIL_ATTACHMENT,
	IDC_MMC_MAIL_ATTACHMENT_DESC_LABEL,
	IDC_MMC_MAIL_ATTACHMENT_DESC,
	IDC_MMC_MAIL_BODY_LABEL,
	IDC_MMC_MAIL_BODY_HINT,
	IDC_MMC_MAIL_BODY_GROUP,
	IDC_MMC_MAIL_BODY,
	IDC_MMC_MAIL_READ_META,
	IDC_MMC_MAIL_READ_GROUP,
	IDC_MMC_MAIL_SEND,
	IDC_MMC_MAIL_CANCEL,
	IDC_MMC_MAIL_ERROR,
	IDC_MMC_START_MENU,
	IDC_MMC_FRAME_START_MENU,
	IDC_MMC_START_BOOT,
	IDC_MMC_FRAME_START_BOOT,
	IDC_MMC_START_LOGOUT,
	IDC_MMC_FRAME_START_LOGOUT,
	IDC_MMC_START_SHUTDOWN,
	IDC_MMC_FRAME_START_SHUTDOWN,
	IDC_MMC_LOGIN_PANEL,
	IDC_MMC_FRAME_LOGIN_PANEL,
	IDC_MMC_LOGIN_TITLE,
	IDC_MMC_LOGIN_USERNAME_LABEL,
	IDC_MMC_LOGIN_USERNAME,
	IDC_MMC_FRAME_LOGIN_USERNAME,
	IDC_MMC_LOGIN_PASSWORD_LABEL,
	IDC_MMC_LOGIN_PASSWORD,
	IDC_MMC_FRAME_LOGIN_PASSWORD,
	IDC_MMC_LOGIN_PASSWORD_VISIBLE,
	IDC_MMC_LOGIN_PASSWORD_TOGGLE,
	IDC_MMC_FRAME_LOGIN_PASSWORD_TOGGLE,
	IDC_MMC_LOGIN_BUTTON,
	IDC_MMC_FRAME_LOGIN_BUTTON,
	IDC_MMC_LOGIN_SHUTDOWN,
	IDC_MMC_FRAME_LOGIN_SHUTDOWN,
	IDC_MMC_LOGIN_ERROR,
	IDC_MMC_FRAME_TASKBAR,
	IDC_MMC_FRAME_BTN_DESKTOP,
	IDC_MMC_FRAME_BTN_FILES,
	IDC_MMC_FRAME_BTN_MAIL,
	IDC_MMC_FRAME_BTN_MESSAGES,
	IDC_MMC_FRAME_BTN_NOTES,
	IDC_MMC_FRAME_APP_TITLE,
	IDC_MMC_FRAME_CLOSE_APP,
	IDC_MMC_FRAME_APP_LIST,
	IDC_MMC_FRAME_APP_BODY,
	IDC_MMC_FRAME_MEDIA_BAR,
	IDC_MMC_FRAME_MEDIA_PREV,
	IDC_MMC_FRAME_MEDIA_PLAY,
	IDC_MMC_FRAME_MEDIA_STOP,
	IDC_MMC_FRAME_MEDIA_NEXT,
	IDC_MMC_FRAME_FILE_PREVIEW_IMAGE,
	IDC_MMC_FRAME_FILE_DESCRIPTION,
	IDC_MMC_FRAME_MAIL_TABLE,
	IDC_MMC_FRAME_START_BUTTON
];

private _panel = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc)];
private _frame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
private _time = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
private _dateText = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
private _dots = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
private _prompt = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
private _error = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
private _confirm = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
private _confirmFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
private _confirmIcon = _display ctrlCreate ["RscPictureKeepAspect", [_display] call FUNC(nextDynamicIdc)];
private _delete = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
private _deleteFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
private _canHack = [_display, "mobile"] call FUNC(hackingCanStart);
private _hack = controlNull;
private _hackPatch = controlNull;
private _hackFrame = controlNull;
private _hackIcon = controlNull;
private _hackLabel = controlNull;
if (_canHack) then {
	_hackPatch = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc)];
	_hackFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
	_hackIcon = _display ctrlCreate ["RscPictureKeepAspect", [_display] call FUNC(nextDynamicIdc)];
	_hackLabel = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
	_hack = _display ctrlCreate [QGVAR(RscComputerInvisibleButton), [_display] call FUNC(nextDynamicIdc)];
};
private _buttons = [];
private _buttonFrames = [];

private _panelStrong = _themeConfig getOrDefault ["panelStrong", [0.015, 0.018, 0.024, 0.98]];
private _textColor = _themeConfig getOrDefault ["text", [0.92, 0.94, 0.97, 1]];
private _buttonColor = _themeConfig getOrDefault ["button", [0.028, 0.032, 0.042, 0.98]];
private _buttonText = _themeConfig getOrDefault ["buttonText", _textColor];
private _hoverText = _themeConfig getOrDefault ["buttonHoverText", _buttonText];
private _border = _themeConfig getOrDefault ["border", [0, 0, 0, 0.85]];

_panel ctrlSetBackgroundColor _panelStrong;
_frame ctrlSetTextColor _border;
_frame ctrlEnable false;
{
	_x ctrlSetTextColor _textColor;
	_x ctrlSetBackgroundColor [0, 0, 0, 0];
	_x ctrlEnable false;
} forEach [_time, _dateText, _dots, _prompt, _error];
_error ctrlSetTextColor [1, 0.25, 0.25, 1];

private _pad = {
	params [["_value", 0, [0]]];
	if (_value < 10) then {
		format ["0%1", _value]
	} else {
		str _value
	}
};
date params ["_year", "_month", "_day", "_hour", "_minute"];
_time ctrlSetStructuredText parseText format ["<t align='center' size='2.8' shadow='0'>%1:%2</t>", [_hour] call _pad, [_minute] call _pad];
_dateText ctrlSetStructuredText parseText format ["<t align='center' size='1.0' shadow='0'>%1.%2.%3</t>", [_day] call _pad, [_month] call _pad, _year];
_prompt ctrlSetStructuredText parseText "<t align='center' size='0.92' shadow='0'>Enter code to access this device</t>";
_error ctrlSetStructuredText parseText "";

for "_digit" from 1 to 9 do {
	private _button = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
	private _buttonFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
	_button ctrlSetText str _digit;
	_button ctrlSetFontHeight 0.034;
	_button ctrlSetBackgroundColor _buttonColor;
	_button ctrlSetTextColor _buttonText;
	_button ctrlSetActiveColor _hoverText;
	_button setVariable [QGVAR(mobileLockDigit), str _digit];
	_button ctrlAddEventHandler ["ButtonClick", {
		params ["_control"];
		private _display = ctrlParent _control;
		private _digit = _control getVariable [QGVAR(mobileLockDigit), ""];
		private _input = _display getVariable [QGVAR(mobileLockInput), ""];
		[_display, _input + _digit] call MMC_fnc_setMobileLockInput;
	}];
	_buttonFrame ctrlSetTextColor _border;
	_buttonFrame ctrlEnable false;
	_buttons pushBack _button;
	_buttonFrames pushBack _buttonFrame;
};

_confirm ctrlSetText "";
_confirm ctrlSetTooltip "Unlock";
_confirm ctrlSetBackgroundColor _buttonColor;
_confirm ctrlSetTextColor _buttonText;
_confirm ctrlSetActiveColor _hoverText;
_confirm ctrlAddEventHandler ["ButtonClick", {call MMC_fnc_unlockMobile}];
_confirmFrame ctrlSetTextColor _border;
_confirmFrame ctrlEnable false;
_confirmIcon ctrlEnable false;
_confirmIcon ctrlSetTextColor [1, 1, 1, 1];
_delete ctrlSetText "Del";
_delete ctrlSetTooltip "Delete last number";
_delete ctrlSetFontHeight 0.024;
_delete ctrlSetBackgroundColor _buttonColor;
_delete ctrlSetTextColor _buttonText;
_delete ctrlSetActiveColor _hoverText;
_delete ctrlAddEventHandler ["ButtonClick", {
	params ["_control"];
	private _display = ctrlParent _control;
	private _input = _display getVariable [QGVAR(mobileLockInput), ""];
	if (_input isNotEqualTo "") then {
		[_display, _input select [0, (count _input - 1) max 0]] call MMC_fnc_setMobileLockInput;
	};
}];
_deleteFrame ctrlSetTextColor _border;
_deleteFrame ctrlEnable false;

if (_canHack) then {
	_hackPatch ctrlSetBackgroundColor [0.01, 0.012, 0.014, 0.96];
	_hackPatch ctrlEnable false;
	_hackFrame ctrlSetTextColor _border;
	_hackFrame ctrlEnable false;
	_hackIcon ctrlSetText PATHTOF(img\hack_white.paa);
	_hackIcon ctrlEnable false;
	_hackLabel ctrlSetStructuredText parseText "";
	_hackLabel ctrlEnable false;
	_hack ctrlSetTooltip "Start a timed security bypass.";
	_hack ctrlEnable true;
	_hack ctrlAddEventHandler ["ButtonClick", {
		params ["_control"];
		[ctrlParent _control, "mobile"] call MMC_fnc_hackingStart;
	}];
};

private _allControls = [_panel, _frame, _time, _dateText, _dots, _prompt, _error, _confirm, _confirmFrame, _confirmIcon, _delete, _deleteFrame, _hackPatch, _hackFrame, _hackIcon, _hackLabel, _hack] + _buttons + _buttonFrames;
_display setVariable [QGVAR(mobileLockControls), _allControls];
_display setVariable [QGVAR(mobileLockControlMap), createHashMapFromArray [
	["panel", _panel],
	["frame", _frame],
	["time", _time],
	["date", _dateText],
	["dots", _dots],
	["prompt", _prompt],
	["error", _error],
	["buttons", _buttons],
	["buttonFrames", _buttonFrames],
	["confirm", _confirm],
	["confirmFrame", _confirmFrame],
	["confirmIcon", _confirmIcon],
	["delete", _delete],
	["deleteFrame", _deleteFrame],
	["hack", _hack],
	["hackPatch", _hackPatch],
	["hackFrame", _hackFrame],
	["hackIcon", _hackIcon],
	["hackLabel", _hackLabel]
]];

if ((_display getVariable [QGVAR(mobileLockKeyEh), -1]) < 0) then {
	private _keyEh = _display displayAddEventHandler ["KeyDown", {
		params ["_display", "_key"];
		[_display, _key] call MMC_fnc_handleMobileLockKey
	}];
	_display setVariable [QGVAR(mobileLockKeyEh), _keyEh];
};

_display setVariable [QGVAR(passwordVisible), false];
[_display, ""] call FUNC(setMobileLockInput);

["Mobile", "Showing mobile lock screen", createHashMapFromArray [
	["device", _computer],
	["source", _display getVariable [QGVAR(mobileLockCodeSource), "clientSetting"]],
	["hasCode", (_display getVariable [QGVAR(mobileLockCode), ""]) isNotEqualTo ""]
]] call FUNC(debugLog);

if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
	[_display] call FUNC(applyMobileDisplayLayout);
};

private _focusSink = _display getVariable [QGVAR(mobileFocusSinkControl), controlNull];
if (!isNull _focusSink) then {
	ctrlSetFocus _focusSink;
};

true
