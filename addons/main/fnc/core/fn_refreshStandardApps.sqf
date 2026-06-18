#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Shows, hides, and compacts the standard app buttons for the active user.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * Visible standard app count <NUMBER>
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {0};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _activeUser = [_computer] call FUNC(getActiveUser);
private _isMobile = _display getVariable [QGVAR(isMobileDisplay), false];
private _apps = [
	["desktop", ["Desktop", "Home Screen"] select _isMobile, [PATHTOF(img\home_white.paa), PATHTOF(img\home_black.paa)], IDC_MMC_BTN_DESKTOP, IDC_MMC_FRAME_BTN_DESKTOP, true],
	["files", "Files", [PATHTOF(img\files_white.paa), PATHTOF(img\files_black.paa)], IDC_MMC_BTN_FILES, IDC_MMC_FRAME_BTN_FILES],
	["mail", "Mail", [PATHTOF(img\mail_white.paa), PATHTOF(img\mail_black.paa)], IDC_MMC_BTN_MAIL, IDC_MMC_FRAME_BTN_MAIL],
	["messages", "Messenger", [PATHTOF(img\message_white.paa), PATHTOF(img\message_black.paa)], IDC_MMC_BTN_MESSAGES, IDC_MMC_FRAME_BTN_MESSAGES],
	["notes", "Notes", [PATHTOF(img\notes_white.paa), PATHTOF(img\notes_black.paa)], IDC_MMC_BTN_NOTES, IDC_MMC_FRAME_BTN_NOTES]
];

{
	ctrlDelete _x;
} forEach (_display getVariable [QGVAR(standardAppIconControls), []]);
_display setVariable [QGVAR(standardAppIconControls), []];

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _buttonText = _themeConfig getOrDefault ["buttonText", [0.92, 0.94, 0.97, 1]];
private _buttonHoverText = _themeConfig getOrDefault ["buttonHoverText", _buttonText];
private _iconLuma = ((_buttonText select 0) * 0.299) + ((_buttonText select 1) * 0.587) + ((_buttonText select 2) * 0.114);
private _useBlackIcon = _iconLuma < 0.5;
private _hoverIconLuma = ((_buttonHoverText select 0) * 0.299) + ((_buttonHoverText select 1) * 0.587) + ((_buttonHoverText select 2) * 0.114);
private _useBlackHoverIcon = _hoverIconLuma < 0.5;
private _iconControls = [];
private _visibleIndex = 0;
{
	_x params ["_app", "_label", "_iconPaths", "_buttonIdc", "_frameIdc", ["_alwaysShow", false]];
	private _iconPath = if (_iconPaths isEqualType []) then {
		_iconPaths select ([0, 1] select _useBlackIcon)
	} else {
		_iconPaths
	};
	private _hoverIconPath = if (_iconPaths isEqualType []) then {
		_iconPaths select ([0, 1] select _useBlackHoverIcon)
	} else {
		_iconPath
	};
	private _show = _alwaysShow || {[_computer, _app, _activeUser] call FUNC(isStandardAppEnabled)};
	private _button = _display displayCtrl _buttonIdc;
	private _frame = _display displayCtrl _frameIdc;

	_button ctrlShow _show;
	_frame ctrlShow _show;
		_button ctrlSetText (["", _label] select (!_isMobile));
		_button ctrlSetTooltip _label;
		_button setVariable [QGVAR(mobileIconControl), controlNull];
		_button setVariable [QGVAR(mobileIconPath), _iconPath];
		_button setVariable [QGVAR(mobileIconHoverPath), _hoverIconPath];

	if (_show) then {
		private _y = safeZoneY + 0.09 + (_visibleIndex * 0.055);
		private _buttonPos = [safeZoneX + 0.035, _y, 0.105, 0.05];
		private _framePos = [safeZoneX + 0.035, _y, 0.107, 0.05];
		_button ctrlSetPosition _buttonPos;
		_frame ctrlSetPosition _framePos;
		_button setVariable [QGVAR(mobileBasePosition), _buttonPos];
		_frame setVariable [QGVAR(mobileBasePosition), _framePos];
		_button ctrlCommit 0;
		_frame ctrlCommit 0;

		if (_isMobile) then {
			private _icon = _display ctrlCreate ["RscPictureKeepAspect", [_display] call FUNC(nextDynamicIdc)];
			_icon ctrlSetText _iconPath;
			_icon ctrlSetTooltip _label;
			_icon ctrlSetTextColor _buttonText;
			private _iconPos = [safeZoneX + 0.074, _y + 0.0105, 0.026, 0.029];
			_icon ctrlSetPosition _iconPos;
			_icon setVariable [QGVAR(mobileBasePosition), _iconPos];
			_icon ctrlEnable false;
			_icon ctrlCommit 0;
			_button setVariable [QGVAR(mobileIconControl), _icon];
			_iconControls pushBack _icon;
		};

		_visibleIndex = _visibleIndex + 1;
	};
} forEach _apps;

_display setVariable [QGVAR(standardAppIconControls), _iconControls];
_display setVariable [QGVAR(standardAppButtonCount), _visibleIndex];
_display setVariable [QGVAR(mobileIconGeneration), (_display getVariable [QGVAR(mobileIconGeneration), 0]) + 1];

_visibleIndex
