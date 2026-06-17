#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Applies the native phone/tablet layout to the shared MMC controls.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * Applied <BOOL>
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display || {!(_display getVariable [QGVAR(isMobileDisplay), false])}) exitWith {false};

private _orientation = _display getVariable [QGVAR(mobileOrientation), GVAR(mobileOrientation)];
if !(_orientation in ["horizontal", "vertical"]) then {
	_orientation = "horizontal";
};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _bounds = if (_orientation isEqualTo "vertical") then {
	private _w = safeZoneW * 0.38;
	private _h = safeZoneH * 0.88;
	[safeZoneX + ((safeZoneW - _w) / 2), safeZoneY + ((safeZoneH - _h) / 2), _w, _h]
} else {
	private _w = safeZoneW * 0.74;
	private _h = safeZoneH * 0.64;
	[safeZoneX + ((safeZoneW - _w) / 2), safeZoneY + ((safeZoneH - _h) / 2), _w, _h]
};
_bounds params ["_screenX", "_screenY", "_screenW", "_screenH"];

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _panelStrong = _themeConfig getOrDefault ["panelStrong", [0.015, 0.018, 0.024, 0.98]];
private _buttonText = _themeConfig getOrDefault ["buttonText", [0.92, 0.94, 0.97, 1]];
private _button = _themeConfig getOrDefault ["button", [0.028, 0.032, 0.042, 0.98]];
private _buttonHoverText = _themeConfig getOrDefault ["buttonHoverText", _buttonText];
private _border = _themeConfig getOrDefault ["border", [0, 0, 0, 0.85]];
private _gap = 0.008;
private _titleH = 0.05;
private _taskbarH = (0.045 max (_screenH * 0.058)) min 0.06;
private _taskbarY = _screenY + _screenH - _taskbarH;
private _dockH = [0, 0.058] select (_orientation isEqualTo "vertical");
private _dockY = _taskbarY - _dockH - _gap;
private _railW = if (_orientation isEqualTo "horizontal") then {(0.064 max (_screenW * 0.07)) min 0.085} else {0};
private _navHandleW = 0.034;
private _navHandleGap = 0.006;
_display setVariable [QGVAR(startMenuOpen), false];

private _set = {
	params ["_idc", "_pos"];
	private _ctrl = _display displayCtrl _idc;
	if (!isNull _ctrl) then {
		_ctrl ctrlSetPosition _pos;
		_ctrl ctrlCommit 0;
	};
};

private _setGroupChildWidth = {
	params ["_idc", "_w"];
	private _ctrl = _display displayCtrl _idc;
	if (!isNull _ctrl) then {
		private _pos = ctrlPosition _ctrl;
		_pos set [2, _w max 0.001];
		_ctrl ctrlSetPosition _pos;
		_ctrl ctrlCommit 0;
	};
};

private _collapseMobilePanesOnClick = {
	params ["_control"];
	private _display = ctrlParent _control;
	if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
		if (diag_tickTime < (_display getVariable [QGVAR(mobilePaneKeepOpenUntil), -1])) exitWith {};
		private _hadPaneOpen = (_display getVariable [QGVAR(mobileNavOpen), false]) || {_display getVariable [QGVAR(mobileCustomAppsOpen), false]};
		if (!_hadPaneOpen) exitWith {};
		_display setVariable [QGVAR(mobileNavOpen), false];
		_display setVariable [QGVAR(mobileCustomAppsOpen), false];
		[_display] call MMC_fnc_applyMobileDisplayLayout;
	};
	false
};

private _focusSink = _display getVariable [QGVAR(mobileFocusSinkControl), controlNull];
if (isNull _focusSink) then {
	_focusSink = _display ctrlCreate ["RscEdit", [_display] call FUNC(nextDynamicIdc)];
	_focusSink ctrlSetPosition [-10, -10, 0.001, 0.001];
	_focusSink ctrlSetText "";
	_focusSink ctrlSetTextColor [0, 0, 0, 0];
	_focusSink ctrlSetBackgroundColor [0, 0, 0, 0];
	_focusSink ctrlCommit 0;
	_display setVariable [QGVAR(mobileFocusSinkControl), _focusSink];
};

private _addCollapseHandler = {
	params ["_ctrl"];
	if (isNull _ctrl) exitWith {};
	if !(_ctrl getVariable [QGVAR(mobileCollapseHandlerAdded), false]) then {
		_ctrl ctrlAddEventHandler ["MouseButtonDown", _collapseMobilePanesOnClick];
		_ctrl setVariable [QGVAR(mobileCollapseHandlerAdded), true];
	};
};

{
	[_x, [_screenX, _screenY, _screenW, _screenH]] call _set;
} forEach [IDC_MMC_DESKTOP_BG, IDC_MMC_DESKTOP_TINT, IDC_MMC_DESKTOP_IMAGE];

private _shellFrame = _display getVariable [QGVAR(mobileShellFrameControl), controlNull];
if (isNull _shellFrame) then {
	_shellFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
	_shellFrame ctrlEnable false;
	_shellFrame setVariable [QGVAR(mobileNoTransform), true];
	_display setVariable [QGVAR(mobileShellFrameControl), _shellFrame];
};
_shellFrame ctrlSetTextColor _border;
_shellFrame ctrlSetPosition [_screenX, _screenY, _screenW, _screenH];
_shellFrame ctrlShow true;
_shellFrame ctrlCommit 0;

{
	[_x, [_screenX, _taskbarY, _screenW, _taskbarH]] call _set;
} forEach [IDC_MMC_TASKBAR, IDC_MMC_FRAME_TASKBAR];

private _clockW = if (_orientation isEqualTo "vertical") then {
	(0.22 min (_screenW * 0.58)) max 0.17
} else {
	(0.21 min (_screenW * 0.28)) max 0.18
};
private _userW = (_screenW - _clockW - (_gap * 3)) max 0.02;
{
	_x params ["_idc", "_pos"];
	[_idc, _pos] call _set;
} forEach [
	[IDC_MMC_START_BUTTON, [_screenX + _gap, _taskbarY + 0.006, 0, _taskbarH - 0.012]],
	[IDC_MMC_FRAME_START_BUTTON, [_screenX + _gap, _taskbarY + 0.006, 0, _taskbarH - 0.012]],
	[IDC_MMC_USER, [_screenX + _gap, _taskbarY + 0.006, _userW, _taskbarH - 0.012]],
	[IDC_MMC_CLOCK, [_screenX + _screenW - _clockW - _gap, _taskbarY + 0.006, _clockW, _taskbarH - 0.012]]
];

private _startButton = _display displayCtrl IDC_MMC_START_BUTTON;
_startButton ctrlShow false;
(_display displayCtrl IDC_MMC_FRAME_START_BUTTON) ctrlShow false;
_startButton ctrlSetText "";
_startButton ctrlSetTooltip "";
_startButton ctrlSetTextColor _buttonText;
_startButton ctrlSetActiveColor (_themeConfig getOrDefault ["buttonHoverText", _buttonText]);
private _startIcon = _display getVariable [QGVAR(mobileStartIconControl), controlNull];
if (!isNull _startIcon) then {
	ctrlDelete _startIcon;
	_display setVariable [QGVAR(mobileStartIconControl), controlNull];
};
_startButton setVariable [QGVAR(mobileIconControl), controlNull];

