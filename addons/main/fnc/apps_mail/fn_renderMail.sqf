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
	IDC_MMC_MAIL_ERROR
];
{(_display displayCtrl _x) ctrlShow false} forEach _allControls;

(_display displayCtrl IDC_MMC_APP_TITLE) ctrlSetText "Mail";
(_display displayCtrl IDC_MMC_MAIL_RECIPIENT_LABEL) ctrlSetText "Recipient";
(_display displayCtrl IDC_MMC_MAIL_SUBJECT_LABEL) ctrlSetText "Subject";
(_display displayCtrl IDC_MMC_MAIL_REPLY) ctrlSetText "Answer";
(_display displayCtrl IDC_MMC_MAIL_REPLY) ctrlSetTooltip "Answer this mail.";
(_display displayCtrl IDC_MMC_MAIL_REPLY) ctrlSetEventHandler ["ButtonClick", "['reply'] call MMC_fnc_mailCompose"];
(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetText "Forward";
(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetTooltip "Forward this mail.";
(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetEventHandler ["ButtonClick", "['forward'] call MMC_fnc_mailCompose"];
(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetText "Send";
(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetTooltip "";
(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetEventHandler ["ButtonClick", "call MMC_fnc_mailSendFromComposer"];
(_display displayCtrl IDC_MMC_MAIL_RECIPIENT) ctrlSetEventHandler ["KeyUp", ""];
(_display displayCtrl IDC_MMC_MAIL_SUBJECT) ctrlSetEventHandler ["KeyUp", ""];
(_display displayCtrl IDC_MMC_MAIL_CANCEL) ctrlSetText "Cancel";
(_display displayCtrl IDC_MMC_MAIL_CANCEL) ctrlSetTooltip "";
(_display displayCtrl IDC_MMC_MAIL_CANCEL) ctrlSetEventHandler ["ButtonClick", "['table'] call MMC_fnc_renderMail"];
{(_display displayCtrl _x) ctrlEnable true} forEach [IDC_MMC_MAIL_REPLY, IDC_MMC_MAIL_FORWARD, IDC_MMC_MAIL_SEND, IDC_MMC_MAIL_CANCEL];

private _rows = [
	createHashMapFromArray [["action", "folder"], ["folder", "inbox"], ["label", "Inbox"]],
	createHashMapFromArray [["action", "folder"], ["folder", "outbox"], ["label", "Outbox"]],
	createHashMapFromArray [["action", "compose"], ["label", "Send E-Mail"]],
	createHashMapFromArray [["action", "addressbook"], ["label", "Address Book"]]
];

lbClear _list;
{
	private _row = _list lbAdd (_x getOrDefault ["label", ""]);
	_list lbSetTooltip [_row, _x getOrDefault ["label", ""]];
} forEach _rows;
_display setVariable [QGVAR(mailNavRows), _rows];
_display setVariable [QGVAR(mailTableClickValid), false];

_table ctrlRemoveAllEventHandlers "MouseButtonDown";
_table ctrlAddEventHandler ["MouseButtonDown", {
	params ["_control", "_button", "_mouseX", "_mouseY"];
	private _display = ctrlParent _control;
	if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
		_display setVariable [QGVAR(startMenuOpen), false];
		_display setVariable [QGVAR(mobileNavOpen), false];
		_display setVariable [QGVAR(mobileCustomAppsOpen), false];
		[{
			params ["_display"];
			if (!isNull _display) then {
				[_display] call MMC_fnc_applyMobileDisplayLayout;
			};
		}, [_display], 0] call CBA_fnc_waitAndExecute;
	};
	private _rows = _display getVariable [QGVAR(mailRows), []];
	private _tablePos = ctrlPosition _control;
	private _localY = _mouseY;
	if (_mouseY >= (_tablePos select 1) && {_mouseY <= ((_tablePos select 1) + (_tablePos select 3))}) then {
		_localY = _mouseY - (_tablePos select 1);
	};
	private _rowHeight = 0.035;
	private _visibleRows = floor (((_tablePos select 3) max 0) / _rowHeight);
	private _clickableRows = (count _rows) min (_visibleRows max 0);
	private _clickedRow = floor (_localY / _rowHeight);
	_display setVariable [
		QGVAR(mailTableClickValid),
		_button isEqualTo 0 && {_localY >= 0 && {_clickedRow >= 0 && {_clickedRow < _clickableRows}}}
	];
}];

if (_fromNav) then {
	private _selected = _rows param [_index, createHashMap];
	private _navAction = _selected getOrDefault ["action", ""];
	if (_navAction isEqualTo "folder") then {
		_display setVariable [QGVAR(mailFolder), _selected getOrDefault ["folder", "inbox"]];
		_display setVariable [QGVAR(mailMode), "table"];
		_display setVariable [QGVAR(mobileMailTablePage), 0];
	};
	if (_navAction isEqualTo "compose") then {
		_display setVariable [QGVAR(mailMode), "compose"];
		_display setVariable [QGVAR(composeMode), "new"];
		_display setVariable [QGVAR(mailFrom), ""];
		{
			(_display displayCtrl _x) ctrlSetText "";
		} forEach [IDC_MMC_MAIL_RECIPIENT, IDC_MMC_MAIL_CC, IDC_MMC_MAIL_SUBJECT, IDC_MMC_MAIL_ATTACHMENT, IDC_MMC_MAIL_ATTACHMENT_DESC, IDC_MMC_MAIL_BODY, IDC_MMC_MAIL_ERROR];
	};
	if (_navAction isEqualTo "addressbook") then {
		_display setVariable [QGVAR(mailMode), "addressbook"];
		_display setVariable [QGVAR(selectedAddressBookIndex), -1];
	};
};

if (_action isEqualTo "table") then {
	_display setVariable [QGVAR(mailMode), "table"];
};
if (_action isEqualTo "addressbook") then {
	_display setVariable [QGVAR(mailMode), "addressbook"];
};

private _mode = _display getVariable [QGVAR(mailMode), "table"];
_display setVariable [QGVAR(mailMode), _mode];
private _folder = _display getVariable [QGVAR(mailFolder), "inbox"];
private _email = _activeUser getOrDefault ["email", ""];
private _aliases = _activeUser getOrDefault ["emailAliases", []];
if !(_aliases isEqualType []) then {
	_aliases = [];
};
private _senderAddresses = [];
{
	private _address = [_x] call CBA_fnc_trim;
	if (_address isNotEqualTo "" && {!((toLowerANSI _address) in (_senderAddresses apply {toLowerANSI _x}))}) then {
		_senderAddresses pushBack _address;
	};
} forEach ([_email] + _aliases);
private _title = _display displayCtrl IDC_MMC_APP_TITLE;
_title ctrlSetText format ["Mail - %1", _email];
if (_aliases isNotEqualTo []) then {
	_title ctrlSetTooltip format ["Aliases: %1", _aliases joinString ", "];
} else {
	_title ctrlSetTooltip _email;
};

if (_mode isEqualTo "compose") exitWith {
	_body ctrlSetStructuredText parseText "";
	(_display displayCtrl IDC_MMC_MAIL_HEADER) ctrlShow true;
	(_display displayCtrl IDC_MMC_MAIL_HEADER) ctrlSetText "New E-Mail";
	(_display displayCtrl IDC_MMC_MAIL_ERROR) ctrlSetText "";
	{
		(_display displayCtrl _x) ctrlShow true;
	} forEach [
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
		IDC_MMC_MAIL_FORWARD,
		IDC_MMC_MAIL_SEND,
		IDC_MMC_MAIL_CANCEL,
		IDC_MMC_MAIL_ERROR
	];
	(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetText "Address Book";
	(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetTooltip "Open the address book.";
	(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetEventHandler ["ButtonClick", "
		params ['_control'];
		private _display = ctrlParent _control;
		_display setVariable ['MMC_main_mailComposeDraft', createHashMapFromArray [
			['recipient', ctrlText (_display displayCtrl 860076)],
			['cc', ctrlText (_display displayCtrl 860092)],
			['subject', ctrlText (_display displayCtrl 860078)],
			['body', ctrlText (_display displayCtrl 860082)],
			['attachment', ctrlText (_display displayCtrl 860080)],
			['attachmentDescription', ctrlText (_display displayCtrl 860094)]
		]];
		_display setVariable ['MMC_main_mailMode', 'addressbook'];
		_display setVariable ['MMC_main_selectedAddressBookIndex', -1];
		_display setVariable ['MMC_main_selectedAddressBookEntry', createHashMap];
		['addressbook'] call MMC_fnc_renderMail;
	"];
	private _showFrom = (_display getVariable [QGVAR(isMobileDisplay), false]) && {(count _senderAddresses) > 1};
	if (_showFrom) then {
		private _fromCombo = _display displayCtrl IDC_MMC_MAIL_FROM;
		private _selectedFrom = _display getVariable [QGVAR(mailFrom), _email];
		lbClear _fromCombo;
		private _selectedIndex = -1;
		{
			private _row = _fromCombo lbAdd _x;
			_fromCombo lbSetData [_row, _x];
			if (toLowerANSI _x isEqualTo toLowerANSI _selectedFrom) then {
				_selectedIndex = _row;
			};
		} forEach _senderAddresses;
		_fromCombo lbSetCurSel (_selectedIndex max 0);
		(_display displayCtrl IDC_MMC_MAIL_FROM_LABEL) ctrlShow true;
		_fromCombo ctrlShow true;
	} else {
		(_display displayCtrl IDC_MMC_MAIL_FROM_LABEL) ctrlShow false;
		(_display displayCtrl IDC_MMC_MAIL_FROM) ctrlShow false;
	};
	call FUNC(resizeMailBody);
	if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
		[_display] call FUNC(applyMobileDisplayLayout);
	} else {
		private _buttonW = 0.124;
		private _buttonGap = 0.008;
		private _buttonY = safeZoneY + 0.153;
		private _cancelX = safeZoneX + safeZoneW - 0.2;
		private _sendX = _cancelX - _buttonGap - _buttonW;
		private _addressBookX = _sendX - _buttonGap - _buttonW;
		(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetPosition [_addressBookX, _buttonY, _buttonW, 0.036];
		(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetPosition [_sendX, _buttonY, _buttonW, 0.036];
		(_display displayCtrl IDC_MMC_MAIL_CANCEL) ctrlSetPosition [_cancelX, _buttonY, _buttonW, 0.036];
		{(_display displayCtrl _x) ctrlCommit 0} forEach [IDC_MMC_MAIL_FORWARD, IDC_MMC_MAIL_SEND, IDC_MMC_MAIL_CANCEL];
	};
};

if (_mode isEqualTo "addressbook") exitWith {
	_body ctrlSetStructuredText parseText "";
	_header ctrlShow true;
	_table ctrlShow true;
	(_display displayCtrl IDC_MMC_FRAME_MAIL_TABLE) ctrlShow true;
	_header ctrlSetText "Address Book";

	{
		(_display displayCtrl _x) ctrlShow true;
	} forEach [
		IDC_MMC_MAIL_RECIPIENT_LABEL,
		IDC_MMC_MAIL_RECIPIENT,
		IDC_MMC_MAIL_SUBJECT_LABEL,
		IDC_MMC_MAIL_SUBJECT,
		IDC_MMC_MAIL_REPLY,
		IDC_MMC_MAIL_FORWARD,
		IDC_MMC_MAIL_SEND,
		IDC_MMC_MAIL_CANCEL,
		IDC_MMC_MAIL_ERROR
	];

	(_display displayCtrl IDC_MMC_MAIL_RECIPIENT_LABEL) ctrlSetText "Name";
	(_display displayCtrl IDC_MMC_MAIL_SUBJECT_LABEL) ctrlSetText "E-Mail";
	(_display displayCtrl IDC_MMC_MAIL_REPLY) ctrlSetText "Use To";
	(_display displayCtrl IDC_MMC_MAIL_REPLY) ctrlSetTooltip "Use the selected address as recipient in a new e-mail.";
	(_display displayCtrl IDC_MMC_MAIL_REPLY) ctrlSetEventHandler ["ButtonClick", "['to'] call MMC_fnc_mailAddressBookUse"];
	(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetText "Use CC";
	(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetTooltip "Use the selected address as CC in a new e-mail.";
	(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetEventHandler ["ButtonClick", "['cc'] call MMC_fnc_mailAddressBookUse"];
	(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetText "Save";
	(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetTooltip "Save or update this address book entry.";
	(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetEventHandler ["ButtonClick", "call MMC_fnc_mailAddressBookSave"];
	(_display displayCtrl IDC_MMC_MAIL_RECIPIENT) ctrlSetEventHandler ["KeyUp", "call MMC_fnc_mailAddressBookUpdateSaveState"];
	(_display displayCtrl IDC_MMC_MAIL_SUBJECT) ctrlSetEventHandler ["KeyUp", "call MMC_fnc_mailAddressBookUpdateSaveState"];
	(_display displayCtrl IDC_MMC_MAIL_CANCEL) ctrlSetText "Delete";
	(_display displayCtrl IDC_MMC_MAIL_CANCEL) ctrlSetTooltip "Delete the selected address book entry.";
	(_display displayCtrl IDC_MMC_MAIL_CANCEL) ctrlSetEventHandler ["ButtonClick", "call MMC_fnc_mailAddressBookDelete"];
	private _addressBookStatus = _display getVariable [QGVAR(mailAddressBookStatus), ""];
	(_display displayCtrl IDC_MMC_MAIL_ERROR) ctrlSetText _addressBookStatus;
	_display setVariable [QGVAR(mailAddressBookStatus), ""];
	private _hasAddressSelection = (_display getVariable [QGVAR(selectedAddressBookIndex), -1]) >= 0;
	if (!_hasAddressSelection) then {
		(_display displayCtrl IDC_MMC_MAIL_RECIPIENT) ctrlSetText "";
		(_display displayCtrl IDC_MMC_MAIL_SUBJECT) ctrlSetText "";
	};
	(_display displayCtrl IDC_MMC_MAIL_REPLY) ctrlEnable _hasAddressSelection;
	(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlEnable _hasAddressSelection;
	(_display displayCtrl IDC_MMC_MAIL_CANCEL) ctrlEnable _hasAddressSelection;
	[_display] call FUNC(mailAddressBookUpdateSaveState);

	lnbClear _table;
	private _entries = [_computer, _activeUser] call FUNC(getAddressBookEntries);
	private _headerRow = _table lnbAddRow ["", "Name", "E-Mail", "", "", ""];
	for "_column" from 0 to 5 do {
		_table lnbSetColor [[_headerRow, _column], [1, 1, 1, 1]];
	};
	{
		private _row = _table lnbAddRow ["", _x getOrDefault ["name", ""], _x getOrDefault ["email", ""], "", "", ""];
		_table lnbSetTooltip [[_row, 1], _x getOrDefault ["name", ""]];
		_table lnbSetTooltip [[_row, 2], _x getOrDefault ["email", ""]];
	} forEach _entries;
	_display setVariable [QGVAR(addressBookRows), [createHashMap] + _entries];
	if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
		[_display] call FUNC(applyMobileDisplayLayout);
	} else {
		private _innerX = safeZoneX + 0.445;
		private _innerW = safeZoneW - 0.64;
		private _bottomY = safeZoneY + safeZoneH - 0.255;
		private _fieldH = 0.036;
		private _labelH = 0.028;
		private _gapY = 0.011;
		private _buttonGap = 0.007;
		private _buttonW = (_innerW - (_buttonGap * 3)) / 4;
		private _buttonY = safeZoneY + safeZoneH - 0.069;
		_header ctrlSetPosition [_innerX, safeZoneY + 0.153, _innerW, 0.034];
		_table ctrlSetPosition [_innerX, safeZoneY + 0.193, _innerW, safeZoneH - 0.47];
		(_display displayCtrl IDC_MMC_FRAME_MAIL_TABLE) ctrlSetPosition [_innerX, safeZoneY + 0.193, _innerW, safeZoneH - 0.47];
		(_display displayCtrl IDC_MMC_MAIL_RECIPIENT_LABEL) ctrlSetPosition [_innerX, _bottomY, _innerW * 0.34, _labelH];
		(_display displayCtrl IDC_MMC_MAIL_RECIPIENT) ctrlSetPosition [_innerX, _bottomY + _labelH + _gapY, _innerW, _fieldH];
		(_display displayCtrl IDC_MMC_MAIL_SUBJECT_LABEL) ctrlSetPosition [_innerX, _bottomY + _labelH + _gapY + _fieldH + (_gapY * 1.8), _innerW, _labelH];
		(_display displayCtrl IDC_MMC_MAIL_SUBJECT) ctrlSetPosition [_innerX, _bottomY + (_labelH * 2) + (_gapY * 2.8) + _fieldH, _innerW, _fieldH];
		(_display displayCtrl IDC_MMC_MAIL_REPLY) ctrlSetPosition [_innerX, _buttonY, _buttonW, 0.036];
		(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetPosition [_innerX + _buttonW + _buttonGap, _buttonY, _buttonW, 0.036];
		(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetPosition [_innerX + ((_buttonW + _buttonGap) * 2), _buttonY, _buttonW, 0.036];
		(_display displayCtrl IDC_MMC_MAIL_CANCEL) ctrlSetPosition [_innerX + ((_buttonW + _buttonGap) * 3), _buttonY, _buttonW, 0.036];
		(_display displayCtrl IDC_MMC_MAIL_ERROR) ctrlSetPosition [_innerX + (_innerW * 0.36), _bottomY, _innerW * 0.64, _labelH];
		{(_display displayCtrl _x) ctrlCommit 0} forEach [
			IDC_MMC_MAIL_HEADER,
			IDC_MMC_MAIL_TABLE,
			IDC_MMC_FRAME_MAIL_TABLE,
			IDC_MMC_MAIL_RECIPIENT_LABEL,
			IDC_MMC_MAIL_RECIPIENT,
			IDC_MMC_MAIL_SUBJECT_LABEL,
			IDC_MMC_MAIL_SUBJECT,
			IDC_MMC_MAIL_REPLY,
			IDC_MMC_MAIL_FORWARD,
			IDC_MMC_MAIL_SEND,
			IDC_MMC_MAIL_CANCEL,
			IDC_MMC_MAIL_ERROR
		];
	};
};

if (_mode isEqualTo "read") exitWith {
	private _mail = _display getVariable [QGVAR(selectedMail), createHashMap];
	private _isInbox = (_display getVariable [QGVAR(selectedMailFolder), "inbox"]) isEqualTo "inbox";
	private _readMeta = _display displayCtrl IDC_MMC_MAIL_READ_META;
	private _readGroup = _display displayCtrl IDC_MMC_MAIL_READ_GROUP;
	private _readBody = _display displayCtrl IDC_MMC_MAIL_READ_BODY;
	(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlShow true;
	(_display displayCtrl IDC_MMC_MAIL_REPLY) ctrlShow _isInbox;
	(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlShow true;
	(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetText "Save Address";
	(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetTooltip "Save this mail contact to your address book.";
	(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetEventHandler ["ButtonClick", "call MMC_fnc_mailAddressBookSaveSelectedMail"];
	if !(_display getVariable [QGVAR(isMobileDisplay), false]) then {
		private _buttonW = 0.124;
		private _buttonGap = 0.008;
		private _buttonY = 0.176;
		private _saveX = 0.746;
		(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetPosition [_saveX, _buttonY, _buttonW, 0.036];
		(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetPosition [_saveX - _buttonW - _buttonGap, _buttonY, _buttonW, 0.036];
		(_display displayCtrl IDC_MMC_MAIL_REPLY) ctrlSetPosition [_saveX - ((_buttonW + _buttonGap) * 2), _buttonY, _buttonW, 0.036];
		{(_display displayCtrl _x) ctrlCommit 0} forEach [IDC_MMC_MAIL_SEND, IDC_MMC_MAIL_FORWARD, IDC_MMC_MAIL_REPLY];
	};
	_readMeta ctrlShow true;
	_readGroup ctrlShow true;
	private _attachment = _mail getOrDefault ["attachment", ""];
	private _attachmentDescription = _mail getOrDefault ["attachmentDescription", ""];
	private _attachmentText = ["", format [
		"<br/><br/><t color='#9fb6d8'>Attachment: %1%2</t>",
		_attachment,
		["", format ["<br/>%1", [_attachmentDescription] call FUNC(normalizeStructuredText)]] select (_attachmentDescription isNotEqualTo "")
	]] select (_attachment isNotEqualTo "");
	private _bodyText = [_mail getOrDefault ["body", ""]] call FUNC(normalizeStructuredText);
	_body ctrlSetStructuredText parseText "";
	private _metaSize = [1.25, 1.06] select (_display getVariable [QGVAR(isMobileDisplay), false]);
	_readMeta ctrlSetStructuredText parseText format [
		"<t size='%7'>%1</t><br/><t color='#9fb6d8' size='0.92'>From: %2<br/>To: %3<br/>CC: %4<br/>Date: %5 %6</t>",
		_mail getOrDefault ["subject", "No subject"],
		_mail getOrDefault ["from", ""],
		_mail getOrDefault ["to", ""],
		_mail getOrDefault ["cc", ""],
		_mail getOrDefault ["date", ""],
		_mail getOrDefault ["time", ""],
		_metaSize
	];
	_readBody ctrlSetStructuredText parseText format ["%1%2", _bodyText, _attachmentText];
	private _readHeight = 0.12 max ((ctrlTextHeight _readBody) + 0.02);
	private _pos = ctrlPosition _readBody;
	_pos set [3, _readHeight];
	_readBody ctrlSetPosition _pos;
	_readBody ctrlCommit 0;
	if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
		[_display] call FUNC(applyMobileDisplayLayout);
	};
};

private _mail = if (_folder isEqualTo "outbox") then {
	_activeUser getOrDefault ["outbox", []]
} else {
	private _computerData = _display getVariable [QGVAR(data), createHashMap];
	private _recipientAddresses = _senderAddresses apply {toLowerANSI ([_x] call CBA_fnc_trim)};
	((_computerData getOrDefault ["mail", []]) + (_activeUser getOrDefault ["mail", []])) select {
		private _to = toLowerANSI (_x getOrDefault ["to", ""]);
		_to in ["", "*"] || {_to in _recipientAddresses}
	}
};

_mail = ([_mail, [], {
	format [
		"%1 %2",
		_x getOrDefault ["date", "0000-00-00"],
		_x getOrDefault ["time", "00:00"]
	]
}, "DESCEND"] call BIS_fnc_sortBy);

_body ctrlSetStructuredText parseText "";
_header ctrlShow true;
_table ctrlShow true;
(_display displayCtrl IDC_MMC_FRAME_MAIL_TABLE) ctrlShow true;
_header ctrlSetText (["Inbox", "Outbox"] select (_folder isEqualTo "outbox"));
(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlShow true;
(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetText "New Mail";
(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetTooltip "Compose a new e-mail.";
(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetEventHandler ["ButtonClick", "
	params ['_control'];
	private _display = ctrlParent _control;
	_display setVariable ['MMC_main_mailMode', 'compose'];
	_display setVariable ['MMC_main_composeMode', 'new'];
	['compose'] call MMC_fnc_renderMail;
"];
(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlShow true;
(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetText "Address Book";
(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetTooltip "Open the address book.";
(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetEventHandler ["ButtonClick", "
	params ['_control'];
	private _display = ctrlParent _control;
	_display setVariable ['MMC_main_mailMode', 'addressbook'];
	_display setVariable ['MMC_main_selectedAddressBookIndex', -1];
	_display setVariable ['MMC_main_selectedAddressBookEntry', createHashMap];
	['addressbook'] call MMC_fnc_renderMail;
"];
if !(_display getVariable [QGVAR(isMobileDisplay), false]) then {
	private _buttonW = 0.124;
	private _buttonGap = 0.008;
	private _buttonY = safeZoneY + 0.153;
	private _rightArrowX = safeZoneX + safeZoneW - 0.215;
	private _addressBookX = _rightArrowX - _buttonGap - _buttonW;
	private _newMailX = _addressBookX - _buttonGap - _buttonW;
	(_display displayCtrl IDC_MMC_MAIL_FORWARD) ctrlSetPosition [_newMailX, _buttonY, _buttonW, 0.036];
	(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlSetPosition [_addressBookX, _buttonY, _buttonW, 0.036];
	{(_display displayCtrl _x) ctrlCommit 0} forEach [IDC_MMC_MAIL_FORWARD, IDC_MMC_MAIL_SEND];
};
lnbClear _table;

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _isLight = _themeConfig getOrDefault ["isLight", false];
private _textColor = _themeConfig getOrDefault ["text", [[1, 1, 1, 1], [0, 0, 0, 1]] select _isLight];
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
	private _isRead = _x getOrDefault ["read", true];
	private _row = _table lnbAddRow [
		"",
		_x getOrDefault ["date", ""],
		_x getOrDefault ["time", ""],
		_x getOrDefault ["subject", "No subject"],
		_who,
		_attachmentName
	];
	_table lnbSetPicture [[_row, 0], [_unreadIcon, _readIcon] select _isRead];
	if (_isLight) then {
		for "_column" from 1 to 5 do {
			_table lnbSetColor [[_row, _column], _textColor];
		};
	};
	if (!_isRead) then {
		if (_isLight) then {
			for "_column" from 1 to 5 do {
				_table lnbSetColor [[_row, _column], _unreadColor];
			};
		};
	};
	_table lnbSetTooltip [[_row, 3], _x getOrDefault ["subject", "No subject"]];
	_table lnbSetTooltip [[_row, 4], _who];
	_table lnbSetTooltip [[_row, 5], _attachmentName];
} forEach _mail;

_display setVariable [QGVAR(mailRows), [createHashMap] + _mail];
_display setVariable [QGVAR(mailFolder), _folder];
if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
	[_display] call FUNC(applyMobileDisplayLayout);
};
