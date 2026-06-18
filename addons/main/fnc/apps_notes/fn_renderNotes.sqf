#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Renders the MMC Notes app.
 *
 * Arguments:
 * 0: Action <STRING, default: "render">
 * 1: Selected row index <NUMBER, default: -1>
 * 2: Action came from navigation selection <BOOL, default: false>
 *
 * Return Value:
 * None
 */

params [
	["_action", "render", [""]],
	["_selection", -1, [0]],
	["_fromNav", false, [false]]
];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _data = if (isNull _computer) then {
	_display getVariable [QGVAR(data), createHashMap]
} else {
	_computer getVariable [QGVAR(data), _display getVariable [QGVAR(data), createHashMap]]
};
private _activeUser = [_computer] call FUNC(getActiveUser);

private _title = _display displayCtrl IDC_MMC_APP_TITLE;
private _list = _display displayCtrl IDC_MMC_APP_LIST;
private _body = _display displayCtrl IDC_MMC_APP_BODY;
private _group = _display displayCtrl IDC_MMC_DESKTOP_CONTENT_GROUP;
private _desktopBody = _display displayCtrl IDC_MMC_DESKTOP_CONTENT_BODY;
private _theme = [_display] call FUNC(getThemeConfig);
private _panel = _theme getOrDefault ["panel", [0.02, 0.025, 0.035, 0.94]];
private _textColor = _theme getOrDefault ["text", [0.92, 0.94, 0.97, 1]];
private _button = _theme getOrDefault ["button", [0.028, 0.032, 0.042, 0.98]];
private _buttonText = _theme getOrDefault ["buttonText", _textColor];
private _border = _theme getOrDefault ["border", [0, 0, 0, 0.85]];
private _accent = _theme getOrDefault ["bootAccent", [0.13, 0.54, 0.21, 0.95]];

{
	if (!isNull _x) then {
		ctrlDelete _x;
	};
} forEach (_display getVariable [QGVAR(notesControls), []]);
{
	if (_x getVariable [QGVAR(notesDynamicControl), false]) then {
		ctrlDelete _x;
	};
} forEach (allControls _display);
_display setVariable [QGVAR(notesControls), []];
_display setVariable [QGVAR(customActionControls), []];

_title ctrlSetText "Notes";
_body ctrlSetStructuredText parseText "";
_body ctrlEnable false;
_group ctrlShow true;
_desktopBody ctrlShow false;
_desktopBody ctrlSetStructuredText parseText "";

private _username = _activeUser getOrDefault ["username", ""];
private _notes = +(_activeUser getOrDefault ["notes", []]);
private _systemNotes = +(_data getOrDefault ["notes", []]);
private _changedUserNotes = false;
private _changedSystemNotes = false;

private _coerceNote = {
	params ["_note", "_fallbackId", "_defaultTitle"];
	private _out = if (_note isEqualType createHashMap) then {
		_note
	} else {
		if (_note isEqualType []) then {
			createHashMapFromArray _note
		} else {
			createHashMap
		}
	};
	if ((_out getOrDefault ["id", ""]) isEqualTo "") then {
		_out set ["id", _fallbackId];
	};
	if ((_out getOrDefault ["title", ""]) isEqualTo "") then {
		_out set ["title", _defaultTitle];
	};
	if !("body" in keys _out) then {
		_out set ["body", _out getOrDefault ["content", ""]];
	};
	_out
};

{
	private _note = [_x, format ["user_%1_%2", _username, _forEachIndex], "Untitled note"] call _coerceNote;
	if (_note isNotEqualTo _x) then {
		_changedUserNotes = true;
	};
	_notes set [_forEachIndex, _note];
} forEach _notes;

{
	private _note = [_x, format ["system_%1", _forEachIndex], "System note"] call _coerceNote;
	if (_note isNotEqualTo _x) then {
		_changedSystemNotes = true;
	};
	_systemNotes set [_forEachIndex, _note];
} forEach _systemNotes;

if (_changedUserNotes && {_username isNotEqualTo "" && {!isNull _computer}}) then {
	private _users = _data getOrDefault ["users", []];
	private _userIndex = _users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username};
	if (_userIndex >= 0) then {
		private _user = _users select _userIndex;
		_user set ["notes", _notes];
		_users set [_userIndex, _user];
		_data set ["users", _users];
		_computer setVariable [QGVAR(data), _data, true];
		_computer setVariable [QGVAR(activeUser), _user, true];
	};
};

