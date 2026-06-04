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
private _apps = [
	["files", IDC_MMC_BTN_FILES, IDC_MMC_FRAME_BTN_FILES],
	["mail", IDC_MMC_BTN_MAIL, IDC_MMC_FRAME_BTN_MAIL],
	["messages", IDC_MMC_BTN_MESSAGES, IDC_MMC_FRAME_BTN_MESSAGES],
	["notes", IDC_MMC_BTN_NOTES, IDC_MMC_FRAME_BTN_NOTES]
];

private _visibleIndex = 0;
{
	_x params ["_app", "_buttonIdc", "_frameIdc"];
	private _show = [_computer, _app, _activeUser] call FUNC(isStandardAppEnabled);
	private _button = _display displayCtrl _buttonIdc;
	private _frame = _display displayCtrl _frameIdc;

	_button ctrlShow _show;
	_frame ctrlShow _show;

	if (_show) then {
		private _y = safeZoneY + 0.09 + (_visibleIndex * 0.055);
		_button ctrlSetPosition [safeZoneX + 0.035, _y, 0.105, 0.05];
		_frame ctrlSetPosition [safeZoneX + 0.035, _y, 0.107, 0.05];
		_button ctrlCommit 0;
		_frame ctrlCommit 0;
		_visibleIndex = _visibleIndex + 1;
	};
} forEach _apps;

_display setVariable [QGVAR(standardAppButtonCount), _visibleIndex];

_visibleIndex
