#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Renders one of the desktop applications.
 *
 * Arguments:
 * 0: App id or "select" <STRING>
 * 1: Selection event data <ARRAY, optional>
 */

params [
	["_app", "desktop", [""]],
	["_event", [], [[]]]
];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _data = _display getVariable [QGVAR(data), createHashMap];
private _poweredOn = _computer getVariable [QGVAR(poweredOn), true];
private _activeUser = [_computer] call FUNC(getActiveUser);

private _title = _display displayCtrl IDC_MMC_APP_TITLE;
private _list = _display displayCtrl IDC_MMC_APP_LIST;
private _body = _display displayCtrl IDC_MMC_APP_BODY;
_body ctrlEnable false;
private _desktopGroup = _display displayCtrl IDC_MMC_DESKTOP_CONTENT_GROUP;
private _desktopBody = _display displayCtrl IDC_MMC_DESKTOP_CONTENT_BODY;
private _previewImage = _display displayCtrl IDC_MMC_FILE_PREVIEW_IMAGE;
private _previewFrame = _display displayCtrl IDC_MMC_FRAME_FILE_PREVIEW_IMAGE;
private _descriptionGroup = _display displayCtrl IDC_MMC_FILE_DESCRIPTION_GROUP;
private _descriptionBody = _display displayCtrl IDC_MMC_FILE_DESCRIPTION_BODY;
private _descriptionFrame = _display displayCtrl IDC_MMC_FRAME_FILE_DESCRIPTION;
private _mediaControls = [
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
	IDC_MMC_FRAME_MEDIA_NEXT
];
private _mailControls = [
	IDC_MMC_MAIL_HEADER,
	IDC_MMC_MAIL_TABLE,
	IDC_MMC_FRAME_MAIL_TABLE,
	IDC_MMC_MAIL_REPLY,
	IDC_MMC_MAIL_FORWARD,
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

{
	(_display displayCtrl _x) ctrlShow false;
} forEach _mediaControls;
{
	(_display displayCtrl _x) ctrlShow false;
} forEach _mailControls;
_desktopGroup ctrlShow false;
_desktopBody ctrlSetStructuredText parseText "";
_previewImage ctrlShow false;
_previewFrame ctrlShow false;
_descriptionGroup ctrlShow false;
_descriptionFrame ctrlShow false;
_previewImage ctrlSetText "";
_descriptionBody ctrlSetStructuredText parseText "";

if (!_poweredOn) exitWith {
	[_display, true, ["MMC", "System powered off", ""], -1] call FUNC(setSystemOverlay);
	_title ctrlSetText "";
	lbClear _list;
	_body ctrlSetStructuredText parseText "";
};

[_display, false] call FUNC(setSystemOverlay);

if (count _activeUser == 0) exitWith {
	[_display] call FUNC(showLogin);
};

private _isSelect = _app isEqualTo "select";
if (_app isEqualTo "select") then {
	_app = _display getVariable [QGVAR(currentApp), "desktop"];
} else {
	_display setVariable [QGVAR(currentApp), _app];
	if (_app isEqualTo "files") then {
		_display setVariable [QGVAR(filesFolder), ""];
	};
};

private _index = if (_event isEqualTo []) then {lbCurSel _list} else {_event select 1};
lbClear _list;

private _setBody = {
	params ["_text"];
	_body ctrlSetStructuredText parseText _text;
};
private _noContent = "<t size='1.25'>No Content available</t>";

switch (_app) do {
	case "files": {
		_title ctrlSetText "Files";
		private _files = (_data getOrDefault ["files", []]) + (_activeUser getOrDefault ["files", []]);
		private _statusText = _display getVariable [QGVAR(mediaStatusText), "Selected: No Audio File Selected"];
		{
			(_display displayCtrl _x) ctrlShow true;
			(_display displayCtrl _x) ctrlSetFade 0;
			(_display displayCtrl _x) ctrlCommit 0;
		} forEach _mediaControls;
		(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText _statusText;

		if (_files isEqualTo []) exitWith {
			[_noContent] call _setBody;
		};

		private _folder = _display getVariable [QGVAR(filesFolder), ""];
		if (_isSelect) then {
			private _rows = _display getVariable [QGVAR(fileListRows), []];
			private _selectedRow = _rows param [_index, createHashMap];
			private _action = _selectedRow getOrDefault ["action", ""];
			if (_action isEqualTo "folder") then {
				_folder = _selectedRow getOrDefault ["type", ""];
				_display setVariable [QGVAR(filesFolder), _folder];
				_index = 0;
			};
			if (_action isEqualTo "back") then {
				_folder = "";
				_display setVariable [QGVAR(filesFolder), _folder];
				_index = 0;
			};
		};

		private _rows = [];
		if (_folder isEqualTo "") then {
			{
				_x params ["_label", "_type"];
				private _row = _list lbAdd _label;
				_list lbSetTooltip [_row, format ["Open %1.", _label]];
				_rows pushBack createHashMapFromArray [["action", "folder"], ["type", _type]];
			} forEach [
				["Text Files", "text"],
				["Audio Files", "audio"],
				["Pictures", "picture"]
			];
			_display setVariable [QGVAR(fileListRows), _rows];
			["<t size='1.25'>Folders</t><br/><br/>Select a folder to view files from the computer and the active user account."] call _setBody;
		} else {
			private _backRow = _list lbAdd "<- Back";
			_list lbSetTooltip [_backRow, "Return to file folders."];
			_rows pushBack createHashMapFromArray [["action", "back"]];

			private _folderFiles = _files select {(_x getOrDefault ["type", "file"]) isEqualTo _folder};
			{
				private _row = _list lbAdd (_x getOrDefault ["name", "Untitled"]);
				_list lbSetTooltip [_row, format [
					"%1%2Type: %3",
					_x getOrDefault ["path", _x getOrDefault ["name", "Untitled"]],
					toString [10],
					_x getOrDefault ["type", "file"]
				]];
				_rows pushBack createHashMapFromArray [["action", "file"], ["file", _x]];
			} forEach _folderFiles;

			_display setVariable [QGVAR(fileListRows), _rows];

			if (_folderFiles isEqualTo []) exitWith {
				[_noContent] call _setBody;
			};

			private _rowData = _rows param [_index, createHashMap];
			if ((_rowData getOrDefault ["action", ""]) isNotEqualTo "file") exitWith {
				["<t size='1.25'>Folders</t><br/><br/>Select a file in this folder."] call _setBody;
			};

			private _file = _rowData getOrDefault ["file", createHashMap];
			private _type = _file getOrDefault ["type", "file"];
			if (_type isEqualTo "audio") then {
				_display setVariable [QGVAR(selectedMediaFile), _file];
				_statusText = format ["Selected: %1", _file getOrDefault ["name", "media"]];
				(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText _statusText;
				_display setVariable [QGVAR(mediaStatusText), _statusText];
			};
			private _mediaHint = ["", "<br/><br/><t color='#9fb6d8'>Use the media controls below to play this file.</t>"] select (_type isEqualTo "audio");
			private _assetInfo = switch (_type) do {
				case "picture": {
					_previewImage ctrlSetText (_file getOrDefault ["texture", ""]);
					_previewImage ctrlShow true;
					_previewFrame ctrlShow true;
					_descriptionBody ctrlSetStructuredText parseText (_file getOrDefault ["content", ""]);
					private _descriptionHeight = 0.095 max ((ctrlTextHeight _descriptionBody) + 0.02);
					private _descriptionPos = ctrlPosition _descriptionBody;
					_descriptionPos set [3, _descriptionHeight];
					_descriptionBody ctrlSetPosition _descriptionPos;
					_descriptionBody ctrlCommit 0;
					_descriptionGroup ctrlShow true;
					_descriptionFrame ctrlShow true;
					""
				};
				default {""};
			};
			private _content = if (_type isEqualTo "picture") then {
				""
			} else {
				format ["<br/><br/>%1", _file getOrDefault ["content", ""]]
			};
			[format [
				"<t size='1.25'>%1</t><br/><t color='#9fb6d8'>%2</t>%3%4%5",
				_file getOrDefault ["name", "No file selected"],
				_file getOrDefault ["path", ""],
				_content,
				_assetInfo,
				_mediaHint
			]] call _setBody;
		};
	};
	case "mail": {
		["select", _index, _isSelect] call FUNC(renderMail);
	};
	case "messages": {
		_title ctrlSetText "Messenger";
		["<t size='1.25'>Messenger</t><br/><br/>This function does not work yet."] call _setBody;
	};
	case "notes": {
		_title ctrlSetText "Notes";
		["<t size='1.25'>Notes</t><br/><br/>This function does not work yet."] call _setBody;
	};
	default {
		_title ctrlSetText "Desktop";
		private _desktopTitle = _activeUser getOrDefault ["desktopTitle", _data getOrDefault ["desktopTitle", "Welcome"]];
		private _desktopContent = _activeUser getOrDefault ["desktopContent", _data getOrDefault ["desktopContent", "Select an app on the left. Files, Mail, Messenger, and Notes are wired to the computer data model now.<br/><br/>The Start button controls power state."]];
		private _desktopAlign = toLowerANSI (_activeUser getOrDefault ["desktopAlign", _data getOrDefault ["desktopAlign", "left"]]);
		if !(_desktopAlign in ["left", "center", "right"]) then {
			_desktopAlign = "left";
		};
		_body ctrlSetStructuredText parseText "";
		_desktopBody ctrlSetStructuredText parseText format ["<t align='%1'><t size='1.35'>%2</t><br/><br/>%3</t>", _desktopAlign, _desktopTitle, _desktopContent];
		private _desktopHeight = 0.2 max ((ctrlTextHeight _desktopBody) + 0.03);
		private _desktopPos = ctrlPosition _desktopBody;
		_desktopPos set [3, _desktopHeight];
		_desktopBody ctrlSetPosition _desktopPos;
		_desktopBody ctrlCommit 0;
		_desktopGroup ctrlShow true;
	};
};