if (_changedSystemNotes && {!isNull _computer}) then {
	_data set ["notes", _systemNotes];
	_computer setVariable [QGVAR(data), _data, true];
};

private _rows = [];

private _orderedNotes = +_notes;
reverse _orderedNotes;
{
	_rows pushBack createHashMapFromArray [
		["action", "note"],
		["source", "user"],
		["label", _x getOrDefault ["title", "Untitled note"]],
		["note", _x]
	];
} forEach _orderedNotes;

{
	_rows pushBack createHashMapFromArray [
		["action", "note"],
		["source", "system"],
		["label", format ["%1", _x getOrDefault ["title", "System note"]]],
		["note", _x]
	];
} forEach _systemNotes;

if (_action isEqualTo "select" && _fromNav) then {
	private _selected = _rows param [_selection, createHashMap];
	private _rowAction = _selected getOrDefault ["action", ""];
	if (_rowAction isEqualTo "note") then {
		private _selectedNote = _selected getOrDefault ["note", createHashMap];
		_display setVariable [QGVAR(selectedNoteId), _selectedNote getOrDefault ["id", ""]];
		_display setVariable [QGVAR(selectedNoteSource), _selected getOrDefault ["source", "user"]];
		_display setVariable [QGVAR(notesDraftId), "__none"];
		_display setVariable [QGVAR(notesDraftSource), "user"];
		_display setVariable [QGVAR(notesDraftTitle), ""];
		_display setVariable [QGVAR(notesDraftBody), ""];
	};
};

private _selectedId = _display getVariable [QGVAR(selectedNoteId), ""];
private _selectedSource = _display getVariable [QGVAR(selectedNoteSource), "user"];

lbClear _list;
private _selectedRow = -1;
{
	private _row = _list lbAdd (_x getOrDefault ["label", ""]);
	_list lbSetTooltip [_row, switch (_x getOrDefault ["action", "new"]) do {
		default {
			private _note = _x getOrDefault ["note", createHashMap];
			format [
				"%1%2Modified: %3 %4",
				_note getOrDefault ["title", "Untitled note"],
				toString [10],
				_note getOrDefault ["modifiedDate", _note getOrDefault ["createdDate", ""]],
				_note getOrDefault ["modifiedTime", _note getOrDefault ["createdTime", ""]]
			]
		};
	}];
	if ((_x getOrDefault ["action", ""]) isEqualTo "note") then {
		private _note = _x getOrDefault ["note", createHashMap];
		if ((_note getOrDefault ["id", ""]) isEqualTo _selectedId && {(_x getOrDefault ["source", "user"]) isEqualTo _selectedSource}) then {
			_selectedRow = _row;
		};
	};
} forEach _rows;
_display setVariable [QGVAR(notesRows), _rows];
if (_selectedRow >= 0 && {(lbCurSel _list) isNotEqualTo _selectedRow}) then {
	_list lbSetCurSel _selectedRow;
};

if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
	[_display] call FUNC(applyMobileDisplayLayout);
};

private _selectedNote = createHashMap;
private _selectedRowData = if (_selectedRow >= 0) then {_rows param [_selectedRow, createHashMap]} else {createHashMap};
if ((_selectedRowData getOrDefault ["action", "new"]) isEqualTo "note") then {
	_selectedNote = _selectedRowData getOrDefault ["note", createHashMap];
};

private _noteTitle = _selectedNote getOrDefault ["title", ""];
private _noteBody = _selectedNote getOrDefault ["body", ""];
if (
	(_display getVariable [QGVAR(notesDraftId), "__none"]) isEqualTo _selectedId
	&& {(_display getVariable [QGVAR(notesDraftSource), "user"]) isEqualTo _selectedSource}
) then {
	_noteTitle = _display getVariable [QGVAR(notesDraftTitle), _noteTitle];
	_noteBody = _display getVariable [QGVAR(notesDraftBody), _noteBody];
};
private _noteIsSaved = (_selectedNote getOrDefault ["id", ""]) isNotEqualTo "";
private _isSystemNote = _selectedSource isEqualTo "system" && _noteIsSaved;
private _status = _display getVariable [QGVAR(notesStatus), ""];
_display setVariable [QGVAR(notesStatus), ""];

