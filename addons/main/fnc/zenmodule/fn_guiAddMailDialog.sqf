#include "..\..\script_component.hpp"

#define IDC_TITLE 10
#define GUI_GRID_W (safeZoneW / 40)
#define GUI_GRID_H (safeZoneH / 25)

/*
 * Author: Moony
 * Populates the MMB dynamic dialog for adding mail to users.
 */

params ["_display", "_content"];

(_display displayCtrl IDC_TITLE) ctrlSetText "Add Mail";

private _controls = [];
private _fields = [];
private _contentPaddingY = 0.45 * GUI_GRID_H;
private _xField = 12.5 * GUI_GRID_W;
private _rowWLabel = 11 * GUI_GRID_W;
private _rowWField = 13.5 * GUI_GRID_W;
private _categoryBodyX = 0.35 * GUI_GRID_W;
private _categoryBodyW = 26.9 * GUI_GRID_W;
private _rowBackgroundX = 1.55 * GUI_GRID_W;
private _columnGapW = 0.16 * GUI_GRID_W;
private _sliderEditW = 2.3 * GUI_GRID_W;
private _sliderGapW = 0.25 * GUI_GRID_W;
private _toggleGapW = 0;
private _sectionPadY = 0.16 * GUI_GRID_H;
private _rowH = 1 * GUI_GRID_H;
private _categoryH = 1 * GUI_GRID_H;
private _rowGap = 0.16 * GUI_GRID_H;
private _categoryGapTop = 0.32 * GUI_GRID_H;
private _savedValues = [];
private _y = _contentPaddingY;

private _addControl = {
	params ["_class", "_idc", "_position", ["_text", ""]];
	private _control = _display ctrlCreate [_class, _idc, _content];
	_control ctrlSetPosition _position;
	if (_text isNotEqualTo "") then {
		_control ctrlSetText _text;
	};
	_control ctrlCommit 0;
	_controls pushBack _control;
	_control
};

private _addRowBackground = {
	private _backgroundX = _rowBackgroundX;
	private _labelTextX = _backgroundX + (0.25 * GUI_GRID_W);
	private _backgroundW = (_xField - _columnGapW - _backgroundX) max GUI_GRID_W;
	private _background = ["RscText", -1, [_backgroundX, _y, _backgroundW, _rowH], ""] call _addControl;
	_background ctrlSetBackgroundColor [0, 0, 0, 0.35];
	[_labelTextX, _xField]
};

private _addEdit = {
	params ["_label", "_labelIdc", "_editIdc", ["_default", ""], ["_key", ""], ["_tooltip", ""]];
	(call _addRowBackground) params ["_labelTextX", "_fieldX"];
	private _labelControl = ["RscText", _labelIdc, [_labelTextX, _y, _rowWLabel, _rowH], _label] call _addControl;
	if (_tooltip isNotEqualTo "") then {
		_labelControl ctrlSetTooltip _tooltip;
	};
	private _edit = ["RscEdit", _editIdc, [_fieldX, _y, _rowWField, _rowH], _default] call _addControl;
	_fields pushBack [_key, _editIdc, "edit"];
	_y = _y + _rowH + _rowGap;
	_edit
};

["From", -1, IDC_MMC_DLG_MAIL_FROM, "sender@mmc.local", "from", "Sender mail address displayed in the Mail app."] call _addEdit;
["To", -1, IDC_MMC_DLG_MAIL_TO, "", "to", "Leave empty to use each selected user's address."] call _addEdit;
["Subject", -1, IDC_MMC_DLG_MAIL_SUBJECT, "Mission Update", "subject", "Mail subject displayed in the inbox list."] call _addEdit;
["Body", -1, IDC_MMC_DLG_MAIL_BODY, "Mail body goes here.", "body", "Mail body shown when the mail is selected."] call _addEdit;
["Date", -1, IDC_MMC_DLG_MAIL_DATE, "2035-06-01 08:00", "date", "Display date for this mail."] call _addEdit;

(call _addRowBackground) params ["_labelTextX", "_fieldX"];
private _label = ["RscText", -1, [_labelTextX, _y, _rowWLabel, _rowH], "User"] call _addControl;
_label ctrlSetTooltip "Select the Users to add the mail to.";

private _groupH = _rowH * 3;
private _group = _display ctrlCreate ["RscControlsGroup", -1, _content];
_group ctrlSetPosition [_fieldX, _y, _rowWField, _groupH];
_group ctrlCommit 0;
_controls pushBack _group;

private _users = [] call FUNC(getRegisteredUsers);
private _checkboxes = [];
{
	private _username = _x getOrDefault ["username", "Unknown"];
	private _rowY = _forEachIndex * _rowH;
	private _checkbox = _display ctrlCreate ["RscCheckBox", -1, _group];
	_checkbox ctrlSetPosition [0, _rowY + 0.005, 0.75 * GUI_GRID_W, 0.75 * GUI_GRID_H];
	_checkbox ctrlCommit 0;
	private _text = _display ctrlCreate ["RscText", -1, _group];
	_text ctrlSetPosition [0.9 * GUI_GRID_W, _rowY, _rowWField - (1.1 * GUI_GRID_W), _rowH];
	_text ctrlSetText _username;
	_text ctrlSetTooltip (_x getOrDefault ["email", ""]);
	_text ctrlCommit 0;
	_checkboxes pushBack [_username, _checkbox];
} forEach _users;

_display setVariable [QGVAR(userCheckboxes), _checkboxes];
_y = _y + _groupH + _rowGap;

_display setVariable ["MMB_main_onConfirm", QFUNC(confirmAddMailDialog)];
_display setVariable ["MMB_main_controls", _controls];
_display setVariable ["MMB_main_fields", _fields];
_display setVariable ["MMB_main_contentHeight", _y + _contentPaddingY];
