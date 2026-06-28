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
private _data = if (isNull _computer) then {
	_display getVariable [QGVAR(data), createHashMap]
} else {
	_computer getVariable [QGVAR(data), _display getVariable [QGVAR(data), createHashMap]]
};
_display setVariable [QGVAR(data), _data];
private _applyMobileNow = {
	if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
		[_display] call FUNC(applyMobileDisplayLayout);
	};
};
if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
	private _mobilePaneSelection = _display getVariable [QGVAR(mobilePaneSelection), ""];
	_display setVariable [QGVAR(mobilePaneSelection), ""];
	_display setVariable [QGVAR(startMenuOpen), false];
	if (_mobilePaneSelection isEqualTo "nav") then {
		_display setVariable [QGVAR(mobileNavOpen), true];
		_display setVariable [QGVAR(mobileCustomAppsOpen), false];
		_display setVariable [QGVAR(mobileRecreatePanesOnTop), true];
	} else {
		if (_mobilePaneSelection isEqualTo "customApps") then {
			_display setVariable [QGVAR(mobileNavOpen), false];
			_display setVariable [QGVAR(mobileCustomAppsOpen), true];
			_display setVariable [QGVAR(mobileRecreatePanesOnTop), true];
		} else {
			_display setVariable [QGVAR(mobileNavOpen), false];
			_display setVariable [QGVAR(mobileCustomAppsOpen), false];
		};
	};
};
private _poweredOn = _computer getVariable [QGVAR(poweredOn), true];
private _activeUser = [_computer] call FUNC(getActiveUser);
private _loginRequired = _data getOrDefault ["loginRequired", true];

private _title = _display displayCtrl IDC_MMC_APP_TITLE;
private _list = _display displayCtrl IDC_MMC_APP_LIST;
private _body = _display displayCtrl IDC_MMC_APP_BODY;
_body ctrlEnable false;
_body ctrlShow true;
_body ctrlSetPosition [safeZoneX + 0.43, safeZoneY + 0.135, safeZoneW - 0.61, safeZoneH - 0.315];
_body ctrlCommit 0;
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

{
	(_display displayCtrl _x) ctrlShow false;
} forEach _mediaControls;
{
	(_display displayCtrl _x) ctrlShow false;
} forEach _mailControls;
_desktopGroup ctrlShow false;
_desktopBody ctrlEnable true;
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
	call _applyMobileNow;
};

[_display, false] call FUNC(setSystemOverlay);

if (count _activeUser == 0) exitWith {
	if (_loginRequired) then {
		[_display] call FUNC(showLogin);
	} else {
		[_display] call FUNC(showNoUser);
	};
	call _applyMobileNow;
};

private _isSelect = _app isEqualTo "select";
if (_app isEqualTo "select") then {
	_app = _display getVariable [QGVAR(currentApp), "desktop"];
	if (_app isEqualTo "messages" && {_display getVariable [QGVAR(messengerSyncing), false]}) exitWith {};
} else {
	_display setVariable [QGVAR(currentApp), _app];
	if (_app isEqualTo "files") then {
		_display setVariable [QGVAR(filesFolder), ""];
	};
	if (_app isEqualTo "mail") then {
		_display setVariable [QGVAR(mailFolder), "inbox"];
		_display setVariable [QGVAR(mailMode), "table"];
		_display setVariable [QGVAR(mobileMailTablePage), 0];
	};
	if (_app isEqualTo "messages") then {
		if (_display getVariable [QGVAR(messengerKeepSelection), false]) then {
			_display setVariable [QGVAR(messengerKeepSelection), false];
		} else {
			_display setVariable [QGVAR(messengerSelectedId), ""];
		};
	};
};

private _standardIds = ["files", "mail", "messages", "notes"];
if (_app in _standardIds && {!([_computer, _app, _activeUser] call FUNC(isStandardAppEnabled))}) then {
	_app = "desktop";
	_display setVariable [QGVAR(currentApp), "desktop"];
	_event = [];
};

private _index = if (_event isEqualTo []) then {lbCurSel _list} else {_event select 1};
lbClear _list;