private _rotate = _display getVariable [QGVAR(mobileRotateControl), controlNull];
private _rotateFrame = _display getVariable [QGVAR(mobileRotateFrameControl), controlNull];
if (isNull _rotate) then {
	_rotate = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
	_rotate ctrlSetTooltip "Switch mobile screen orientation.";
	_rotate ctrlAddEventHandler ["ButtonClick", {call MMC_fnc_toggleMobileOrientation}];
	_rotate setVariable [QGVAR(mobileNoTransform), true];
	_display setVariable [QGVAR(mobileRotateControl), _rotate];
};
if (isNull _rotateFrame) then {
	_rotateFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
	_rotateFrame ctrlEnable false;
	_rotateFrame setVariable [QGVAR(mobileNoTransform), true];
	_display setVariable [QGVAR(mobileRotateFrameControl), _rotateFrame];
};
_rotate ctrlSetText "";
_rotate ctrlSetBackgroundColor (_themeConfig getOrDefault ["button", [0.028, 0.032, 0.042, 0.98]]);
_rotate ctrlSetTextColor _buttonText;
_rotate ctrlSetActiveColor (_themeConfig getOrDefault ["buttonHoverText", _buttonText]);
_rotateFrame ctrlSetTextColor _border;
private _rotateIcon = _display getVariable [QGVAR(mobileRotateIconControl), controlNull];
if (isNull _rotateIcon) then {
	_rotateIcon = _display ctrlCreate ["RscPictureKeepAspect", [_display] call FUNC(nextDynamicIdc)];
	_rotateIcon ctrlEnable false;
	_rotateIcon setVariable [QGVAR(mobileNoTransform), true];
	_display setVariable [QGVAR(mobileRotateIconControl), _rotateIcon];
};
private _iconLuma = ((_buttonText select 0) * 0.299) + ((_buttonText select 1) * 0.587) + ((_buttonText select 2) * 0.114);
private _useBlackIcon = _iconLuma < 0.5;
private _rotateIconPath = if (_orientation isEqualTo "vertical") then {
	[PATHTOF(img\rotate_white_left.paa), PATHTOF(img\rotate_black_left.paa)] select _useBlackIcon
} else {
	[PATHTOF(img\rotate_white_right.paa), PATHTOF(img\rotate_black_right.paa)] select _useBlackIcon
};
_rotateIcon ctrlSetText _rotateIconPath;
_rotateIcon ctrlSetTextColor [1, 1, 1, 1];
_rotate setVariable [QGVAR(mobileIconControl), _rotateIcon];
_rotate setVariable [QGVAR(mobileIconPath), _rotateIconPath];
_rotate setVariable [QGVAR(mobileIconHoverPath), [PATHTOF(img\rotate_white_right.paa), PATHTOF(img\rotate_white_left.paa)] select (_orientation isEqualTo "vertical")];

private _getArrowIcon = {
	params [["_direction", "right", [""]]];
	switch (toLowerANSI _direction) do {
		case "left": {[PATHTOF(img\arrow_left_white.paa), PATHTOF(img\arrow_left_black.paa)] select _useBlackIcon};
		case "right": {[PATHTOF(img\arrow_right_white.paa), PATHTOF(img\arrow_right_black.paa)] select _useBlackIcon};
		case "up": {[PATHTOF(img\arrow_up_white.paa), PATHTOF(img\arrow_up_black.paa)] select _useBlackIcon};
		case "down": {[PATHTOF(img\arrow_down_white.paa), PATHTOF(img\arrow_down_black.paa)] select _useBlackIcon};
		default {[PATHTOF(img\arrow_right_white.paa), PATHTOF(img\arrow_right_black.paa)] select _useBlackIcon};
	};
};

private _setArrowIcon = {
	params ["_key", "_button", "_direction", ["_show", true, [true]]];
	if (isNull _button) exitWith {};

	_button ctrlSetText "";

	private _icon = _display getVariable [_key, controlNull];
	if (!isNull _icon) then {
		ctrlDelete _icon;
		_display setVariable [_key, controlNull];
	};

	private _visible = _show && {ctrlShown _button};
	if (!_visible) exitWith {};

	_icon = _display ctrlCreate ["RscPictureKeepAspect", [_display] call FUNC(nextDynamicIdc)];
	_icon ctrlEnable false;
	_icon setVariable [QGVAR(mobileNoTransform), true];
	_display setVariable [_key, _icon];
	_icon ctrlShow true;

	private _buttonPos = ctrlPosition _button;
	private _iconSize = (((_buttonPos select 2) min (_buttonPos select 3)) * 0.58) max 0.01;
	_icon ctrlSetText ([_direction] call _getArrowIcon);
	_icon ctrlSetTextColor [1, 1, 1, 1];
	_icon ctrlSetPosition [
		(_buttonPos select 0) + (((_buttonPos select 2) - _iconSize) / 2),
		(_buttonPos select 1) + (((_buttonPos select 3) - _iconSize) / 2),
		_iconSize,
		_iconSize
	];
	_icon ctrlSetAngle [0, 0.5, 0.5, true];
	_icon ctrlCommit 0;
};

private _currentApp = _display getVariable [QGVAR(currentApp), "desktop"];
private _standardButtons = [
	[IDC_MMC_BTN_DESKTOP, IDC_MMC_FRAME_BTN_DESKTOP],
	[IDC_MMC_BTN_FILES, IDC_MMC_FRAME_BTN_FILES],
	[IDC_MMC_BTN_MAIL, IDC_MMC_FRAME_BTN_MAIL],
	[IDC_MMC_BTN_MESSAGES, IDC_MMC_FRAME_BTN_MESSAGES],
	[IDC_MMC_BTN_NOTES, IDC_MMC_FRAME_BTN_NOTES]
];
private _visibleStandard = _standardButtons select {ctrlShown (_display displayCtrl (_x select 0))};
private _visibleCount = (count _visibleStandard) max 1;
private _rebuiltStandardIcons = [];
{
	_x params ["_buttonIdc", "_frameIdc"];
	private _button = _display displayCtrl _buttonIdc;
	private _frame = _display displayCtrl _frameIdc;
	private _pos = if (_orientation isEqualTo "vertical") then {
		private _buttonW = (_screenW - (_gap * 2)) / _visibleCount;
		[_screenX + _gap + (_forEachIndex * _buttonW), _dockY, _buttonW - 0.004, _dockH]
	} else {
		private _buttonH = (_screenH - _taskbarH - (_gap * 2)) / _visibleCount;
		[_screenX + _gap, _screenY + _gap + (_forEachIndex * _buttonH), _railW - (_gap * 1.5), _buttonH - 0.004]
	};
	_button ctrlSetPosition _pos;
	_frame ctrlSetPosition [_pos select 0, _pos select 1, (_pos select 2) + 0.002, _pos select 3];
	_button ctrlCommit 0;
	_frame ctrlCommit 0;
	private _icon = _button getVariable [QGVAR(mobileIconControl), controlNull];
	if (!isNull _icon) then {
		ctrlDelete _icon;
		_icon = _display ctrlCreate ["RscPictureKeepAspect", [_display] call FUNC(nextDynamicIdc)];
		_icon ctrlEnable false;
		_icon setVariable [QGVAR(mobileNoTransform), true];
		_button setVariable [QGVAR(mobileIconControl), _icon];
		_rebuiltStandardIcons pushBack _icon;
		private _standardAppId = switch (_buttonIdc) do {
			case IDC_MMC_BTN_DESKTOP: {"desktop"};
			case IDC_MMC_BTN_FILES: {"files"};
			case IDC_MMC_BTN_MAIL: {"mail"};
			case IDC_MMC_BTN_MESSAGES: {"messages"};
			case IDC_MMC_BTN_NOTES: {"notes"};
			default {""};
		};
		private _isSelected = _currentApp isEqualTo _standardAppId;
		private _selectedIconPath = _button getVariable [[QGVAR(mobileIconPath), QGVAR(mobileIconHoverPath)] select _isSelected, ""];
		if (_selectedIconPath isNotEqualTo "") then {
			_icon ctrlSetText _selectedIconPath;
		};
		private _iconSize = (((_pos select 2) min (_pos select 3)) * 0.58) max 0.012;
		_icon ctrlSetPosition [
			(_pos select 0) + (((_pos select 2) - _iconSize) / 2),
			(_pos select 1) + (((_pos select 3) - _iconSize) / 2),
			_iconSize,
			_iconSize
		];
		_icon ctrlSetTextColor ([_buttonText, _buttonHoverText] select _isSelected);
		_icon ctrlSetAngle [0, 0.5, 0.5, true];
		_icon ctrlShow true;
		_icon ctrlCommit 0;
	};
} forEach _visibleStandard;
_display setVariable [QGVAR(standardAppIconControls), _rebuiltStandardIcons];

