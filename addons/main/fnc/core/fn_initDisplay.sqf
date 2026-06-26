#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Initializes the MMC computer dialog.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {};

uiNamespace setVariable [QGVAR(display), _display];

private _computer = GVAR(activeComputer);
private _data = _computer getVariable [QGVAR(data), [createHashMap] call FUNC(createDefaultData)];
private _loginRequired = _data getOrDefault ["loginRequired", true];
private _isMobileDisplay = (_computer getVariable [QGVAR(isMobileComputer), false]) || {missionNamespace getVariable [QGVAR(openingMobile), false]};
missionNamespace setVariable [QGVAR(openingMobile), false];
_display setVariable [QGVAR(computer), _computer];
_display setVariable [QGVAR(data), _data];
_display setVariable [QGVAR(currentApp), "desktop"];
_display setVariable [QGVAR(startMenuOpen), false];
_display setVariable [QGVAR(isMobileDisplay), _isMobileDisplay];
private _mobileOrientation = if (_isMobileDisplay) then {
	_computer getVariable [QGVAR(mobileDefaultOrientation), GVAR(mobileOrientation)]
} else {
	GVAR(mobileOrientation)
};
if !(_mobileOrientation in ["horizontal", "vertical"]) then {
	_mobileOrientation = "horizontal";
};
_display setVariable [QGVAR(mobileOrientation), _mobileOrientation];

private _revealMobileDisplay = {
	if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
		{
			_x ctrlSetFade 0;
			_x ctrlCommit 0;
		} forEach allControls _display;
	};
};

if (_isMobileDisplay) then {
	{
		_x ctrlSetFade 1;
		_x ctrlCommit 0;
	} forEach allControls _display;
};

private _activeUser = [_computer] call FUNC(getActiveUser);
_display setVariable [QGVAR(activeUser), _activeUser];

private _themeConfig = [_display] call FUNC(getThemeConfig);
(_display displayCtrl IDC_MMC_DESKTOP_IMAGE) ctrlSetText (_themeConfig getOrDefault ["backgroundTexture", PATHTOF(img\desktop_default_dark.paa)]);

[_display] call FUNC(applyTheme);

{
	(_display displayCtrl _x) ctrlShow false;
} forEach [
	IDC_MMC_START_MENU,
	IDC_MMC_FRAME_START_MENU,
	IDC_MMC_START_BOOT,
	IDC_MMC_FRAME_START_BOOT,
	IDC_MMC_START_LOGOUT,
	IDC_MMC_FRAME_START_LOGOUT,
	IDC_MMC_START_SHUTDOWN,
	IDC_MMC_FRAME_START_SHUTDOWN,
	IDC_MMC_MEDIA_BAR,
	IDC_MMC_MEDIA_PREV,
	IDC_MMC_MEDIA_PLAY,
	IDC_MMC_MEDIA_STOP,
	IDC_MMC_MEDIA_NEXT,
	IDC_MMC_MEDIA_STATUS,
	IDC_MMC_FRAME_MEDIA_BAR,
	IDC_MMC_FRAME_MEDIA_PREV,
	IDC_MMC_FRAME_MEDIA_PLAY,
	IDC_MMC_FRAME_MEDIA_STOP,
	IDC_MMC_FRAME_MEDIA_NEXT,
	IDC_MMC_DESKTOP_CONTENT_GROUP,
	IDC_MMC_FILE_PREVIEW_IMAGE,
	IDC_MMC_FRAME_FILE_PREVIEW_IMAGE,
	IDC_MMC_FILE_DESCRIPTION_GROUP,
	IDC_MMC_FRAME_FILE_DESCRIPTION,
	IDC_MMC_MAIL_HEADER,
	IDC_MMC_MAIL_TABLE,
	IDC_MMC_FRAME_MAIL_TABLE,
	IDC_MMC_MAIL_SCROLL_LEFT,
	IDC_MMC_MAIL_SCROLL_RIGHT,
	IDC_MMC_FRAME_MAIL_SCROLL_LEFT,
	IDC_MMC_FRAME_MAIL_SCROLL_RIGHT,
	IDC_MMC_MAIL_REPLY,
	IDC_MMC_MAIL_FORWARD,
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
	IDC_MMC_LOGIN_PANEL,
	IDC_MMC_FRAME_LOGIN_PANEL,
	IDC_MMC_LOGIN_TITLE,
	IDC_MMC_LOGIN_USERNAME_LABEL,
	IDC_MMC_LOGIN_USERNAME,
	IDC_MMC_FRAME_LOGIN_USERNAME,
	IDC_MMC_LOGIN_PASSWORD_LABEL,
	IDC_MMC_LOGIN_PASSWORD,
	IDC_MMC_LOGIN_PASSWORD_VISIBLE,
	IDC_MMC_FRAME_LOGIN_PASSWORD,
	IDC_MMC_LOGIN_PASSWORD_TOGGLE,
	IDC_MMC_FRAME_LOGIN_PASSWORD_TOGGLE,
	IDC_MMC_LOGIN_BUTTON,
	IDC_MMC_FRAME_LOGIN_BUTTON,
	IDC_MMC_LOGIN_SHUTDOWN,
	IDC_MMC_FRAME_LOGIN_SHUTDOWN,
	IDC_MMC_LOGIN_ERROR
];

[] call FUNC(updateClock);

if (_computer getVariable [QGVAR(booting), false]) exitWith {
	[_display, true, ["MMC", "Starting system...", "Powering hardware interfaces"], 0.08] call FUNC(setSystemOverlay);
	[_display] call FUNC(applyMobileDisplayLayout);
	call _revealMobileDisplay;
};

if (_isMobileDisplay && {!(_display getVariable [QGVAR(mobileUnlocked), false])}) exitWith {
	private _lockCodeSet = _computer getVariable [QGVAR(mobileLockCodeSet), false];
	private _lockCode = if (_lockCodeSet) then {
		[_computer getVariable [QGVAR(mobileLockCode), _data getOrDefault ["mobileLockCode", ""]]] call CBA_fnc_trim
	} else {
		[missionNamespace getVariable [QGVAR(mobileLockCode), ""]] call CBA_fnc_trim
	};
	_display setVariable [QGVAR(mobileLockCode), _lockCode];
	_display setVariable [QGVAR(mobileLockCodeSource), _computer getVariable [QGVAR(mobileLockCodeSource), ["clientSetting", "profileOrDevice"] select _lockCodeSet]];
	_display setVariable [QGVAR(mobileUnlocked), false];
	[_display] call FUNC(showMobileLock);
	[_display] call FUNC(applyMobileDisplayLayout);
	call _revealMobileDisplay;
};

if (count _activeUser == 0) then {
	if (_loginRequired) then {
		[_display] call FUNC(showLogin);
	} else {
		[_display] call FUNC(showNoUser);
	};
} else {
	[_display] call FUNC(hideLogin);
	["desktop"] call FUNC(renderApp);
};

if (_isMobileDisplay) then {
	[_display] call FUNC(applyMobileDisplayLayout);
	call _revealMobileDisplay;
};

[_display] spawn {
	params ["_display"];
	while {!isNull _display} do {
		[] call MMC_fnc_updateClock;
		uiSleep 15;
	};
};

if (_isMobileDisplay) then {
	[_display] spawn {
		params ["_display"];
		while {!isNull _display && {_display getVariable [QGVAR(isMobileDisplay), false]}} do {
			[_display] call MMC_fnc_applyMobileDisplayLayout;
			uiSleep 0.2;
		};
	};
};
