#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Renders the Mail application views.
 */

params [
	["_action", "table", [""]],
	["_index", -1, [0]],
	["_fromNav", false, [false]]
];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _activeUser = [_computer] call FUNC(getActiveUser);
private _list = _display displayCtrl IDC_MMC_APP_LIST;
private _body = _display displayCtrl IDC_MMC_APP_BODY;
private _table = _display displayCtrl IDC_MMC_MAIL_TABLE;
private _header = _display displayCtrl IDC_MMC_MAIL_HEADER;

private _allControls = [
	IDC_MMC_MAIL_HEADER,
	IDC_MMC_MAIL_TABLE,
	IDC_MMC_FRAME_MAIL_TABLE,
	IDC_MMC_MAIL_REPLY,
	IDC_MMC_MAIL_FORWARD,
	IDC_MMC_MAIL_RECIPIENT_LABEL,
	IDC_MMC_MAIL_RECIPIENT,
	IDC_MMC_MAIL_SUBJECT_LABEL,
	IDC_MMC_MAIL_SUBJECT,
	IDC_MMC_MAIL_ATTACHMENT_LABEL,
	IDC_MMC_MAIL_ATTACHMENT,
	IDC_MMC_MAIL_BODY_LABEL,
	IDC_MMC_MAIL_BODY,
	IDC_MMC_MAIL_SEND,
	IDC_MMC_MAIL_CANCEL,
	IDC_MMC_MAIL_ERROR
];
{(_display displayCtrl _x) ctrlShow false} forEach _allControls;

(_display displayCtrl IDC_MMC_APP_TITLE) ctrlSetText "Mail";

private _rows = [
	createHashMapFromArray [["action", "folder"], ["folder", "inbox"], ["label", "Inbox"]],
	createHashMapFromArray [["action", "folder"], ["folder", "outbox"], ["label", "Outbox"]],
	createHashMapFromArray [["action", "compose"], ["label", "Send E-Mail"]]
];

lbClear _list;
{
	private _row = _list lbAdd (_x getOrDefault ["label", ""]);
	_list lbSetTooltip [_row, _x getOrDefault ["label", ""]];
} forEach _rows;
_display setVariable [QGVAR(mailNavRows), _rows];

if (_fromNav) then {
	private _selected = _rows param [_index, createHashMap];
	private _navAction = _selected getOrDefault ["action", ""];
	if (_navAction isEqualTo "folder") then {
		_display setVariable [QGVAR(mailFolder), _selected getOrDefault ["folder", "inbox"]];
		_display setVariable [QGVAR(mailMode), "table"];
	};
	if (_navAction isEqualTo "compose") then {
		_display setVariable [QGVAR(mailMode), "compose"];
		_display setVariable [QGVAR(composeMode), "new"];
		{
			(_display displayCtrl _x) ctrlSetText "";
		} forEach [IDC_MMC_MAIL_RECIPIENT, IDC_MMC_MAIL_SUBJECT, IDC_MMC_MAIL_ATTACHMENT, IDC_MMC_MAIL_BODY, IDC_MMC_MAIL_ERROR];
	};
};

if (_action isEqualTo "table") then {
	_display setVariable [QGVAR(mailMode), "table"];
};

private _mode = _display getVariable [QGVAR(mailMode), "table"];
private _folder = _display getVariable [QGVAR(mailFolder), "inbox"];
private _email = _activeUser getOrDefault ["email", ""];
(_display displayCtrl IDC_MMC_APP_TITLE) ctrlSetText format ["Mail - %1", _email];

if (_mode isEqualTo "compose") exitWith {
	_body ctrlSetStructuredText parseText "";
	(_display displayCtrl IDC_MMC_MAIL_HEADER) ctrlShow true;
	(_display displayCtrl IDC_MMC_MAIL_HEADER) ctrlSetText "New E-Mail";
	{
		(_display displayCtrl _x) ctrlShow true;
	} forEach [
		IDC_MMC_MAIL_RECIPIENT_LABEL,
		IDC_MMC_MAIL_RECIPIENT,
		IDC_MMC_MAIL_SUBJECT_LABEL,
		IDC_MMC_MAIL_SUBJECT,
		IDC_MMC_MAIL_ATTACHMENT_LABEL,
		IDC_MMC_MAIL_ATTACHMENT,
		IDC_MMC_MAIL_BODY_LABEL,
		IDC_MMC_MAIL_BODY,
		IDC_MMC_MAIL_SEND,
		IDC_MMC_MAIL_CANCEL,
		IDC_MMC_MAIL_ERROR
	];
};