private _list = _display displayCtrl IDC_MMC_APP_LIST;
private _systemOverlayVisible = (ctrlShown (_display displayCtrl IDC_MMC_LOGIN_PANEL)) || {ctrlShown (_display displayCtrl IDC_MMC_POWER_SCREEN)};
private _customApps = if (isNull _computer) then {
	[]
} else {
	_computer getVariable [QGVAR(customApps), []]
};
if !(_customApps isEqualType []) then {
	_customApps = [];
};
_customApps = _customApps select {
	_x isEqualType createHashMap
	&& {(_x getOrDefault ["id", ""]) isNotEqualTo ""}
};
private _hasCustomApps = !_systemOverlayVisible && {_customApps isNotEqualTo []};
private _customOpen = _display getVariable [QGVAR(mobileCustomAppsOpen), false];
private _hasNavPane = !_systemOverlayVisible && {(lbSize _list > 0) && {_currentApp in ["files", "mail", "messages"]}};
private _contentLeft = _screenX + _gap + _railW + ([0, _navHandleW + _navHandleGap] select (_orientation isEqualTo "horizontal"));
private _contentRight = _screenX + _screenW - _gap - (_navHandleW + _navHandleGap);
private _contentTop = _screenY + _gap;
private _contentBottom = if (_orientation isEqualTo "vertical") then {_dockY - _gap - _navHandleW - _navHandleGap} else {_taskbarY - _gap};
private _contentW = (_contentRight - _contentLeft) max 0.1;
private _contentH = (_contentBottom - _contentTop) max 0.1;

private _closeW = 0.046;
private _rotateW = 0.046;
private _rotateX = _contentRight - _rotateW;
private _closeX = _rotateX - _gap - _closeW;
private _titleW = (_closeX - _contentLeft - _gap) max 0.08;
{
	_x params ["_idc", "_pos"];
	[_idc, _pos] call _set;
} forEach [
	[IDC_MMC_APP_TITLE, [_contentLeft, _contentTop, _titleW, _titleH]],
	[IDC_MMC_FRAME_APP_TITLE, [_contentLeft, _contentTop, _titleW, _titleH]],
	[IDC_MMC_BTN_CLOSE_APP, [_closeX, _contentTop, _closeW, _titleH]],
	[IDC_MMC_FRAME_CLOSE_APP, [_closeX, _contentTop, _closeW, _titleH]]
];
_rotate ctrlSetPosition [_rotateX, _contentTop, _rotateW, _titleH];
_rotate ctrlCommit 0;
_rotateFrame ctrlShow true;
_rotateFrame ctrlSetPosition [_rotateX, _contentTop, _rotateW, _titleH];
_rotateFrame ctrlCommit 0;
private _rotatePos = ctrlPosition _rotate;
private _rotateIconSize = (((_rotatePos select 2) min (_rotatePos select 3)) * 0.56) max 0.012;
_rotateIcon ctrlSetPosition [
	(_rotatePos select 0) + (((_rotatePos select 2) - _rotateIconSize) / 2),
	(_rotatePos select 1) + (((_rotatePos select 3) - _rotateIconSize) / 2),
	_rotateIconSize,
	_rotateIconSize
];
_rotateIcon ctrlSetAngle [0, 0.5, 0.5, true];
_rotateIcon ctrlShow true;
_rotateIcon ctrlCommit 0;

private _navOpen = _display getVariable [QGVAR(mobileNavOpen), true];
private _bodyPos = [_contentLeft, _contentTop + _titleH + _gap, _contentW, (_contentH - _titleH - _gap) max 0.08];
private _bodyX = _bodyPos select 0;
private _bodyY = _bodyPos select 1;
private _bodyW = _bodyPos select 2;
private _bodyH = _bodyPos select 3;

{
	if (!isNull _x) then {
		if (isNull (ctrlParentControlsGroup _x)) then {
			private _pos = ctrlPosition _x;
			if ((_pos select 2) > 0.12 && {(_pos select 3) > 0.08}) then {
				_x ctrlSetPosition _bodyPos;
				_x ctrlCommit 0;
			};
		};
		_x call _addCollapseHandler;
	};
} forEach (_display getVariable [QGVAR(customActionControls), []]);

{
	private _ctrl = _display displayCtrl _x;
	_ctrl ctrlShow false;
} forEach [IDC_MMC_APP_LIST, IDC_MMC_FRAME_APP_LIST];

private _iconGeneration = _display getVariable [QGVAR(mobileIconGeneration), 0];
private _navBg = _display getVariable [QGVAR(mobileNavBackgroundControl), controlNull];
private _navFrame = _display getVariable [QGVAR(mobileNavFrameControl), controlNull];
private _navList = _display getVariable [QGVAR(mobileNavListControl), controlNull];
private _navToggle = _display getVariable [QGVAR(mobileNavToggleControl), controlNull];
private _navToggleFrame = _display getVariable [QGVAR(mobileNavToggleFrameControl), controlNull];
private _forcePanesOnTop = _display getVariable [QGVAR(mobileRecreatePanesOnTop), false];
private _recreateNav = _forcePanesOnTop || {
	isNull _navBg
	|| {isNull _navFrame}
	|| {isNull _navList}
	|| {isNull _navToggle}
	|| {isNull _navToggleFrame}
	|| {(_display getVariable [QGVAR(mobileNavGeneration), -1]) != _iconGeneration}
};

if (_recreateNav) then {
	{
		private _ctrl = _display getVariable [_x, controlNull];
		if (!isNull _ctrl) then {
			ctrlDelete _ctrl;
		};
		_display setVariable [_x, controlNull];
	} forEach [
		QGVAR(mobileNavBackgroundControl),
		QGVAR(mobileNavFrameControl),
		QGVAR(mobileNavListControl),
		QGVAR(mobileNavToggleControl),
		QGVAR(mobileNavToggleFrameControl)
	];

	_navBg = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc)];
	_navBg ctrlSetText "";
	_navBg ctrlEnable false;
	_navBg setVariable [QGVAR(mobileNoTransform), true];
	_display setVariable [QGVAR(mobileNavBackgroundControl), _navBg];

	_navFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
	_navFrame ctrlEnable false;
	_navFrame setVariable [QGVAR(mobileNoTransform), true];
	_display setVariable [QGVAR(mobileNavFrameControl), _navFrame];

	_navList = _display ctrlCreate [QGVAR(RscMobileNavList), [_display] call FUNC(nextDynamicIdc)];
	_navList setVariable [QGVAR(mobileNoTransform), true];
	_navList ctrlAddEventHandler ["LBSelChanged", {
		params ["_control", "_index"];
		private _display = ctrlParent _control;
		if (_display getVariable [QGVAR(mobileNavSyncing), false]) exitWith {};
		private _source = _display displayCtrl IDC_MMC_APP_LIST;
		if (!isNull _source && {_index >= 0}) then {
			_display setVariable [QGVAR(mobilePaneKeepOpenUntil), diag_tickTime + 0.25];
			_display setVariable [QGVAR(mobilePaneSelection), "nav"];
			["select", [_source, _index]] call MMC_fnc_renderApp;
			_display setVariable [QGVAR(mobileNavOpen), true];
			_display setVariable [QGVAR(mobileCustomAppsOpen), false];
			_display setVariable [QGVAR(mobileRecreatePanesOnTop), true];
			[_display] call MMC_fnc_applyMobileDisplayLayout;
			private _focusSink = _display getVariable [QGVAR(mobileFocusSinkControl), controlNull];
			if (!isNull _focusSink) then {
				ctrlSetFocus _focusSink;
			};
		};
	}];
	_display setVariable [QGVAR(mobileNavListControl), _navList];

	_navToggle = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
	_navToggle setVariable [QGVAR(mobileNoTransform), true];
	_navToggle ctrlAddEventHandler ["ButtonClick", {
		params ["_control"];
		private _display = ctrlParent _control;
		_display setVariable [QGVAR(startMenuOpen), false];
		_display setVariable [QGVAR(mobileCustomAppsOpen), false];
		_display setVariable [QGVAR(mobileNavOpen), !(_display getVariable [QGVAR(mobileNavOpen), true])];
		_display setVariable [QGVAR(mobileRecreatePanesOnTop), true];
		private _focusSink = _display getVariable [QGVAR(mobileFocusSinkControl), controlNull];
		if (!isNull _focusSink) then {
			ctrlSetFocus _focusSink;
		};
		[_display] call MMC_fnc_applyMobileDisplayLayout;
	}];
	_display setVariable [QGVAR(mobileNavToggleControl), _navToggle];

	_navToggleFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
	_navToggleFrame ctrlEnable false;
	_navToggleFrame setVariable [QGVAR(mobileNoTransform), true];
	_display setVariable [QGVAR(mobileNavToggleFrameControl), _navToggleFrame];
	_display setVariable [QGVAR(mobileNavGeneration), _iconGeneration];
};