private _groupPos = ctrlPosition _group;
private _groupW = (_groupPos select 2) max 0.2;
private _groupH = (_groupPos select 3) max 0.22;
private _pad = 0.012;
private _gap = 0.008;
private _labelH = 0.026;
private _labelFieldGap = 0.006;
private _titleH = 0.04;
private _buttonH = 0.042;
private _statusH = 0.034;
private _statusGap = 0.014;
private _usableW = (_groupW - (_pad * 2)) max 0.12;
private _topButtonH = _labelH + 0.006;
private _nameY = _pad + _topButtonH + _gap;
private _titleY = _nameY + _labelH + _labelFieldGap;
private _noteLabelY = _titleY + _titleH + (_gap * 1.75);
private _bodyY = _noteLabelY + _labelH + _labelFieldGap;
private _bodyH = (_groupH - _bodyY - _buttonH - _statusH - _statusGap - (_gap * 3) - _pad) max 0.12;
private _buttonY = _bodyY + _bodyH + _gap;
private _buttonW = ((_usableW - (_gap * 2)) / 3) max 0.062;
private _statusY = _buttonY + _buttonH + _statusGap;

private _controls = [];
private _add = {
	params ["_control"];
	if (!isNull _control) then {
		_control setVariable [QGVAR(notesDynamicControl), true];
	};
	_controls pushBack _control;
	_control
};

private _header = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
[_header] call _add;
_header ctrlSetText "Name";
_header ctrlSetPosition [_pad, _nameY, _usableW * 0.55, _labelH];
_header ctrlSetTextColor _textColor;
_header ctrlSetTooltip (["Name of this note.", "Name of this system note. Saving creates a personal copy."] select _isSystemNote);
_header ctrlSetBackgroundColor [0, 0, 0, 0];
_header ctrlCommit 0;

private _newButtonW = 0.12 min ((_usableW * 0.38) max 0.08);
private _newButton = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc), _group];
[_newButton] call _add;
_newButton ctrlSetText "New Note";
_newButton ctrlSetPosition [_pad + _usableW - _newButtonW, _pad, _newButtonW, _labelH + 0.006];
_newButton ctrlSetBackgroundColor _button;
_newButton ctrlSetTextColor _buttonText;
_newButton ctrlSetTooltip "Open a blank note.";
_newButton ctrlSetEventHandler ["ButtonClick", "call MMC_fnc_notesNew"];
_newButton ctrlCommit 0;
_controls append ([_display, _group, [_pad + _usableW - _newButtonW, _pad, _newButtonW, _labelH + 0.006], _border, 0.0012] call FUNC(createAppBorder));

private _titleEdit = _display ctrlCreate ["RscEdit", [_display] call FUNC(nextDynamicIdc), _group];
[_titleEdit] call _add;
_titleEdit ctrlSetText _noteTitle;
_titleEdit ctrlSetPosition [_pad, _titleY, _usableW, _titleH];
_titleEdit ctrlSetTextColor _textColor;
_titleEdit ctrlSetBackgroundColor _panel;
_titleEdit ctrlSetTooltip "Note name.";
_titleEdit ctrlCommit 0;
_controls append ([_display, _group, [_pad, _titleY, _usableW, _titleH], _border, 0.0012] call FUNC(createAppBorder));

private _bodyLabel = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
[_bodyLabel] call _add;
_bodyLabel ctrlSetText "Note";
_bodyLabel ctrlSetPosition [_pad, _noteLabelY, _usableW * 0.45, _labelH];
_bodyLabel ctrlSetTextColor _textColor;
_bodyLabel ctrlSetBackgroundColor [0, 0, 0, 0];
_bodyLabel ctrlCommit 0;

private _bodyHint = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
[_bodyHint] call _add;
_bodyHint ctrlSetStructuredText parseText "<t align='right' size='0.78'>Shift + Enter for Line Break</t>";
_bodyHint ctrlSetPosition [_pad + (_usableW * 0.45), _noteLabelY, _usableW * 0.55, _labelH];
_bodyHint ctrlSetTextColor _textColor;
_bodyHint ctrlSetBackgroundColor [0, 0, 0, 0];
_bodyHint ctrlCommit 0;

private _bodyBack = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
[_bodyBack] call _add;
_bodyBack ctrlSetText "";
_bodyBack ctrlEnable false;
_bodyBack ctrlSetPosition [_pad, _bodyY, _usableW, _bodyH];
_bodyBack ctrlSetBackgroundColor _panel;
_bodyBack ctrlCommit 0;