if (_mode isEqualTo "read") exitWith {
	private _mail = _display getVariable [QGVAR(selectedMail), createHashMap];
	private _isInbox = (_display getVariable [QGVAR(selectedMailFolder), "inbox"]) isEqualTo "inbox";
	(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlShow true;
	(_display displayCtrl IDC_MMC_MAIL_REPLY) ctrlShow _isInbox;
	private _attachment = _mail getOrDefault ["attachment", ""];
	private _attachmentText = ["", format ["<br/><br/><t color='#9fb6d8'>Attachment: %1</t>", _attachment]] select (_attachment isNotEqualTo "");
	private _bodyText = ((_mail getOrDefault ["body", ""]) splitString (toString [10])) joinString "<br/>";
	_body ctrlSetStructuredText parseText format [
		"<t size='1.25'>%1</t><br/><t color='#9fb6d8'>From: %2<br/>To: %3<br/>Date: %4 %5</t><br/><br/>%6%7",
		_mail getOrDefault ["subject", "No subject"],
		_mail getOrDefault ["from", ""],
		_mail getOrDefault ["to", ""],
		_mail getOrDefault ["date", ""],
		_mail getOrDefault ["time", ""],
		_bodyText,
		_attachmentText
	];
};

private _mail = if (_folder isEqualTo "outbox") then {
	_activeUser getOrDefault ["outbox", []]
} else {
	private _computerData = _display getVariable [QGVAR(data), createHashMap];
	((_computerData getOrDefault ["mail", []]) + (_activeUser getOrDefault ["mail", []])) select {
		private _to = toLowerANSI (_x getOrDefault ["to", ""]);
		_to in ["", "*"] || {_to isEqualTo toLowerANSI _email}
	}
};

_body ctrlSetStructuredText parseText "";
_header ctrlShow true;
_table ctrlShow true;
(_display displayCtrl IDC_MMC_FRAME_MAIL_TABLE) ctrlShow true;
_header ctrlSetText (["Inbox", "Outbox"] select (_folder isEqualTo "outbox"));
lnbClear _table;

private _theme = GVAR(profileTheme);
private _isLight = _theme isEqualTo "light";
private _readIcon = [PATHTOF(img\mail_read_white.paa), PATHTOF(img\mail_read_black.paa)] select _isLight;
private _unreadIcon = [PATHTOF(img\mail_unread_white.paa), PATHTOF(img\mail_unread_black.paa)] select _isLight;
private _unreadColor = [[1, 1, 1, 1], [0, 0, 0, 1]] select _isLight;
private _headerRow = _table lnbAddRow ["", "Date", "Time", "Subject", ["Author", "Recipient"] select (_folder isEqualTo "outbox"), "Attachment"];
for "_column" from 0 to 5 do {
	_table lnbSetColor [[_headerRow, _column], _unreadColor];
};

{
	private _who = [_x getOrDefault ["from", ""], _x getOrDefault ["to", ""]] select (_folder isEqualTo "outbox");
	private _attachment = _x getOrDefault ["attachment", ""];
	private _attachmentName = if (_attachment isEqualTo "") then {""} else {
		private _parts = _attachment splitString "\/";
		_parts select ((count _parts - 1) max 0)
	};
	private _isRead = (_x getOrDefault ["read", true]) || {_folder isEqualTo "outbox"};
	private _row = _table lnbAddRow [
		"",
		_x getOrDefault ["date", ""],
		_x getOrDefault ["time", ""],
		_x getOrDefault ["subject", "No subject"],
		_who,
		_attachmentName
	];
	_table lnbSetPicture [[_row, 0], [_unreadIcon, _readIcon] select _isRead];
	if (!_isRead) then {
		for "_column" from 1 to 5 do {
			_table lnbSetColor [[_row, _column], _unreadColor];
		};
	};
	_table lnbSetTooltip [[_row, 3], _x getOrDefault ["subject", "No subject"]];
	_table lnbSetTooltip [[_row, 4], _who];
	_table lnbSetTooltip [[_row, 5], _attachmentName];
} forEach _mail;

_display setVariable [QGVAR(mailRows), [createHashMap] + _mail];
_display setVariable [QGVAR(mailFolder), _folder];