_navBg ctrlSetBackgroundColor _button;
_navFrame ctrlSetTextColor _border;
_navList ctrlSetBackgroundColor _button;
_navList ctrlSetTextColor _buttonText;
_navToggle ctrlSetBackgroundColor _panelStrong;
_navToggle ctrlSetTextColor _buttonText;
_navToggle ctrlSetActiveColor _buttonText;
_navToggle ctrlSetForegroundColor _border;
_navToggleFrame ctrlSetTextColor _border;

private _navEntries = [];
for "_i" from 0 to ((lbSize _list) - 1) do {
	_navEntries pushBack [_list lbText _i, _list lbData _i];
};
private _navSignature = str _navEntries;
private _sourceIndex = lbCurSel _list;
private _previousNavSignature = _display getVariable [QGVAR(mobileNavSignature), ""];
private _navNeedsContentSync = (lbSize _navList) isNotEqualTo (count _navEntries);
if (_navSignature isNotEqualTo _previousNavSignature || _navNeedsContentSync) then {
	_display setVariable [QGVAR(mobileNavSyncing), true];
	lbClear _navList;
	{
		_x params ["_text", "_data"];
		private _row = _navList lbAdd _text;
		_navList lbSetData [_row, _data];
		_navList lbSetTooltip [_row, _text];
	} forEach _navEntries;
	_display setVariable [QGVAR(mobileNavSignature), _navSignature];
	if (_sourceIndex >= 0 && {_sourceIndex < lbSize _navList}) then {
		if ((lbCurSel _navList) isNotEqualTo _sourceIndex) then {
			_navList lbSetCurSel _sourceIndex;
		};
	};
	[{
		params ["_display"];
		if (!isNull _display) then {
			_display setVariable [QGVAR(mobileNavSyncing), false];
		};
	}, [_display], 0] call CBA_fnc_waitAndExecute;
};

private _navTogglePos = [0, 0, 0, 0];
private _navListPos = [0, 0, 0, 0];
if (_orientation isEqualTo "vertical") then {
	private _navToggleH = _navHandleW;
	private _navToggleY = _dockY - _navToggleH - 0.004;
	private _navH = if (_hasNavPane) then {(0.038 * ((lbSize _list) min 3)) + 0.012} else {0};
	_navTogglePos = [_bodyX, _navToggleY, _bodyW, _navToggleH];
	_navListPos = [_bodyX, (_navToggleY - _navH - 0.004) max _bodyY, _bodyW, _navH];
} else {
	private _navToggleW = _navHandleW;
	private _navToggleX = _screenX + _gap + _railW;
	private _navH = _bodyH max 0.08;
	private _navW = (0.24 min (_screenW * 0.26)) max 0.16;
	_navTogglePos = [_navToggleX, _bodyY, _navToggleW, _navH];
	_navListPos = [_navToggleX + _navToggleW + _navHandleGap, _bodyY, _navW, _navH];
};
_navToggle ctrlSetTooltip (["Show navigation pane", "Hide navigation pane"] select _navOpen);
_navToggle ctrlShow _hasNavPane;
_navToggle ctrlSetPosition _navTogglePos;
_navToggle ctrlCommit 0;
_navToggleFrame ctrlShow _hasNavPane;
_navToggleFrame ctrlSetPosition _navTogglePos;
_navToggleFrame ctrlCommit 0;
if (_orientation isEqualTo "vertical") then {
	[QGVAR(mobileNavArrowIcon), _navToggle, ["up", "down"] select _navOpen, _hasNavPane] call _setArrowIcon;
} else {
	[QGVAR(mobileNavArrowIcon), _navToggle, ["right", "left"] select _navOpen, _hasNavPane] call _setArrowIcon;
};
_navBg ctrlShow (_hasNavPane && _navOpen);
_navBg ctrlSetPosition _navListPos;
_navBg ctrlCommit 0;
_navFrame ctrlShow (_hasNavPane && _navOpen);
_navFrame ctrlSetPosition _navListPos;
_navFrame ctrlCommit 0;
_navList ctrlShow (_hasNavPane && _navOpen);
_navList ctrlSetPosition _navListPos;
_navList ctrlCommit 0;

{
	[_x, _bodyPos] call _set;
} forEach [IDC_MMC_APP_BODY, IDC_MMC_FRAME_APP_BODY, IDC_MMC_DESKTOP_CONTENT_GROUP];
[IDC_MMC_DESKTOP_CONTENT_BODY, (_bodyPos select 2) - 0.02] call _setGroupChildWidth;

{
	(_display displayCtrl _x) call _addCollapseHandler;
} forEach [
	IDC_MMC_APP_BODY,
	IDC_MMC_DESKTOP_CONTENT_GROUP,
	IDC_MMC_MAIL_FROM,
	IDC_MMC_MAIL_RECIPIENT,
	IDC_MMC_MAIL_CC,
	IDC_MMC_MAIL_SUBJECT,
	IDC_MMC_MAIL_BODY,
	IDC_MMC_MAIL_ATTACHMENT,
	IDC_MMC_MAIL_ATTACHMENT_DESC
];

private _customBg = _display getVariable [QGVAR(mobileCustomAppsBackgroundControl), controlNull];
private _customFrame = _display getVariable [QGVAR(mobileCustomAppsFrameControl), controlNull];
private _customList = _display getVariable [QGVAR(mobileCustomAppsListControl), controlNull];
private _customToggle = _display getVariable [QGVAR(mobileCustomAppsToggleControl), controlNull];
private _customToggleFrame = _display getVariable [QGVAR(mobileCustomAppsToggleFrameControl), controlNull];
private _customRecreate = _forcePanesOnTop || {
	isNull _customBg
	|| {isNull _customFrame}
	|| {isNull _customList}
	|| {isNull _customToggle}
	|| {isNull _customToggleFrame}
};

if (_customRecreate) then {
	{
		private _ctrl = _display getVariable [_x, controlNull];
		if (!isNull _ctrl) then {
			ctrlDelete _ctrl;
		};
		_display setVariable [_x, controlNull];
	} forEach [
		QGVAR(mobileCustomAppsBackgroundControl),
		QGVAR(mobileCustomAppsFrameControl),
		QGVAR(mobileCustomAppsListControl),
		QGVAR(mobileCustomAppsToggleControl),
		QGVAR(mobileCustomAppsToggleFrameControl)
	];

	_customBg = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc)];
	_customBg ctrlSetText "";
	_customBg ctrlEnable false;
	_customBg setVariable [QGVAR(mobileNoTransform), true];
	_display setVariable [QGVAR(mobileCustomAppsBackgroundControl), _customBg];

	_customFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
	_customFrame ctrlEnable false;
	_customFrame setVariable [QGVAR(mobileNoTransform), true];
	_display setVariable [QGVAR(mobileCustomAppsFrameControl), _customFrame];

	_customList = _display ctrlCreate [QGVAR(RscMobileNavList), [_display] call FUNC(nextDynamicIdc)];
	_customList setVariable [QGVAR(mobileNoTransform), true];
	_customList ctrlAddEventHandler ["LBSelChanged", {
		params ["_control", "_index"];
		private _display = ctrlParent _control;
		if (_display getVariable [QGVAR(mobileCustomAppsSyncing), false]) exitWith {};
		if (_index < 0) exitWith {};
		private _appId = _control lbData _index;
		if (_appId isNotEqualTo "") then {
			_display setVariable [QGVAR(mobilePaneKeepOpenUntil), diag_tickTime + 0.25];
			_display setVariable [QGVAR(mobilePaneSelection), "customApps"];
			[format ["custom:%1", _appId]] call MMC_fnc_renderApp;
			_display setVariable [QGVAR(mobileNavOpen), false];
			_display setVariable [QGVAR(mobileCustomAppsOpen), true];
			_display setVariable [QGVAR(mobileRecreatePanesOnTop), true];
			[_display] call MMC_fnc_applyMobileDisplayLayout;
			private _focusSink = _display getVariable [QGVAR(mobileFocusSinkControl), controlNull];
			if (!isNull _focusSink) then {
				ctrlSetFocus _focusSink;
			};
		};
	}];
	_display setVariable [QGVAR(mobileCustomAppsListControl), _customList];

	_customToggle = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
	_customToggle setVariable [QGVAR(mobileNoTransform), true];
	_customToggle ctrlAddEventHandler ["ButtonClick", {
		params ["_control"];
		private _display = ctrlParent _control;
		_display setVariable [QGVAR(startMenuOpen), false];
		_display setVariable [QGVAR(mobileNavOpen), false];
		_display setVariable [QGVAR(mobileCustomAppsOpen), !(_display getVariable [QGVAR(mobileCustomAppsOpen), false])];
		_display setVariable [QGVAR(mobileRecreatePanesOnTop), true];
		private _focusSink = _display getVariable [QGVAR(mobileFocusSinkControl), controlNull];
		if (!isNull _focusSink) then {
			ctrlSetFocus _focusSink;
		};
		[_display] call MMC_fnc_applyMobileDisplayLayout;
	}];
	_display setVariable [QGVAR(mobileCustomAppsToggleControl), _customToggle];

	_customToggleFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
	_customToggleFrame ctrlEnable false;
	_customToggleFrame setVariable [QGVAR(mobileNoTransform), true];
	_display setVariable [QGVAR(mobileCustomAppsToggleFrameControl), _customToggleFrame];
};