private _editInset = 0.006;
private _bodyEdit = _display ctrlCreate [QGVAR(RscComputerEditMulti), [_display] call FUNC(nextDynamicIdc), _group];
[_bodyEdit] call _add;
_bodyEdit ctrlSetText _noteBody;
_bodyEdit ctrlSetPosition [
	_pad + _editInset,
	_bodyY + _editInset,
	(_usableW - (_editInset * 2)) max 0.05,
	(_bodyH - (_editInset * 2)) max 0.05
];
_bodyEdit ctrlSetTextColor _textColor;
_bodyEdit ctrlSetBackgroundColor _panel;
_bodyEdit ctrlSetTooltip "Write note text. Shift+Enter adds a line break. Structured text tags can be kept for use in mails or desktop scripts.";
_bodyEdit ctrlCommit 0;
_controls append ([_display, _group, [_pad, _bodyY, _usableW, _bodyH], _border, 0.0012] call FUNC(createAppBorder));

private _save = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc), _group];
[_save] call _add;
_save ctrlSetText (["Save", "Save Copy"] select _isSystemNote);
_save ctrlSetPosition [_pad, _buttonY, _buttonW, _buttonH];
_save ctrlSetBackgroundColor _button;
_save ctrlSetTextColor _buttonText;
_save ctrlSetTooltip "Save this note to the active user account.";
_save ctrlSetEventHandler ["ButtonClick", "call MMC_fnc_notesSave"];
_save ctrlCommit 0;
_controls append ([_display, _group, [_pad, _buttonY, _buttonW, _buttonH], _border, 0.0012] call FUNC(createAppBorder));

private _delete = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc), _group];
[_delete] call _add;
_delete ctrlSetText "Delete";
_delete ctrlSetPosition [_pad + _buttonW + _gap, _buttonY, _buttonW, _buttonH];
_delete ctrlSetBackgroundColor _button;
_delete ctrlSetTextColor _buttonText;
_delete ctrlSetTooltip "Delete the selected personal note.";
_delete ctrlSetEventHandler ["ButtonClick", "call MMC_fnc_notesDelete"];
_delete ctrlEnable (_noteIsSaved && {!_isSystemNote});
_delete ctrlCommit 0;
_controls append ([_display, _group, [_pad + _buttonW + _gap, _buttonY, _buttonW, _buttonH], _border, 0.0012] call FUNC(createAppBorder));

private _mail = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc), _group];
[_mail] call _add;
_mail ctrlSetText "E-Mail";
_mail ctrlSetPosition [_pad + ((_buttonW + _gap) * 2), _buttonY, _buttonW, _buttonH];
_mail ctrlSetBackgroundColor _button;
_mail ctrlSetTextColor _buttonText;
_mail ctrlSetTooltip "Open the mail composer with this note as a draft.";
_mail ctrlSetEventHandler ["ButtonClick", "call MMC_fnc_notesMail"];
_mail ctrlCommit 0;
_controls append ([_display, _group, [_pad + ((_buttonW + _gap) * 2), _buttonY, _buttonW, _buttonH], _border, 0.0012] call FUNC(createAppBorder));

private _statusControl = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
[_statusControl] call _add;
private _meta = if (_noteIsSaved) then {
	format [
		"Modified: %1 %2",
		_selectedNote getOrDefault ["modifiedDate", _selectedNote getOrDefault ["createdDate", ""]],
		_selectedNote getOrDefault ["modifiedTime", _selectedNote getOrDefault ["createdTime", ""]]
	]
} else {
	"Unsaved note"
};
private _statusText = [_meta, format ["%1  |  %2", _meta, _status]] select (_status isNotEqualTo "");
_statusControl ctrlSetText _statusText;
_statusControl ctrlSetPosition [_pad, _statusY, _usableW, _statusH];
_statusControl ctrlSetTextColor _accent;
_statusControl ctrlSetBackgroundColor [0, 0, 0, 0];
_statusControl ctrlCommit 0;

private _scrollMarker = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
[_scrollMarker] call _add;
_scrollMarker ctrlSetText "";
_scrollMarker ctrlSetBackgroundColor [0, 0, 0, 0];
_scrollMarker ctrlSetPosition [0, (_statusY + _statusH + _pad) max (_groupH + 0.001), 0.001, 0.001];
_scrollMarker ctrlCommit 0;

{
	if (!isNull _x) then {
		_x setVariable [QGVAR(notesDynamicControl), true];
	};
} forEach _controls;

_display setVariable [QGVAR(notesTitleControl), _titleEdit];
_display setVariable [QGVAR(notesBodyGroupControl), controlNull];
_display setVariable [QGVAR(notesBodyControl), _bodyEdit];
_display setVariable [QGVAR(notesControls), _controls];
_display setVariable [QGVAR(customActionControls), _controls];

if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
	[_display] call FUNC(applyMobileDisplayLayout);
} else {
	ctrlSetFocus _list;
};