private _setBody = {
	params ["_text"];
	_body ctrlSetStructuredText parseText _text;
};

private _noContent = "<t size='1.25'>No Content available</t>";

[_display] call FUNC(refreshStandardApps);
[_display] call FUNC(refreshAppButtons);
[_display, false, true] call FUNC(clearCustomControls);

if ((_app select [0, 7]) isEqualTo "custom:") exitWith {
	private _result = [_app select [7]] call FUNC(renderCustomApp);
	call _applyMobileNow;
	_result
};

switch (_app) do {
	case "files": {
		_title ctrlSetText "Files";
		_display setVariable [QGVAR(filesAudioSelected), false];
		private _files = (_data getOrDefault ["files", []]) + (_activeUser getOrDefault ["files", []]);
		private _statusText = _display getVariable [QGVAR(mediaStatusText), "Selected: No Audio File Selected"];
		(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText _statusText;
		{
			(_display displayCtrl _x) ctrlShow true;
			(_display displayCtrl _x) ctrlSetFade 0;
			(_display displayCtrl _x) ctrlCommit 0;
		} forEach _mediaControls;

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
				_display setVariable [QGVAR(selectedFileIndex), -1];
			};
		};

		private _rows = [];
		private _folders = [
			["Text Files", "text"],
			["Audio Files", "audio"],
			["Pictures", "picture"]
		];
		{
			_x params ["_label", "_type"];
			private _row = _list lbAdd _label;
			_list lbSetTooltip [_row, format ["Open %1.", _label]];
			_rows pushBack createHashMapFromArray [["action", "folder"], ["type", _type]];
		} forEach _folders;
		_display setVariable [QGVAR(fileListRows), _rows];

		if (_folder isEqualTo "") exitWith {
			private _countText = count (_files select {(_x getOrDefault ["type", "file"]) isEqualTo "text"});
			private _countAudio = count (_files select {(_x getOrDefault ["type", "file"]) isEqualTo "audio"});
			private _countPictures = count (_files select {(_x getOrDefault ["type", "file"]) isEqualTo "picture"});
			[format [
				"<t size='1.25'>Files</t><br/><br/>Select a category in the navigation pane.<br/><br/><t color='#9fb6d8'>Text Files: %1<br/>Audio Files: %2<br/>Pictures: %3</t>",
				_countText,
				_countAudio,
				_countPictures
			]] call _setBody;
		};

		private _folderLabel = (_folders select {(_x select 1) isEqualTo _folder}) param [0, ["Files", _folder]] select 0;
		private _folderFiles = _files select {(_x getOrDefault ["type", "file"]) isEqualTo _folder};
		private _selectedIndex = _display getVariable [QGVAR(selectedFileIndex), -1];
		if (_selectedIndex >= count _folderFiles) then {
			_selectedIndex = -1;
			_display setVariable [QGVAR(selectedFileIndex), -1];
		};
		private _selectedFile = _folderFiles param [_selectedIndex, createHashMap];
		private _selectedType = _selectedFile getOrDefault ["type", "file"];
		private _audioSelected = _selectedIndex >= 0 && {_selectedType isEqualTo "audio"};
		_display setVariable [QGVAR(filesAudioSelected), _audioSelected];
		if (_audioSelected) then {
			_display setVariable [QGVAR(selectedMediaFile), _selectedFile];
			_statusText = format ["Selected: %1", [_selectedFile] call FUNC(getFileDisplayName)];
			(_display displayCtrl IDC_MMC_MEDIA_STATUS) ctrlSetText _statusText;
			_display setVariable [QGVAR(mediaStatusText), _statusText];
		};

		_desktopGroup ctrlShow false;
		_desktopBody ctrlShow false;
		_body ctrlSetStructuredText parseText "";
		_body ctrlShow true;
		if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
			call _applyMobileNow;
		};
		private _groupPos = ctrlPosition _body;
		_groupPos set [3, ((_groupPos select 3) - 0.09) max 0.08];
		private _group = _display ctrlCreate [QGVAR(RscComputerAppGroup), [_display] call FUNC(nextDynamicIdc)];
		_group ctrlSetPosition _groupPos;
		_group ctrlSetText "";
		_group ctrlCommit 0;
		private _controls = [_group];
		private _contentW = (_groupPos select 2) max 0.1;
		private _y = 0.012;

		private _heading = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
		_heading ctrlSetPosition [0.012, _y, _contentW - 0.024, 0.042];
		_heading ctrlSetStructuredText parseText format ["<t size='1.22'>%1</t>", _folderLabel];
		_heading ctrlCommit 0;
		_controls pushBack _heading;

		private _themeConfig = [_display] call FUNC(getThemeConfig);
		private _buttonColor = _themeConfig getOrDefault ["button", [0.028, 0.032, 0.042, 0.98]];
		private _buttonTextColor = _themeConfig getOrDefault ["buttonText", [0.92, 0.94, 0.97, 1]];
		private _backPos = [0.012, _y + 0.05, 0.105, 0.036];
		private _backLabel = _display ctrlCreate [QGVAR(RscComputerTextButton), [_display] call FUNC(nextDynamicIdc), _group];
		_backLabel ctrlSetPosition _backPos;
		_backLabel ctrlSetText "Back";
		_backLabel ctrlSetBackgroundColor _buttonColor;
		_backLabel ctrlSetTextColor _buttonTextColor;
		private _backHit = _display ctrlCreate [QGVAR(RscComputerInvisibleButton), [_display] call FUNC(nextDynamicIdc), _group];
		_backHit ctrlSetPosition _backPos;
		if (_selectedIndex < 0 || {_folder isEqualTo "audio"}) then {
			_backLabel ctrlSetTooltip "Return to file types.";
			_backHit ctrlSetTooltip "Return to file types.";
			_backHit ctrlSetEventHandler ["ButtonClick", "[-2] call MMC_fnc_fileSelectButton"];
		} else {
			_backLabel ctrlSetTooltip "Return to this file category.";
			_backHit ctrlSetTooltip "Return to this file category.";
			_backHit ctrlSetEventHandler ["ButtonClick", "[-1] call MMC_fnc_fileSelectButton"];
		};
		_backLabel ctrlCommit 0;
		_backHit ctrlCommit 0;
		_controls pushBack _backLabel;
		_controls pushBack _backHit;
		_y = _y + 0.098;

		if (_folderFiles isEqualTo []) exitWith {
			private _empty = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
			_empty ctrlSetPosition [0.012, _y, _contentW - 0.024, 0.06];
			_empty ctrlSetStructuredText parseText "<t size='1.1'>No files in this category.</t>";
			_empty ctrlCommit 0;
			_controls pushBack _empty;
			_display setVariable [QGVAR(customActionControls), _controls];
			call _applyMobileNow;
		};

		if (_selectedIndex < 0 || {_folder isEqualTo "audio"}) then {
			private _buttonW = (_contentW - 0.036) max 0.08;
			{
				private _buttonPos = [0.012, _y, _buttonW, 0.038];
				private _label = _display ctrlCreate [QGVAR(RscComputerTextButton), [_display] call FUNC(nextDynamicIdc), _group];
				_label ctrlSetPosition _buttonPos;
				private _fileLabel = [_x] call FUNC(getFileDisplayName);
				_label ctrlSetText _fileLabel;
				_label ctrlSetBackgroundColor _buttonColor;
				_label ctrlSetTextColor _buttonTextColor;
				_label ctrlSetTooltip _fileLabel;
				_label ctrlCommit 0;
				_controls pushBack _label;

				private _hit = _display ctrlCreate [QGVAR(RscComputerInvisibleButton), [_display] call FUNC(nextDynamicIdc), _group];
				_hit ctrlSetPosition _buttonPos;
				_hit ctrlSetTooltip _fileLabel;
				_hit ctrlSetEventHandler ["ButtonClick", format ["[%1] call MMC_fnc_fileSelectButton", _forEachIndex]];
				_hit ctrlCommit 0;
				_controls pushBack _hit;
				_y = _y + 0.044;
			} forEach _folderFiles;
			if (_folder isEqualTo "audio") then {
				private _hint = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
				_hint ctrlSetPosition [0.012, _y + 0.01, _contentW - 0.024, 0.055];
				_hint ctrlSetStructuredText parseText "<t color='#9fb6d8'>Select a file and use the media controls below.</t>";
				_hint ctrlCommit 0;
				_controls pushBack _hint;
				_y = _y + 0.074;
			};
		} else {
			private _file = _selectedFile;
			private _type = _selectedType;

			private _header = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
			_header ctrlSetPosition [0.012, _y + 0.012, _contentW - 0.024, 0.052];
			_header ctrlSetStructuredText parseText format [
				"<t size='1.16'>%1</t>",
				[_file] call FUNC(getFileDisplayName)
			];
			_header ctrlCommit 0;
			_controls pushBack _header;
			_y = _y + 0.07;

			if (_type isEqualTo "text") then {
				private _text = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
				_text ctrlSetPosition [0.012, _y, _contentW - 0.024, 0.1];
				_text ctrlSetStructuredText parseText ([_file getOrDefault ["content", ""]] call FUNC(normalizeStructuredText));
				private _textH = 0.1 max ((ctrlTextHeight _text) + 0.02);
				_text ctrlSetPosition [0.012, _y, _contentW - 0.024, _textH];
				_text ctrlCommit 0;
				_controls pushBack _text;
				_y = _y + _textH + 0.02;
			} else {
				if (_type isEqualTo "picture") then {
					private _image = _display ctrlCreate ["RscPictureKeepAspect", [_display] call FUNC(nextDynamicIdc), _group];
					private _imageH = 0.22 min ((_contentW - 0.024) * 0.56);
					_image ctrlSetPosition [0.012, _y, _contentW - 0.024, _imageH];
					_image ctrlSetText (_file getOrDefault ["texture", ""]);
					_image ctrlCommit 0;
					_controls pushBack _image;
					_y = _y + _imageH + 0.016;

					private _description = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
					_description ctrlSetPosition [0.012, _y, _contentW - 0.024, 0.08];
					_description ctrlSetStructuredText parseText ([_file getOrDefault ["content", ""]] call FUNC(normalizeStructuredText));
					private _descriptionH = 0.08 max ((ctrlTextHeight _description) + 0.02);
					_description ctrlSetPosition [0.012, _y, _contentW - 0.024, _descriptionH];
					_description ctrlCommit 0;
					_controls pushBack _description;
					_y = _y + _descriptionH + 0.02;
				} else {
					private _hint = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
					_hint ctrlSetPosition [0.012, _y, _contentW - 0.024, 0.055];
					_hint ctrlSetStructuredText parseText "<t color='#9fb6d8'>Use the media controls below to play this file.</t>";
					_hint ctrlCommit 0;
					_controls pushBack _hint;
					_y = _y + 0.072;
				};
			};
		};

		private _scrollMarker = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
		_scrollMarker ctrlSetPosition [0, _y max 0.001, 0.001, 0.001];
		_scrollMarker ctrlSetText "";
		_scrollMarker ctrlSetBackgroundColor [0, 0, 0, 0];
		_scrollMarker ctrlCommit 0;
		_controls pushBack _scrollMarker;
		_display setVariable [QGVAR(customActionControls), _controls];
	};
	case "mail": {
		["select", _index, _isSelect] call FUNC(renderMail);
	};
	case "messages": {
		[_index, _isSelect] call FUNC(renderMessenger);
	};
	case "notes": {
		["select", _index, _isSelect] call FUNC(renderNotes);
	};
	default {
		_title ctrlSetText (["Desktop", "Home Screen"] select (_display getVariable [QGVAR(isMobileDisplay), false]));
		_desktopGroup ctrlShow true;
		_body ctrlSetStructuredText parseText "";

		private _desktopScript = _activeUser getOrDefault ["desktopScript", _data getOrDefault ["desktopScript", ""]];
		if (_desktopScript isNotEqualTo "") then {
			_desktopBody ctrlSetStructuredText parseText "";
			_desktopBody ctrlShow false;

			private _desktopPos = ctrlPosition _desktopGroup;
			private _group = _display ctrlCreate [QGVAR(RscComputerAppGroup), [_display] call FUNC(nextDynamicIdc), _desktopGroup];
			_group ctrlSetPosition [0, 0, (_desktopPos select 2), (_desktopPos select 3)];
			_group ctrlSetText "";
			_group ctrlCommit 0;
			_display setVariable [QGVAR(customActionControls), [_group]];
			_display setVariable [QGVAR(appControlMap), createHashMap];

			private _app = createHashMapFromArray [
				["id", "desktop"],
				["label", ["Desktop", "Home Screen"] select (_display getVariable [QGVAR(isMobileDisplay), false])],
				["refreshAfterAction", false]
			];

			uiNamespace setVariable [QGVAR(appBuilderDisplay), _display];
			uiNamespace setVariable [QGVAR(appBuilderComputer), _computer];
			uiNamespace setVariable [QGVAR(appBuilderUser), _activeUser];
			uiNamespace setVariable [QGVAR(appBuilderApp), _app];
			uiNamespace setVariable [QGVAR(appBuilderGroup), _group];
			uiNamespace setVariable [QGVAR(appBuilderY), 0.015];

			private _scriptCode = compile preprocessFileLineNumbers _desktopScript;
			private _result = [_computer, _activeUser, _app, _display] call _scriptCode;
			if (!isNil "_result") then {
				if (_result isEqualType "") then {
					if (_result isNotEqualTo "") then {
						[_result] call FUNC(addAppStructuredText);
					};
				} else {
					if (_result isEqualType []) then {
						[_result] call FUNC(runAppBuilderContent);
					};
				};
			};

			private _contentH = (uiNamespace getVariable [QGVAR(appBuilderY), 0.015]) + 0.025;
			private _scrollMarker = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
			_scrollMarker ctrlSetPosition [0, _contentH max 0.001, 0.001, 0.001];
			_scrollMarker ctrlSetText "";
			_scrollMarker ctrlSetBackgroundColor [0, 0, 0, 0];
			_scrollMarker ctrlCommit 0;
			private _controls = _display getVariable [QGVAR(customActionControls), []];
			_controls pushBack _scrollMarker;
			_display setVariable [QGVAR(customActionControls), _controls];

			uiNamespace setVariable [QGVAR(appBuilderDisplay), displayNull];
			uiNamespace setVariable [QGVAR(appBuilderComputer), objNull];
			uiNamespace setVariable [QGVAR(appBuilderUser), createHashMap];
			uiNamespace setVariable [QGVAR(appBuilderApp), createHashMap];
			uiNamespace setVariable [QGVAR(appBuilderGroup), controlNull];
			uiNamespace setVariable [QGVAR(appBuilderY), 0];
		} else {
			_desktopBody ctrlShow true;
			private _desktopTitle = _activeUser getOrDefault ["desktopTitle", _data getOrDefault ["desktopTitle", "Welcome"]];
			private _desktopContent = _activeUser getOrDefault ["desktopContent", _data getOrDefault ["desktopContent", "Select an app on the left. Files, Mail, Messenger, and Notes are wired to the computer data model now.<br/><br/>The Start button controls power state."]];
			_desktopContent = [_desktopContent] call FUNC(normalizeStructuredText);
			private _desktopAlign = toLowerANSI (_activeUser getOrDefault ["desktopAlign", _data getOrDefault ["desktopAlign", "left"]]);
			if !(_desktopAlign in ["left", "center", "right"]) then {
				_desktopAlign = "left";
			};
			_desktopBody ctrlSetStructuredText parseText format ["<t align='%1'><t size='1.35'>%2</t><br/><br/>%3</t>", _desktopAlign, _desktopTitle, _desktopContent];
			private _desktopHeight = 0.2 max ((ctrlTextHeight _desktopBody) + 0.03);
			private _desktopPos = ctrlPosition _desktopBody;
			_desktopPos set [3, _desktopHeight];
			_desktopBody ctrlSetPosition _desktopPos;
			_desktopBody ctrlCommit 0;
		};
	};
};

if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
	call _applyMobileNow;
} else {
	ctrlSetFocus _list;
};