_customBg ctrlSetBackgroundColor _button;
_customFrame ctrlSetTextColor _border;
_customList ctrlSetBackgroundColor _button;
_customList ctrlSetTextColor _buttonText;
_customToggle ctrlSetBackgroundColor _panelStrong;
_customToggle ctrlSetTextColor _buttonText;
_customToggle ctrlSetActiveColor _buttonText;
_customToggle ctrlSetForegroundColor _border;
_customToggleFrame ctrlSetTextColor _border;

private _customLookup = if ((_currentApp select [0, 7]) isEqualTo "custom:") then {
	_currentApp select [7]
} else {
	""
};
private _customIndex = _customApps findIf {toLowerANSI (_x getOrDefault ["id", ""]) isEqualTo toLowerANSI _customLookup};
private _customEntries = _customApps apply {
	[
		_x getOrDefault ["label", _x getOrDefault ["id", "App"]],
		_x getOrDefault ["id", ""],
		_x getOrDefault ["tooltip", format ["Open %1.", _x getOrDefault ["label", "app"]]]
	]
};
private _customSignature = str _customEntries;
private _previousCustomSignature = _display getVariable [QGVAR(mobileCustomAppsSignature), ""];
private _customNeedsContentSync = (lbSize _customList) isNotEqualTo (count _customEntries);
if (_customSignature isNotEqualTo _previousCustomSignature || _customNeedsContentSync) then {
	_display setVariable [QGVAR(mobileCustomAppsSyncing), true];
	lbClear _customList;
	{
		_x params ["_label", "_id", "_tooltip"];
		private _row = _customList lbAdd _label;
		_customList lbSetData [_row, _id];
		_customList lbSetTooltip [_row, _tooltip];
	} forEach _customEntries;
	_display setVariable [QGVAR(mobileCustomAppsSignature), _customSignature];
	if (_customIndex >= 0) then {
		if ((lbCurSel _customList) isNotEqualTo _customIndex) then {
			_customList lbSetCurSel _customIndex;
		};
	};
	[{
		params ["_display"];
		if (!isNull _display) then {
			_display setVariable [QGVAR(mobileCustomAppsSyncing), false];
		};
	}, [_display], 0] call CBA_fnc_waitAndExecute;
} else {
	if (_customIndex < 0 && {lbCurSel _customList >= 0}) then {
		_display setVariable [QGVAR(mobileCustomAppsSyncing), true];
		_customList lbSetCurSel -1;
		[{
			params ["_display"];
			if (!isNull _display) then {
				_display setVariable [QGVAR(mobileCustomAppsSyncing), false];
			};
		}, [_display], 0] call CBA_fnc_waitAndExecute;
	};
};

private _innerX = _bodyX + 0.01;
private _innerY = _bodyY + 0.01;
private _innerW = (_bodyW - 0.02) max 0.04;

private _drawerH = _bodyH max 0.08;
private _drawerW = (0.23 min (_screenW * 0.32)) max 0.14;
private _toggleX = _bodyX + _bodyW + _navHandleGap;
private _toggleY = _bodyY;
private _drawerY = _bodyY;
private _drawerX = (_toggleX - _drawerW - _navHandleGap) max (_bodyX + 0.006);
private _customTogglePos = [_toggleX, _toggleY, _navHandleW, _bodyH];
private _customListPos = [_drawerX, _drawerY, (_toggleX - _drawerX - _navHandleGap) max 0.08, _drawerH];
_customToggle ctrlSetTooltip (["Show custom apps", "Hide custom apps"] select _customOpen);
_customToggle ctrlShow _hasCustomApps;
_customToggle ctrlSetPosition _customTogglePos;
_customToggle ctrlCommit 0;
_customToggleFrame ctrlShow _hasCustomApps;
_customToggleFrame ctrlSetPosition _customTogglePos;
_customToggleFrame ctrlCommit 0;
[
	QGVAR(mobileCustomAppsArrowIcon),
	_customToggle,
	["left", "right"] select _customOpen,
	_hasCustomApps
] call _setArrowIcon;
_customBg ctrlShow (_hasCustomApps && _customOpen);
_customBg ctrlSetPosition _customListPos;
_customBg ctrlCommit 0;
_customFrame ctrlShow (_hasCustomApps && _customOpen);
_customFrame ctrlSetPosition _customListPos;
_customFrame ctrlCommit 0;
_customList ctrlShow (_hasCustomApps && _customOpen);
_customList ctrlSetPosition _customListPos;
_customList ctrlCommit 0;

private _mediaShown = ctrlShown (_display displayCtrl IDC_MMC_MEDIA_BAR);
if (_mediaShown) then {
	private _mediaH = 0.074;
	private _mediaY = _bodyY + _bodyH - _mediaH - 0.008;
	{
		[_x, [_bodyX + 0.008, _mediaY, _bodyW - 0.016, _mediaH]] call _set;
	} forEach [IDC_MMC_MEDIA_BAR, IDC_MMC_FRAME_MEDIA_BAR];
	private _smallW = 0.034;
	private _playW = 0.05;
	private _buttonY = _mediaY + 0.011;
	private _buttonH = _mediaH - 0.022;
	{
		_x params ["_idc", "_frameIdc", "_xOffset", "_w"];
		private _pos = [_bodyX + 0.016 + _xOffset, _buttonY, _w, _buttonH];
		[_idc, _pos] call _set;
		[_frameIdc, _pos] call _set;
	} forEach [
		[IDC_MMC_MEDIA_PREV, IDC_MMC_FRAME_MEDIA_PREV, 0, _smallW],
		[IDC_MMC_MEDIA_PLAY, IDC_MMC_FRAME_MEDIA_PLAY, _smallW + 0.006, _playW],
		[IDC_MMC_MEDIA_STOP, IDC_MMC_FRAME_MEDIA_STOP, _smallW + _playW + 0.012, _playW],
		[IDC_MMC_MEDIA_NEXT, IDC_MMC_FRAME_MEDIA_NEXT, _smallW + (_playW * 2) + 0.018, _smallW]
	];
	private _statusX = _bodyX + 0.016 + (_smallW * 2) + (_playW * 2) + 0.03;
	[IDC_MMC_MEDIA_STATUS, [_statusX, _buttonY, (_bodyX + _bodyW - 0.018 - _statusX) max 0.04, _buttonH]] call _set;
	[QGVAR(mobileMediaPrevArrowIcon), _display displayCtrl IDC_MMC_MEDIA_PREV, "left", true] call _setArrowIcon;
	[QGVAR(mobileMediaNextArrowIcon), _display displayCtrl IDC_MMC_MEDIA_NEXT, "right", true] call _setArrowIcon;
} else {
	[QGVAR(mobileMediaPrevArrowIcon), _display displayCtrl IDC_MMC_MEDIA_PREV, "left", false] call _setArrowIcon;
	[QGVAR(mobileMediaNextArrowIcon), _display displayCtrl IDC_MMC_MEDIA_NEXT, "right", false] call _setArrowIcon;
};

