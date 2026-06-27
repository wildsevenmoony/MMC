#include "..\..\script_component.hpp"

#define IDC_TITLE 10

/*
 * Author: Moony
 * Populates the MMB dynamic dialog for adding a text file to users.
 */

params ["_display", "_content"];

(_display displayCtrl IDC_TITLE) ctrlSetText "Add Text File";

private _controls = [];
private _fields = [];
private _contentPaddingY = 0.018;
private _rowBackgroundX = 0.035;
private _xField = 0.34;
private _rowWLabel = 0.26;
private _rowWField = 0.42;
private _columnGapW = 0.012;
private _rowH = 0.04;
private _rowGap = 0.006;
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
	params [["_height", _rowH]];
	private _backgroundX = _rowBackgroundX;
	private _labelTextX = _backgroundX + 0.008;
	private _backgroundW = (_xField - _columnGapW - _backgroundX) max 0.05;
	private _background = ["RscText", -1, [_backgroundX, _y, _backgroundW, _height], ""] call _addControl;
	_background ctrlSetBackgroundColor [0, 0, 0, 0.35];
	[_labelTextX, _xField]
};

private _addEdit = {
	params ["_label", "_labelIdc", "_editIdc", ["_default", ""], ["_key", ""], ["_tooltip", ""], ["_height", _rowH], ["_class", "RscEdit"]];
	([_height] call _addRowBackground) params ["_labelTextX", "_fieldX"];
	private _labelControl = ["RscText", _labelIdc, [_labelTextX, _y, _rowWLabel, _rowH], _label] call _addControl;
	if (_tooltip isNotEqualTo "") then {
		_labelControl ctrlSetTooltip _tooltip;
	};
	private _edit = [_class, _editIdc, [_fieldX, _y, _rowWField, _height], _default] call _addControl;
	if (_tooltip isNotEqualTo "") then {
		_edit ctrlSetTooltip _tooltip;
	};
	_fields pushBack [_key, _editIdc, "edit"];
	_y = _y + _height + _rowGap;
	_edit
};

["File Name", -1, IDC_MMC_DLG_FILE_NAME, "intel.txt", "fileName", "Displayed in the user's Files app."] call _addEdit;
["Content", -1, IDC_MMC_DLG_FILE_CONTENT, "Mission intel goes here.", "content", "Structured text is supported, including tags such as <br/> and image tags. Use \n for line breaks.", _rowH * 5, QGVAR(RscComputerEditMulti)] call _addEdit;

(call _addRowBackground) params ["_labelTextX", "_fieldX"];
private _label = ["RscText", -1, [_labelTextX, _y, _rowWLabel, _rowH], "User"] call _addControl;
_label ctrlSetTooltip "Select the Users to add the file to.";

private _groupH = _rowH * 3;
private _selectionBackground = ["RscText", -1, [_fieldX, _y, _rowWField, _groupH], ""] call _addControl;
_selectionBackground ctrlSetBackgroundColor [0.32, 0.32, 0.32, 0.62];

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
	_checkbox ctrlSetPosition [0.006, _rowY + 0.004, 0.026, 0.032];
	_checkbox ctrlCommit 0;
	private _text = _display ctrlCreate ["RscText", -1, _group];
	_text ctrlSetPosition [0.038, _rowY, _rowWField - 0.045, _rowH];
	_text ctrlSetText _username;
	_text ctrlSetTooltip (_x getOrDefault ["email", ""]);
	_text ctrlCommit 0;
	_checkboxes pushBack [_username, _checkbox];
} forEach _users;

_display setVariable [QGVAR(userCheckboxes), _checkboxes];
_y = _y + _groupH + _rowGap;

_display setVariable ["MMB_main_onConfirm", QFUNC(confirmAddTextFileDialog)];
_display setVariable ["MMB_main_controls", _controls];
_display setVariable ["MMB_main_fields", _fields];
_display setVariable ["MMB_main_contentHeight", _y + _contentPaddingY];