if (ctrlShown (_display displayCtrl IDC_MMC_FILE_PREVIEW_IMAGE)) then {
	private _imageW = _innerW * 0.72;
	private _imageH = (_bodyH * 0.38) min (_imageW * 0.72);
	private _imageX = _bodyX + ((_bodyW - _imageW) / 2);
	private _imageY = _bodyY + 0.08;
	[IDC_MMC_FILE_PREVIEW_IMAGE, [_imageX, _imageY, _imageW, _imageH]] call _set;
	[IDC_MMC_FRAME_FILE_PREVIEW_IMAGE, [_imageX - 0.002, _imageY - 0.002, _imageW + 0.004, _imageH + 0.004]] call _set;
	private _descH = (_bodyY + _bodyH - _imageY - _imageH - 0.028) max 0.08;
	{
		[_x, [_imageX, _imageY + _imageH + 0.012, _imageW, _descH]] call _set;
	} forEach [IDC_MMC_FILE_DESCRIPTION_GROUP, IDC_MMC_FRAME_FILE_DESCRIPTION];
	[IDC_MMC_FILE_DESCRIPTION_BODY, _imageW - 0.014] call _setGroupChildWidth;
};

if (_currentApp isEqualTo "messages") then {
	private _inputBg = _display getVariable [QGVAR(messengerInputBackgroundControl), controlNull];
	private _inputGroup = _display getVariable [QGVAR(messengerInputGroupControl), controlNull];
	private _input = _display getVariable [QGVAR(messengerInputControl), controlNull];
	private _send = _display getVariable [QGVAR(messengerSendControl), controlNull];
	private _sendHotspot = _display getVariable [QGVAR(messengerSendHotspotControl), controlNull];
	private _sendFrame = _display getVariable [QGVAR(messengerSendFrameControl), controlNull];
	private _messengerGeneration = _display getVariable [QGVAR(messengerInputControlsGeneration), 0];
	private _deletedMessengerInput = false;
	{
		if (!isNull _x && {(_x getVariable [QGVAR(messengerInputControlsGeneration), -1]) isNotEqualTo _messengerGeneration}) then {
			ctrlDelete _x;
			_deletedMessengerInput = true;
		};
	} forEach [_inputBg, _inputGroup, _input, _send, _sendHotspot, _sendFrame];
	if (_deletedMessengerInput) then {
		_display setVariable [QGVAR(messengerInputBackgroundControl), controlNull];
		_display setVariable [QGVAR(messengerInputGroupControl), controlNull];
		_display setVariable [QGVAR(messengerInputControl), controlNull];
		_display setVariable [QGVAR(messengerSendControl), controlNull];
		_display setVariable [QGVAR(messengerSendHotspotControl), controlNull];
		_display setVariable [QGVAR(messengerSendFrameControl), controlNull];
	};
	_inputBg = _display getVariable [QGVAR(messengerInputBackgroundControl), controlNull];
	_inputGroup = _display getVariable [QGVAR(messengerInputGroupControl), controlNull];
	_input = _display getVariable [QGVAR(messengerInputControl), controlNull];
	_send = _display getVariable [QGVAR(messengerSendControl), controlNull];
	_sendHotspot = _display getVariable [QGVAR(messengerSendHotspotControl), controlNull];
	_sendFrame = _display getVariable [QGVAR(messengerSendFrameControl), controlNull];
	private _inputH = [0.19, 0.17] select (_orientation isEqualTo "vertical");
	private _rowGap = 0.008;
	private _sendW = [0.08, 0.07] select (_orientation isEqualTo "vertical");
	private _historyH = (_bodyH - _inputH - _rowGap - 0.008) max 0.08;
	private _drawerOpen = (_hasNavPane && _navOpen) || {_hasCustomApps && _customOpen};
	[IDC_MMC_DESKTOP_CONTENT_GROUP, [_bodyX, _bodyY, _bodyW, _historyH]] call _set;
	[IDC_MMC_DESKTOP_CONTENT_BODY, _bodyW - 0.02] call _setGroupChildWidth;
	if (!isNull _inputBg && {!isNull _input && {!isNull _send}}) then {
		private _inputY = _bodyY + _bodyH - _inputH - 0.006;
		private _inputW = (_bodyW - _sendW - _rowGap - 0.016) max 0.06;
		_inputBg ctrlSetPosition [_bodyX + 0.008, _inputY, _inputW, _inputH];
		if (!isNull _inputGroup) then {
			_inputGroup ctrlShow false;
		};
		_input ctrlSetPosition [_bodyX + 0.012, _inputY + 0.006, (_inputW - 0.02) max 0.02, (_inputH - 0.012) max 0.04];
		_send ctrlSetPosition [_bodyX + _bodyW - _sendW - 0.008, _inputY, _sendW, _inputH];
		if (!isNull _sendHotspot) then {
			_sendHotspot ctrlSetPosition [_bodyX + _bodyW - _sendW - 0.008, _inputY, _sendW, _inputH];
		};
		_inputBg ctrlShow !_drawerOpen;
		_input ctrlShow !_drawerOpen;
		_send ctrlShow !_drawerOpen;
		if (!isNull _sendHotspot) then {
			_sendHotspot ctrlShow !_drawerOpen;
			_sendHotspot ctrlCommit 0;
		};
		if (!isNull _sendFrame) then {
			_sendFrame ctrlSetPosition [_bodyX + _bodyW - _sendW - 0.008, _inputY, _sendW, _inputH];
			_sendFrame ctrlShow !_drawerOpen;
			_sendFrame ctrlCommit 0;
		};
		_inputBg ctrlCommit 0;
		_input ctrlCommit 0;
		_send ctrlCommit 0;
	};
	{
		if (!isNull _x && {ctrlShown _x}) then {
			_x ctrlCommit 0;
		};
	} forEach [_navBg, _navFrame, _navList, _navToggle, _navToggleFrame, _customBg, _customFrame, _customList, _customToggle, _customToggleFrame];
} else {
	{
		if (!isNull _x) then {
			_x ctrlShow false;
			ctrlDelete _x;
		};
	} forEach ((_display getVariable [QGVAR(messengerDynamicControls), []]) + [
		_display getVariable [QGVAR(messengerInputBackgroundControl), controlNull],
		_display getVariable [QGVAR(messengerInputGroupControl), controlNull],
		_display getVariable [QGVAR(messengerInputControl), controlNull],
		_display getVariable [QGVAR(messengerSendControl), controlNull],
		_display getVariable [QGVAR(messengerSendHotspotControl), controlNull],
		_display getVariable [QGVAR(messengerSendFrameControl), controlNull]
	]);
	_display setVariable [QGVAR(messengerDynamicControls), []];
	_display setVariable [QGVAR(messengerInputBackgroundControl), controlNull];
	_display setVariable [QGVAR(messengerInputGroupControl), controlNull];
	_display setVariable [QGVAR(messengerInputControl), controlNull];
	_display setVariable [QGVAR(messengerSendControl), controlNull];
	_display setVariable [QGVAR(messengerSendHotspotControl), controlNull];
	_display setVariable [QGVAR(messengerSendFrameControl), controlNull];
	{
		if (
			(_x getVariable [QGVAR(messengerInputControlsGeneration), -1]) >= 0
			|| {_x getVariable [QGVAR(messengerDynamicControl), false]}
		) then {
			ctrlDelete _x;
		};
	} forEach (allControls _display);
};

private _mailMode = _display getVariable [QGVAR(mailMode), ""];
private _mailBack = _display getVariable [QGVAR(mobileMailBackControl), controlNull];
private _mailBackFrame = _display getVariable [QGVAR(mobileMailBackFrameControl), controlNull];
if (isNull _mailBack) then {
	_mailBack = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
	_mailBack ctrlSetTooltip "Return to the mail list.";
	_mailBack ctrlAddEventHandler ["ButtonClick", {
		private _display = ctrlParent (_this select 0);
		_display setVariable [QGVAR(mailFolder), _display getVariable [QGVAR(selectedMailFolder), _display getVariable [QGVAR(mailFolder), "inbox"]]];
		_display setVariable [QGVAR(mailMode), "table"];
		["table"] call MMC_fnc_renderMail;
	}];
	_mailBack setVariable [QGVAR(mobileNoTransform), true];
	_display setVariable [QGVAR(mobileMailBackControl), _mailBack];
};
if (isNull _mailBackFrame) then {
	_mailBackFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc)];
	_mailBackFrame ctrlEnable false;
	_mailBackFrame setVariable [QGVAR(mobileNoTransform), true];
	_display setVariable [QGVAR(mobileMailBackFrameControl), _mailBackFrame];
};
_mailBack ctrlSetBackgroundColor _button;
_mailBack ctrlSetTextColor _buttonText;
_mailBack ctrlSetActiveColor _buttonHoverText;
_mailBackFrame ctrlSetTextColor _border;
_mailBack ctrlShow false;
_mailBackFrame ctrlShow false;
[QGVAR(mobileMailBackArrowIcon), _mailBack, "left", false] call _setArrowIcon;
{
	(_display displayCtrl _x) ctrlShow false;
} forEach [IDC_MMC_MAIL_SCROLL_LEFT, IDC_MMC_MAIL_SCROLL_RIGHT, IDC_MMC_FRAME_MAIL_SCROLL_LEFT, IDC_MMC_FRAME_MAIL_SCROLL_RIGHT];
[QGVAR(mobileMailScrollLeftArrowIcon), _display displayCtrl IDC_MMC_MAIL_SCROLL_LEFT, "left", false] call _setArrowIcon;
[QGVAR(mobileMailScrollRightArrowIcon), _display displayCtrl IDC_MMC_MAIL_SCROLL_RIGHT, "right", false] call _setArrowIcon;
if (_currentApp isEqualTo "mail" && {_mailMode in ["compose", "read", "table"]}) then {
	if (_mailMode isEqualTo "compose") then {
		private _fieldH = 0.041;
		private _labelH = 0.025;
		private _labelGap = 0.012;
		private _rowGap = 0.009;
		private _topY = _innerY;
		private _buttonW = 0.084;
		private _buttonGap = 0.006;
		private _cancelX = _bodyX + _bodyW - 0.01 - _buttonW;
		private _sendX = _cancelX - _buttonGap - _buttonW;
		[IDC_MMC_MAIL_HEADER, [_innerX, _topY, (_sendX - _innerX - _buttonGap) max (_innerW * 0.4), 0.034]] call _set;
		[IDC_MMC_MAIL_SEND, [_sendX, _topY, _buttonW, 0.039]] call _set;
		[IDC_MMC_MAIL_CANCEL, [_cancelX, _topY, _buttonW, 0.039]] call _set;
		private _y = _topY + 0.049;
		private _composeRows = [];
		if (ctrlShown (_display displayCtrl IDC_MMC_MAIL_FROM)) then {
			_composeRows pushBack [IDC_MMC_MAIL_FROM_LABEL, IDC_MMC_MAIL_FROM, "From"];
		};
		_composeRows append [
			[IDC_MMC_MAIL_RECIPIENT_LABEL, IDC_MMC_MAIL_RECIPIENT, "Recipient"],
			[IDC_MMC_MAIL_CC_LABEL, IDC_MMC_MAIL_CC, "CC"],
			[IDC_MMC_MAIL_SUBJECT_LABEL, IDC_MMC_MAIL_SUBJECT, "Subject"]
		];
		{
			_x params ["_labelIdc", "_editIdc", "_label"];
			(_display displayCtrl _labelIdc) ctrlSetText _label;
			[_labelIdc, [_innerX, _y, _innerW, _labelH]] call _set;
			_y = _y + _labelH + _labelGap;
			[_editIdc, [_innerX, _y, _innerW, _fieldH]] call _set;
			_y = _y + _fieldH + _rowGap;
		} forEach _composeRows;
		private _bottomReserve = (_labelH + _labelGap + _fieldH + _rowGap) * 2;
		private _bodyLabelY = _y;
		[IDC_MMC_MAIL_BODY_LABEL, [_innerX, _bodyLabelY, _innerW * 0.4, _labelH]] call _set;
		(_display displayCtrl IDC_MMC_MAIL_BODY_HINT) ctrlSetText "Shift+Enter line break";
		[IDC_MMC_MAIL_BODY_HINT, [_innerX + (_innerW * 0.42), _bodyLabelY, _innerW * 0.58, _labelH]] call _set;
		_y = _bodyLabelY + _labelH + _labelGap;
		private _mailBodyH = ((_bodyY + _bodyH - 0.01) - _y - _bottomReserve) max 0.11;
		[IDC_MMC_MAIL_BODY_GROUP, [_innerX, _y, _innerW, _mailBodyH]] call _set;
		private _mailBody = _display displayCtrl IDC_MMC_MAIL_BODY;
		_mailBody ctrlSetPosition [0, 0, _innerW - 0.014, _mailBodyH max ((ctrlPosition _mailBody) select 3)];
		_mailBody ctrlCommit 0;
		_y = _y + _mailBodyH + _rowGap;
		{
			_x params ["_labelIdc", "_editIdc", "_label"];
			(_display displayCtrl _labelIdc) ctrlSetText _label;
			[_labelIdc, [_innerX, _y, _innerW, _labelH]] call _set;
			_y = _y + _labelH + _labelGap;
			[_editIdc, [_innerX, _y, _innerW, _fieldH]] call _set;
			_y = _y + _fieldH + _rowGap;
		} forEach [
			[IDC_MMC_MAIL_ATTACHMENT_LABEL, IDC_MMC_MAIL_ATTACHMENT, "Attachment"],
			[IDC_MMC_MAIL_ATTACHMENT_DESC_LABEL, IDC_MMC_MAIL_ATTACHMENT_DESC, "Description"]
		];
		[IDC_MMC_MAIL_ERROR, [_innerX + (_innerW * 0.48), _topY + 0.044, _innerW * 0.52, 0.03]] call _set;
	} else {
		if (_mailMode isEqualTo "read") then {
			private _backW = 0.032;
			private _backH = 0.038;
			_mailBack ctrlShow true;
			_mailBack ctrlSetPosition [_innerX, _innerY, _backW, _backH];
			_mailBack ctrlCommit 0;
			_mailBackFrame ctrlShow true;
			_mailBackFrame ctrlSetPosition [_innerX, _innerY, _backW, _backH];
			_mailBackFrame ctrlCommit 0;
			[QGVAR(mobileMailBackArrowIcon), _mailBack, "left", true] call _setArrowIcon;
			private _buttonW = 0.084;
			private _buttonGap = 0.006;
			private _forwardX = _bodyX + _bodyW - 0.01 - _buttonW;
			private _replyX = _forwardX - _buttonGap - _buttonW;
			[IDC_MMC_MAIL_REPLY, [_replyX, _innerY, _buttonW, 0.038]] call _set;
			[IDC_MMC_MAIL_FORWARD, [_forwardX, _innerY, _buttonW, 0.038]] call _set;
			private _metaH = 0.205 min ((_bodyH * 0.42) max 0.18);
			[IDC_MMC_MAIL_READ_META, [_innerX, _innerY + 0.05, _innerW, _metaH]] call _set;
			[IDC_MMC_MAIL_READ_GROUP, [_innerX, _innerY + 0.064 + _metaH, _innerW, (_bodyH - _metaH - 0.092) max 0.08]] call _set;
			[IDC_MMC_MAIL_READ_BODY, _innerW - 0.014] call _setGroupChildWidth;
			private _readBody = _display displayCtrl IDC_MMC_MAIL_READ_BODY;
			private _readBodyPos = ctrlPosition _readBody;
			_readBodyPos set [2, _innerW - 0.014];
			_readBodyPos set [3, 0.12 max ((ctrlTextHeight _readBody) + 0.02)];
			_readBody ctrlSetPosition _readBodyPos;
			_readBody ctrlCommit 0;
		} else {
			private _scrollW = 0.032;
			private _scrollGap = 0.005;
			private _drawerOpen = (_hasNavPane && _navOpen) || {_hasCustomApps && _customOpen};
			[IDC_MMC_MAIL_HEADER, [_innerX + _scrollW + _scrollGap, _innerY, _innerW - ((_scrollW + _scrollGap) * 2), 0.034]] call _set;
			[IDC_MMC_MAIL_SCROLL_LEFT, [_innerX, _innerY, _scrollW, 0.034]] call _set;
			[IDC_MMC_FRAME_MAIL_SCROLL_LEFT, [_innerX, _innerY, _scrollW, 0.034]] call _set;
			[IDC_MMC_MAIL_SCROLL_RIGHT, [_innerX + _innerW - _scrollW, _innerY, _scrollW, 0.034]] call _set;
			[IDC_MMC_FRAME_MAIL_SCROLL_RIGHT, [_innerX + _innerW - _scrollW, _innerY, _scrollW, 0.034]] call _set;
			{
				(_display displayCtrl _x) ctrlShow !_drawerOpen;
			} forEach [IDC_MMC_MAIL_SCROLL_LEFT, IDC_MMC_MAIL_SCROLL_RIGHT, IDC_MMC_FRAME_MAIL_SCROLL_LEFT, IDC_MMC_FRAME_MAIL_SCROLL_RIGHT];
			[QGVAR(mobileMailScrollLeftArrowIcon), _display displayCtrl IDC_MMC_MAIL_SCROLL_LEFT, "left", !_drawerOpen] call _setArrowIcon;
			[QGVAR(mobileMailScrollRightArrowIcon), _display displayCtrl IDC_MMC_MAIL_SCROLL_RIGHT, "right", !_drawerOpen] call _setArrowIcon;
			{
				[_x, [_innerX, _innerY + 0.044, _innerW, (_bodyH - 0.064) max 0.1]] call _set;
			} forEach [IDC_MMC_MAIL_TABLE, IDC_MMC_FRAME_MAIL_TABLE];
			private _mailTable = _display displayCtrl IDC_MMC_MAIL_TABLE;
			_mailTable ctrlSetFontHeight ([0.03, 0.028] select (_orientation isEqualTo "vertical"));
			private _tablePage = _display getVariable [QGVAR(mobileMailTablePage), 0];
			_mailTable lnbSetColumnsPos ([[0.03, 0.18, 0.37, 0.58, 1.18, 1.52], [-0.62, -0.43, -0.23, -0.02, 0.43, 0.76]] select (_tablePage > 0));
			(_display displayCtrl IDC_MMC_MAIL_SCROLL_LEFT) ctrlEnable (_tablePage > 0);
			(_display displayCtrl IDC_MMC_MAIL_SCROLL_RIGHT) ctrlEnable (_tablePage < 1);
			private _mailRows = _display getVariable [QGVAR(mailRows), []];
			private _themeForMailIcons = [_display] call FUNC(getThemeConfig);
			private _readIcon = [PATHTOF(img\mail_read_white.paa), PATHTOF(img\mail_read_black.paa)] select (_themeForMailIcons getOrDefault ["isLight", false]);
			private _unreadIcon = [PATHTOF(img\mail_unread_white.paa), PATHTOF(img\mail_unread_black.paa)] select (_themeForMailIcons getOrDefault ["isLight", false]);
			for "_row" from 1 to ((count _mailRows) - 1) do {
				private _mail = _mailRows param [_row, createHashMap];
				private _iconPath = ["", [_unreadIcon, _readIcon] select (_mail getOrDefault ["read", true])] select (_tablePage == 0);
				_mailTable lnbSetPicture [[_row, 0], _iconPath];
			};
		};
	};
};

if (_orientation isEqualTo "horizontal" && {_hasNavPane && _navOpen}) then {
	[QGVAR(mobileNavArrowIcon), _navToggle, "left", true] call _setArrowIcon;
};

private _loginVisible = ctrlShown (_display displayCtrl IDC_MMC_LOGIN_PANEL);
if (_loginVisible) then {
	private _panelW = if (_orientation isEqualTo "vertical") then {_screenW * 0.78} else {_screenW * 0.42};
	private _panelH = if (_orientation isEqualTo "vertical") then {_screenH * 0.36} else {_screenH * 0.46};
	private _panelX = _screenX + ((_screenW - _panelW) / 2);
	private _panelY = _screenY + ((_screenH - _panelH) / 2);
	{
		[_x, [_panelX, _panelY, _panelW, _panelH]] call _set;
	} forEach [IDC_MMC_LOGIN_PANEL, IDC_MMC_FRAME_LOGIN_PANEL];
	[IDC_MMC_LOGIN_TITLE, [_panelX + 0.016, _panelY + 0.014, _panelW - 0.032, 0.052]] call _set;
	[IDC_MMC_LOGIN_USERNAME_LABEL, [_panelX + 0.024, _panelY + 0.076, _panelW - 0.048, 0.026]] call _set;
	[IDC_MMC_LOGIN_USERNAME, [_panelX + 0.024, _panelY + 0.104, _panelW - 0.048, 0.036]] call _set;
	[IDC_MMC_FRAME_LOGIN_USERNAME, [_panelX + 0.024, _panelY + 0.104, _panelW - 0.048, 0.036]] call _set;
	[IDC_MMC_LOGIN_PASSWORD_LABEL, [_panelX + 0.024, _panelY + 0.148, _panelW - 0.048, 0.026]] call _set;
	[IDC_MMC_LOGIN_PASSWORD, [_panelX + 0.024, _panelY + 0.176, _panelW - 0.092, 0.036]] call _set;
	[IDC_MMC_LOGIN_PASSWORD_VISIBLE, [_panelX + 0.024, _panelY + 0.176, _panelW - 0.092, 0.036]] call _set;
	[IDC_MMC_FRAME_LOGIN_PASSWORD, [_panelX + 0.024, _panelY + 0.176, _panelW - 0.092, 0.036]] call _set;
	[IDC_MMC_LOGIN_PASSWORD_TOGGLE, [_panelX + _panelW - 0.062, _panelY + 0.176, 0.038, 0.036]] call _set;
	[IDC_MMC_FRAME_LOGIN_PASSWORD_TOGGLE, [_panelX + _panelW - 0.062, _panelY + 0.176, 0.038, 0.036]] call _set;
	[IDC_MMC_LOGIN_ERROR, [_panelX + 0.024, _panelY + 0.218, _panelW - 0.048, 0.038]] call _set;
	[IDC_MMC_LOGIN_BUTTON, [_panelX + (_panelW * 0.24), _panelY + _panelH - 0.064, _panelW * 0.22, 0.044]] call _set;
	[IDC_MMC_FRAME_LOGIN_BUTTON, [_panelX + (_panelW * 0.24), _panelY + _panelH - 0.064, _panelW * 0.22, 0.044]] call _set;
	[IDC_MMC_LOGIN_SHUTDOWN, [_panelX + (_panelW * 0.52), _panelY + _panelH - 0.064, _panelW * 0.28, 0.044]] call _set;
	[IDC_MMC_FRAME_LOGIN_SHUTDOWN, [_panelX + (_panelW * 0.52), _panelY + _panelH - 0.064, _panelW * 0.28, 0.044]] call _set;
};

private _powerShown = ctrlShown (_display displayCtrl IDC_MMC_POWER_SCREEN);
if (_powerShown) then {
	[IDC_MMC_POWER_SCREEN, [_screenX, _screenY, _screenW, _screenH]] call _set;
	private _barW = _screenW * 0.54;
	[IDC_MMC_BOOT_TITLE, [_screenX, _screenY + (_screenH * 0.31), _screenW, 0.07]] call _set;
	[IDC_MMC_BOOT_STATUS, [_screenX, _screenY + (_screenH * 0.40), _screenW, 0.042]] call _set;
	[IDC_MMC_BOOT_BAR_BG, [_screenX + ((_screenW - _barW) / 2), _screenY + (_screenH * 0.53), _barW, 0.018]] call _set;
	[IDC_MMC_BOOT_BAR_FILL, [_screenX + ((_screenW - _barW) / 2), _screenY + (_screenH * 0.53), (ctrlPosition (_display displayCtrl IDC_MMC_BOOT_BAR_FILL)) select 2, 0.018]] call _set;
	[IDC_MMC_BOOT_STAGE, [_screenX, _screenY + (_screenH * 0.57), _screenW, 0.036]] call _set;
};

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
	IDC_MMC_FRAME_START_SHUTDOWN
];

{
	if (!isNull _x) then {
		ctrlDelete _x;
	};
} forEach (_display getVariable [QGVAR(mobileStartMenuControls), []]);
_display setVariable [QGVAR(mobileStartMenuControls), []];
_display setVariable [QGVAR(mobileStartMenuSignature), ""];
_display setVariable [QGVAR(mobileStartMenuGeneration), -1];
_display setVariable [QGVAR(mobileRecreatePanesOnTop), false];

if ((_hasNavPane && _navOpen) || {_hasCustomApps && _customOpen}) then {
	[{
		params ["_display"];
		private _focusSink = _display getVariable [QGVAR(mobileFocusSinkControl), controlNull];
		if (!isNull _focusSink) then {
			ctrlSetFocus _focusSink;
		};
	}, [_display], 0] call CBA_fnc_waitAndExecute;
};

[] call FUNC(updateClock);

true
