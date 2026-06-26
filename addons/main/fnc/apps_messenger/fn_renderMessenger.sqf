#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Renders the MMC Messenger app.
 *
 * Arguments:
 * 0: Selection index or "select" <NUMBER or STRING>
 * 1: Selection came from list event <BOOL, default: false>
 *
 * Return Value:
 * None
 */

params [
	["_selection", -1],
	["_isSelect", false, [false]]
];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _title = _display displayCtrl IDC_MMC_APP_TITLE;
private _list = _display displayCtrl IDC_MMC_APP_LIST;
private _body = _display displayCtrl IDC_MMC_APP_BODY;
private _group = _display displayCtrl IDC_MMC_DESKTOP_CONTENT_GROUP;
private _history = _display displayCtrl IDC_MMC_DESKTOP_CONTENT_BODY;
private _isMobile = _display getVariable [QGVAR(isMobileDisplay), false];

_title ctrlSetText "Messenger";
_body ctrlSetStructuredText parseText "";
_group ctrlShow true;
_history ctrlShow true;
_history ctrlEnable false;

private _oldInput = _display getVariable [QGVAR(messengerInputControl), controlNull];
private _oldSelectedId = _display getVariable [QGVAR(messengerSelectedId), ""];
private _skipDraftSave = _display getVariable [QGVAR(messengerSkipDraftSave), false];
_display setVariable [QGVAR(messengerSkipDraftSave), false];
if (!_skipDraftSave && {!isNull _oldInput && {_oldSelectedId isNotEqualTo ""}}) then {
	private _oldDrafts = _display getVariable [QGVAR(messengerDrafts), createHashMap];
	if !(_oldDrafts isEqualType createHashMap) then {
		_oldDrafts = createHashMap;
	};
	_oldDrafts set [_oldSelectedId, ctrlText _oldInput];
	_display setVariable [QGVAR(messengerDrafts), _oldDrafts];
};

{
	private _ctrl = _display getVariable [_x, controlNull];
	if (!isNull _ctrl) then {
		ctrlDelete _ctrl;
	};
	_display setVariable [_x, controlNull];
} forEach [
	QGVAR(messengerInputBackgroundControl),
	QGVAR(messengerInputGroupControl),
	QGVAR(messengerInputControl),
	QGVAR(messengerSendControl),
	QGVAR(messengerSendHotspotControl),
	QGVAR(messengerSendFrameControl)
];
{
	if (!isNull _x) then {
		ctrlDelete _x;
	};
} forEach (_display getVariable [QGVAR(messengerDynamicControls), []]);
_display setVariable [QGVAR(messengerDynamicControls), []];
{
	if (_x getVariable [QGVAR(messengerDynamicControl), false]) then {
		ctrlDelete _x;
	};
} forEach (allControls _display);

private _collapseMobilePanes = {
	params ["_control"];
	private _display = ctrlParent _control;
	if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
		private _hadPaneOpen = (_display getVariable [QGVAR(mobileNavOpen), false]) || {_display getVariable [QGVAR(mobileCustomAppsOpen), false]};
		if (!_hadPaneOpen) exitWith {false};
		_display setVariable [QGVAR(mobileNavOpen), false];
		_display setVariable [QGVAR(mobileCustomAppsOpen), false];
		[_display] call MMC_fnc_applyMobileDisplayLayout;
	};
	false
};
_body ctrlRemoveAllEventHandlers "MouseButtonDown";
_body ctrlAddEventHandler ["MouseButtonDown", _collapseMobilePanes];
_group ctrlRemoveAllEventHandlers "MouseButtonDown";
_group ctrlAddEventHandler ["MouseButtonDown", _collapseMobilePanes];

if (!_isMobile) then {
	private _contentPos = [safeZoneX + 0.43, safeZoneY + 0.135, safeZoneW - 0.61, safeZoneH - 0.315];
	_body ctrlSetPosition _contentPos;
	_body ctrlCommit 0;
	(_display displayCtrl IDC_MMC_FRAME_APP_BODY) ctrlSetPosition _contentPos;
	(_display displayCtrl IDC_MMC_FRAME_APP_BODY) ctrlCommit 0;
};

private _contacts = [_computer] call FUNC(getMessengerDevices);
private _own = [_computer] call FUNC(getMessengerIdentity);
private _ownId = _own getOrDefault ["id", ""];
private _ownName = _own getOrDefault ["name", "Me"];
private _ownEmail = toLowerANSI (_own getOrDefault ["email", ""]);
private _ownUsername = toLowerANSI (_own getOrDefault ["username", ""]);

private _selectedId = _display getVariable [QGVAR(messengerSelectedId), ""];
if (_selection isEqualType "" && {_selection isEqualTo "home"}) then {
	_selectedId = "";
	_display setVariable [QGVAR(messengerSelectedId), ""];
};
if (_isSelect && {_selection isEqualType 0 && {_selection >= 0 && {_selection < count _contacts}}}) then {
	_selectedId = (_contacts select _selection) getOrDefault ["id", ""];
	_display setVariable [QGVAR(messengerSelectedId), _selectedId];
};
if (_selectedId isNotEqualTo "" && {_contacts findIf {(_x getOrDefault ["id", ""]) isEqualTo _selectedId} < 0}) then {
	_selectedId = "";
	_display setVariable [QGVAR(messengerSelectedId), _selectedId];
};

_display setVariable [QGVAR(messengerSyncing), true];
lbClear _list;
private _selectedIndex = -1;
{
	private _name = _x getOrDefault ["name", "Device"];
	private _row = _list lbAdd _name;
	_list lbSetData [_row, _x getOrDefault ["id", ""]];
	_list lbSetTooltip [_row, format ["Open chat with %1.", _name]];
	if ((_x getOrDefault ["id", ""]) isEqualTo _selectedId) then {
		_selectedIndex = _row;
	};
} forEach _contacts;
if (_selectedIndex >= 0) then {
	if ((lbCurSel _list) isNotEqualTo _selectedIndex) then {
		_list lbSetCurSel _selectedIndex;
	};
};
[{
	params ["_display"];
	if (!isNull _display) then {
		_display setVariable [QGVAR(messengerSyncing), false];
	};
}, [_display], 0] call CBA_fnc_waitAndExecute;

private _target = createHashMap;
private _targetIndex = _contacts findIf {(_x getOrDefault ["id", ""]) isEqualTo _selectedId};
if (_targetIndex >= 0) then {
	_target = _contacts select _targetIndex;
};
private _targetName = _target getOrDefault ["name", "No device selected"];
private _isHome = _selectedId isEqualTo "";

private _escape = {
	params [["_text", "", [""]]];
	_text = _text splitString "&" joinString "&amp;";
	_text = _text splitString "<" joinString "&lt;";
	_text = _text splitString ">" joinString "&gt;";
	_text = _text splitString (toString [13, 10]) joinString "<br/>";
	_text = _text splitString (toString [10]) joinString "<br/>";
	_text
};

private _messages = missionNamespace getVariable [QGVAR(messengerMessages), GVAR(messengerMessages)];
if !(_messages isEqualType []) then {
	_messages = [];
};

private _messageMatches = {
	params [
		["_message", createHashMap, [createHashMap]],
		["_contact", createHashMap, [createHashMap]]
	];
	private _contactId = _contact getOrDefault ["id", ""];
	private _contactEmail = toLowerANSI (_contact getOrDefault ["email", ""]);
	private _contactUsername = toLowerANSI (_contact getOrDefault ["username", ""]);
	private _from = _message getOrDefault ["from", ""];
	private _to = _message getOrDefault ["to", ""];
	private _fromEmail = toLowerANSI (_message getOrDefault ["fromEmail", ""]);
	private _toEmail = toLowerANSI (_message getOrDefault ["toEmail", ""]);
	private _fromUsername = toLowerANSI (_message getOrDefault ["fromUsername", ""]);
	private _toUsername = toLowerANSI (_message getOrDefault ["toUsername", ""]);
	private _sentById = _from isEqualTo _ownId && {_to isEqualTo _contactId};
	private _receivedById = _from isEqualTo _contactId && {_to isEqualTo _ownId};
	private _sentByEmail = _ownEmail isNotEqualTo "" && {_contactEmail isNotEqualTo "" && {_fromEmail isEqualTo _ownEmail && {_toEmail isEqualTo _contactEmail}}};
	private _receivedByEmail = _ownEmail isNotEqualTo "" && {_contactEmail isNotEqualTo "" && {_fromEmail isEqualTo _contactEmail && {_toEmail isEqualTo _ownEmail}}};
	private _sentByUsername = _ownUsername isNotEqualTo "" && {_contactUsername isNotEqualTo "" && {_fromUsername isEqualTo _ownUsername && {_toUsername isEqualTo _contactUsername}}};
	private _receivedByUsername = _ownUsername isNotEqualTo "" && {_contactUsername isNotEqualTo "" && {_fromUsername isEqualTo _contactUsername && {_toUsername isEqualTo _ownUsername}}};
	_sentById || {_receivedById || {_sentByEmail || {_receivedByEmail || {_sentByUsername || _receivedByUsername}}}}
};

private _messageReceivedFrom = {
	params [
		["_message", createHashMap, [createHashMap]],
		["_contact", createHashMap, [createHashMap]]
	];
	private _contactId = _contact getOrDefault ["id", ""];
	private _contactEmail = toLowerANSI (_contact getOrDefault ["email", ""]);
	private _contactUsername = toLowerANSI (_contact getOrDefault ["username", ""]);
	((_message getOrDefault ["from", ""]) isEqualTo _contactId)
	|| {_ownEmail isNotEqualTo "" && {_contactEmail isNotEqualTo "" && {toLowerANSI (_message getOrDefault ["fromEmail", ""]) isEqualTo _contactEmail && {toLowerANSI (_message getOrDefault ["toEmail", ""]) isEqualTo _ownEmail}}}}
	|| {_ownUsername isNotEqualTo "" && {_contactUsername isNotEqualTo "" && {toLowerANSI (_message getOrDefault ["fromUsername", ""]) isEqualTo _contactUsername && {toLowerANSI (_message getOrDefault ["toUsername", ""]) isEqualTo _ownUsername}}}}
};

private _messageReadByOwn = {
	params [["_message", createHashMap, [createHashMap]]];
	private _readBy = _message getOrDefault ["readBy", []];
	_readBy isEqualType [] && {_ownId in _readBy || {_ownEmail isNotEqualTo "" && {_ownEmail in _readBy}} || {_ownUsername isNotEqualTo "" && {_ownUsername in _readBy}}}
};

private _conversation = _messages select {
	_x isEqualType createHashMap
	&& {[_x, _target] call _messageMatches}
};
private _conversationSignature = str (_conversation apply {
	_x getOrDefault ["id", format [
		"%1:%2:%3:%4",
		_x getOrDefault ["from", ""],
		_x getOrDefault ["to", ""],
		_x getOrDefault ["date", ""],
		_x getOrDefault ["time", ""]
	]]
});
private _lastConversationSignature = _display getVariable [QGVAR(messengerConversationSignature), ""];
private _lastRenderedSelectedId = _display getVariable [QGVAR(messengerRenderedSelectedId), ""];
private _scrollToBottom = _display getVariable [QGVAR(messengerForceScrollBottom), false];
if (_conversationSignature isNotEqualTo _lastConversationSignature || {_selectedId isNotEqualTo _lastRenderedSelectedId}) then {
	_scrollToBottom = true;
};
_display setVariable [QGVAR(messengerConversationSignature), _conversationSignature];
_display setVariable [QGVAR(messengerRenderedSelectedId), _selectedId];
_display setVariable [QGVAR(messengerForceScrollBottom), false];

private _theme = [_display] call FUNC(getThemeConfig);
_title ctrlSetText (["Messenger", format ["Messenger - %1", _targetName]] select !_isHome);

if (!_isHome) then {
	private _changedRead = false;
	{
		if ([_x, _target] call _messageReceivedFrom && {!([_x] call _messageReadByOwn)}) then {
			private _readBy = _x getOrDefault ["readBy", []];
			if !(_readBy isEqualType []) then {
				_readBy = [];
			};
			{
				if (_x isNotEqualTo "") then {
					_readBy pushBackUnique _x;
				};
			} forEach [_ownId, _ownEmail, _ownUsername];
			_x set ["readBy", _readBy];
			_changedRead = true;
		};
	} forEach _conversation;
	if (_changedRead) then {
		missionNamespace setVariable [QGVAR(messengerMessages), _messages, false];
		GVAR(messengerMessages) = _messages;
	};
};

private _baseGroupPos = ctrlPosition _group;
private _gap = 0.008;
if (_isMobile) then {
	private _contentPos = ctrlPosition _body;
	_baseGroupPos = [
		(_contentPos select 0) + 0.008,
		(_contentPos select 1) + 0.008,
		(_contentPos select 2) - 0.016,
		(_contentPos select 3) - 0.016
	];
} else {
	private _contentPos = ctrlPosition _body;
	_baseGroupPos = [
		(_contentPos select 0) + 0.012,
		(_contentPos select 1) + 0.012,
		(_contentPos select 2) - 0.024,
		(_contentPos select 3) - 0.024
	];
};

if (_isHome) exitWith {
	_group ctrlSetPosition _baseGroupPos;
	_group ctrlCommit 0;
	private _historyWidth = (_baseGroupPos select 2) - 0.02;
	_history ctrlSetStructuredText parseText "";
	_history ctrlSetPosition [0, 0, _historyWidth max 0.1, 0.2];
	_history ctrlCommit 0;

	private _textColor = _theme getOrDefault ["text", [0.9, 0.92, 0.96, 1]];
	private _mutedText = _theme getOrDefault ["mutedText", [0.62, 0.72, 0.85, 1]];
	private _panel = _theme getOrDefault ["panel", [0.03, 0.035, 0.045, 0.96]];
	private _accent = _theme getOrDefault ["accent", [0.12, 0.32, 0.58, 0.94]];
	private _border = _theme getOrDefault ["border", [0, 0, 0, 0.85]];
	private _controls = [];
	private _y = 0.012;

	private _intro = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
	_intro setVariable [QGVAR(messengerDynamicControl), true];
	_intro ctrlSetTextColor _textColor;
	_intro ctrlSetBackgroundColor [0, 0, 0, 0];
	_intro ctrlSetPosition [0.012, _y, (_historyWidth - 0.024) max 0.1, 0.06];
	_intro ctrlSetStructuredText parseText format [
		"<t size='1.18'>Messages</t><br/><t size='0.88' color='#9fb6d8'>%1 visible devices</t>",
		count _contacts
	];
	_intro ctrlCommit 0;
	private _introH = 0.055 max ((ctrlTextHeight _intro) + 0.012);
	_intro ctrlSetPosition [0.012, _y, (_historyWidth - 0.024) max 0.1, _introH];
	_intro ctrlCommit 0;
	_controls pushBack _intro;
	_y = _y + _introH + 0.012;

	if (_contacts isEqualTo []) then {
		private _empty = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
		_empty setVariable [QGVAR(messengerDynamicControl), true];
		_empty ctrlSetTextColor _mutedText;
		_empty ctrlSetBackgroundColor [0, 0, 0, 0];
		_empty ctrlSetPosition [0.012, _y, (_historyWidth - 0.024) max 0.1, 0.06];
		_empty ctrlSetStructuredText parseText "<t size='1.0'>No device on your allowed side is currently registered.</t>";
		_empty ctrlCommit 0;
		_controls pushBack _empty;
		_y = _y + 0.075;
	} else {
		{
			private _contact = _x;
			private _contactIndex = _forEachIndex;
			private _contactMessages = _messages select {_x isEqualType createHashMap && {[_x, _contact] call _messageMatches}};
			private _latest = createHashMap;
			if (_contactMessages isNotEqualTo []) then {
				_latest = _contactMessages select -1;
			};
			private _unread = {
				[_x, _contact] call _messageReceivedFrom && {!([_x] call _messageReadByOwn)}
			} count _contactMessages;
			private _name = _contact getOrDefault ["name", "Device"];
			private _preview = [_latest getOrDefault ["body", "No messages yet."]] call _escape;
			private _stamp = if (count _latest > 0) then {
				format ["%1 %2", _latest getOrDefault ["date", ""], _latest getOrDefault ["time", ""]]
			} else {
				""
			};
			if (count _preview > 140) then {
				_preview = (_preview select [0, 137]) + "...";
			};

			private _cardH = 0.088;
			private _bg = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
			private _frame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc), _group];
			private _label = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
			{
				_x setVariable [QGVAR(messengerDynamicControl), true];
			} forEach [_bg, _frame, _label];
			private _cardColor = [_panel, _accent] select (_unread > 0);
			_bg ctrlSetBackgroundColor _cardColor;
			_bg ctrlSetPosition [0.012, _y, (_historyWidth - 0.024) max 0.1, _cardH];
			_bg ctrlCommit 0;
			_frame ctrlSetTextColor _border;
			_frame ctrlEnable false;
			_frame ctrlSetPosition [0.012, _y, (_historyWidth - 0.024) max 0.1, _cardH];
			_frame ctrlCommit 0;
			_label ctrlSetTextColor _textColor;
			_label ctrlSetBackgroundColor [0, 0, 0, 0];
			private _badgeW = [0, 0.052] select (_unread > 0);
			_label ctrlSetPosition [0.024, _y + 0.007, (_historyWidth - 0.056 - _badgeW) max 0.08, _cardH - 0.014];
			_label ctrlSetStructuredText parseText format [
				"<t size='1.02'>%1</t><br/><t size='0.82' color='%4'>%2</t><br/><t size='0.9'>%3</t>",
				[_name] call _escape,
				_stamp,
				_preview,
				["#9fb6d8", "#ffffff"] select (_unread > 0)
			];
			_label ctrlCommit 0;
			private _badge = controlNull;
			if (_unread > 0) then {
				_badge = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
				_badge setVariable [QGVAR(messengerDynamicControl), true];
				_badge ctrlEnable false;
				_badge ctrlSetTextColor [1, 1, 1, 1];
				_badge ctrlSetBackgroundColor [0, 0, 0, 0];
				_badge ctrlSetPosition [0.012 + ((_historyWidth - 0.024) max 0.1) - _badgeW - 0.012, _y + 0.024, _badgeW, 0.032];
				_badge ctrlSetStructuredText parseText format ["<t align='center' color='#ffffff' bgcolor='#2b73c8' size='0.95'>%1</t>", _unread];
				_badge ctrlCommit 0;
			};
			private _button = _display ctrlCreate [QGVAR(RscComputerHitButton), [_display] call FUNC(nextDynamicIdc), _group];
			_button setVariable [QGVAR(messengerDynamicControl), true];
			_button ctrlSetPosition [0.012, _y, (_historyWidth - 0.024) max 0.1, _cardH];
			private _targetId = _contact getOrDefault ["id", ""];
			private _openChat = {
				params ["_control"];
				private _display = ctrlParent _control;
				private _targetId = _control getVariable [QGVAR(messengerTargetId), ""];
				if (_targetId isNotEqualTo "") then {
					_display setVariable [QGVAR(messengerSelectedId), _targetId];
					_display setVariable [QGVAR(messengerKeepSelection), true];
					["messages"] call MMC_fnc_renderApp;
				} else {
					[_control getVariable [QGVAR(messengerTargetIndex), -1], true] call MMC_fnc_renderMessenger;
				};
			};
			{
				_x setVariable [QGVAR(messengerTargetId), _targetId];
				_x setVariable [QGVAR(messengerTargetIndex), _contactIndex];
				_x ctrlSetTooltip format ["Open chat with %1.", _name];
				_x ctrlAddEventHandler ["MouseButtonUp", {
					params ["_control", "_button"];
					if (_button isNotEqualTo 0) exitWith {false};
					private _display = ctrlParent _control;
					private _targetId = _control getVariable [QGVAR(messengerTargetId), ""];
					if (_targetId isNotEqualTo "") then {
						_display setVariable [QGVAR(messengerSelectedId), _targetId];
						_display setVariable [QGVAR(messengerKeepSelection), true];
						["messages"] call MMC_fnc_renderApp;
					} else {
						[_control getVariable [QGVAR(messengerTargetIndex), -1], true] call MMC_fnc_renderMessenger;
					};
					true
				}];
			} forEach [_bg, _label, _button];
			_button ctrlAddEventHandler ["ButtonClick", _openChat];
			_button ctrlCommit 0;
			_controls append ([_bg, _frame, _label] + ([_badge] select {!isNull _x}) + [_button]);
			_y = _y + _cardH + 0.01;
		} forEach _contacts;
	};

	_history ctrlSetPosition [0, 0, _historyWidth max 0.1, _y + 0.025];
	_history ctrlCommit 0;
	_display setVariable [QGVAR(messengerDynamicControls), _controls];

	if (_isMobile) then {
		_display setVariable [QGVAR(mobileRecreatePanesOnTop), true];
		[_display] call FUNC(applyMobileDisplayLayout);
	};
};

private _inputBg = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc)];
private _inputGroup = controlNull;
private _input = _display ctrlCreate [QGVAR(RscComputerEditMulti), [_display] call FUNC(nextDynamicIdc)];
private _sendFrame = controlNull;
private _send = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
private _sendHotspot = controlNull;
private _generation = (_display getVariable [QGVAR(messengerInputControlsGeneration), 0]) + 1;
_display setVariable [QGVAR(messengerInputControlsGeneration), _generation];
{
	if (!isNull _x) then {
		_x ctrlShow false;
		_x setVariable [QGVAR(messengerInputControlsGeneration), _generation];
		_x setVariable [QGVAR(messengerDynamicControl), true];
	};
} forEach [_inputBg, _inputGroup, _input, _send, _sendHotspot, _sendFrame];
private _inputH = 0.19;
private _historyGroupPos = [
	_baseGroupPos select 0,
	_baseGroupPos select 1,
	_baseGroupPos select 2,
	((_baseGroupPos select 3) - _inputH - _gap) max 0.08
];
_group ctrlSetPosition _historyGroupPos;
_group ctrlCommit 0;
private _historyWidth = (_historyGroupPos select 2) - 0.02;
_history ctrlSetStructuredText parseText "";
_history ctrlSetPosition [0, 0, _historyWidth max 0.1, 0.2];
_history ctrlCommit 0;

private _drafts = _display getVariable [QGVAR(messengerDrafts), createHashMap];
if !(_drafts isEqualType createHashMap) then {
	_drafts = createHashMap;
	_display setVariable [QGVAR(messengerDrafts), _drafts];
};
_input ctrlSetText (_drafts getOrDefault [_selectedId, ""]);
_input ctrlSetTooltip "Write a Messenger message. Shift+Enter adds a line break. Use arrow keys to move through longer drafts.";
_inputBg ctrlSetText "";
_inputBg ctrlEnable false;
_inputBg ctrlSetBackgroundColor (_theme getOrDefault ["panel", [0.03, 0.035, 0.045, 0.96]]);
_input ctrlSetBackgroundColor [0, 0, 0, 0];
_input ctrlSetTextColor (_theme getOrDefault ["text", [0.9, 0.92, 0.96, 1]]);
_input setVariable [QGVAR(messengerInputField), true];
_input setVariable [QGVAR(messengerInputSelectedId), _selectedId];
_input setVariable [QGVAR(messengerSendControl), _send];
_input ctrlAddEventHandler ["MouseButtonDown", _collapseMobilePanes];
_input ctrlAddEventHandler ["KeyDown", {
	params ["_control", "_key", "_shift"];
	if (_key in [28, 156] && {!_shift}) exitWith {
		private _display = ctrlParent _control;
		[_display, _control] call MMC_fnc_sendMessengerFromInput;
		true
	};
	false
}];
_input ctrlAddEventHandler ["KeyUp", {
	params ["_control"];
	private _display = ctrlParent _control;
	private _selectedId = _display getVariable [QGVAR(messengerSelectedId), ""];
	if (_selectedId isEqualTo "") exitWith {};
	private _drafts = _display getVariable [QGVAR(messengerDrafts), createHashMap];
	if !(_drafts isEqualType createHashMap) then {
		_drafts = createHashMap;
	};
	_drafts set [_selectedId, ctrlText _control];
	_display setVariable [QGVAR(messengerDrafts), _drafts];
}];
_send ctrlSetText "Send";
_send ctrlSetTooltip "Send the message to the selected device.";
_send ctrlSetBackgroundColor (_theme getOrDefault ["button", [0.028, 0.032, 0.042, 0.98]]);
_send ctrlSetTextColor (_theme getOrDefault ["buttonText", [0.92, 0.94, 0.97, 1]]);
if (!isNull _sendFrame) then {
	_sendFrame ctrlEnable false;
	_sendFrame ctrlSetTextColor (_theme getOrDefault ["border", [0, 0, 0, 0.85]]);
};
_send setVariable [QGVAR(messengerInput), _input];
_send ctrlSetActiveColor (_theme getOrDefault ["buttonHoverText", [1, 1, 1, 1]]);
_send ctrlAddEventHandler ["ButtonClick", {
	params ["_control"];
	private _display = ctrlParent _control;
	private _input = _control getVariable [QGVAR(messengerInput), controlNull];
	if (isNull _input) then {
		_input = _display getVariable [QGVAR(messengerInputControl), controlNull];
	};
	if (isNull _input) exitWith {};
	[_display, _input] call MMC_fnc_sendMessengerFromInput;
}];
_send ctrlAddEventHandler ["MouseButtonUp", {
	params ["_control", "_button"];
	if (_button isNotEqualTo 0) exitWith {false};
	private _display = ctrlParent _control;
	private _input = _control getVariable [QGVAR(messengerInput), controlNull];
	if (isNull _input) then {
		_input = _display getVariable [QGVAR(messengerInputControl), controlNull];
	};
	if (isNull _input) exitWith {false};
	[_display, _input] call MMC_fnc_sendMessengerFromInput;
	true
}];

private _buttonW = 0.08;
private _inputY = (_baseGroupPos select 1) + (_baseGroupPos select 3) - _inputH;
_inputBg ctrlSetPosition [_baseGroupPos select 0, _inputY, (_baseGroupPos select 2) - _buttonW - _gap, _inputH];
_input ctrlSetPosition [(_baseGroupPos select 0) + 0.006, _inputY + 0.006, ((_baseGroupPos select 2) - _buttonW - _gap - 0.018) max 0.02, _inputH - 0.012];
_send ctrlSetPosition [(_baseGroupPos select 0) + (_baseGroupPos select 2) - _buttonW, _inputY, _buttonW, _inputH];
if (!isNull _sendHotspot) then {
	_sendHotspot ctrlSetPosition [(_baseGroupPos select 0) + (_baseGroupPos select 2) - _buttonW, _inputY, _buttonW, _inputH];
};
if (!isNull _sendFrame) then {
	_sendFrame ctrlSetPosition [(_baseGroupPos select 0) + (_baseGroupPos select 2) - _buttonW, _inputY, _buttonW, _inputH];
};
{
	if (!isNull _x) then {
		_x ctrlCommit 0;
	};
} forEach [_inputBg, _inputGroup, _input, _send, _sendHotspot, _sendFrame];
_send ctrlEnable (_targetIndex >= 0);
_send ctrlShow (_targetIndex >= 0);
if (!isNull _sendHotspot) then {
	_sendHotspot ctrlEnable (_targetIndex >= 0);
	_sendHotspot ctrlShow (_targetIndex >= 0);
};
if (!isNull _sendFrame) then {
	_sendFrame ctrlShow (_targetIndex >= 0);
};
_inputBg ctrlShow (_targetIndex >= 0);
_input ctrlShow (_targetIndex >= 0);

private _textColor = _theme getOrDefault ["text", [0.9, 0.92, 0.96, 1]];
private _mutedText = _theme getOrDefault ["mutedText", [0.62, 0.72, 0.85, 1]];
private _sentColor = _theme getOrDefault ["accent", [0.12, 0.32, 0.58, 0.92]];
private _receivedColor = _theme getOrDefault ["panelStrong", [0.08, 0.095, 0.12, 0.94]];
private _bubbleControls = [];
private _bubbleY = 0.014;
private _bubbleGap = 0.013;
private _bubbleW = ((_historyWidth * 0.52) min (_historyWidth - 0.024)) max 0.12;
private _bubblePadding = 0.008;

private _addHistoryNotice = {
	params ["_text"];
	private _notice = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
	_notice setVariable [QGVAR(messengerDynamicControl), true];
	_notice ctrlSetPosition [0.012, _bubbleY, (_historyWidth - 0.024) max 0.1, 0.06];
	_notice ctrlSetTextColor _mutedText;
	_notice ctrlSetBackgroundColor [0, 0, 0, 0];
	_notice ctrlSetStructuredText parseText _text;
	_notice ctrlCommit 0;
	private _h = 0.045 max ((ctrlTextHeight _notice) + 0.014);
	_notice ctrlSetPosition [0.012, _bubbleY, (_historyWidth - 0.024) max 0.1, _h];
	_notice ctrlCommit 0;
	_bubbleControls pushBack _notice;
	_bubbleY = _bubbleY + _h + _bubbleGap;
};

private _back = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc), _group];
private _backFrame = _display ctrlCreate [QGVAR(RscComputerFrame), [_display] call FUNC(nextDynamicIdc), _group];
{
	_x setVariable [QGVAR(messengerDynamicControl), true];
} forEach [_back, _backFrame];
_back ctrlSetText "<";
_back ctrlSetTooltip "Return to Messenger home.";
_back ctrlSetBackgroundColor (_theme getOrDefault ["button", [0.028, 0.032, 0.042, 0.98]]);
_back ctrlSetTextColor (_theme getOrDefault ["buttonText", [0.92, 0.94, 0.97, 1]]);
_back ctrlSetActiveColor (_theme getOrDefault ["buttonHoverText", [1, 1, 1, 1]]);
_back ctrlSetPosition [0.012, _bubbleY, 0.046, 0.04];
private _returnHome = {
	params ["_control"];
	private _display = ctrlParent _control;
	_display setVariable [QGVAR(messengerSelectedId), ""];
	["messages"] call MMC_fnc_renderApp;
};
_back ctrlAddEventHandler ["ButtonClick", _returnHome];
_back ctrlAddEventHandler ["MouseButtonUp", {
	params ["_control", "_button"];
	if (_button isNotEqualTo 0) exitWith {false};
	private _display = ctrlParent _control;
	_display setVariable [QGVAR(messengerSelectedId), ""];
	["messages"] call MMC_fnc_renderApp;
	true
}];
_back ctrlCommit 0;
_backFrame ctrlSetTextColor (_theme getOrDefault ["border", [0, 0, 0, 0.85]]);
_backFrame ctrlEnable false;
_backFrame ctrlSetPosition [0.012, _bubbleY, 0.046, 0.04];
_backFrame ctrlCommit 0;
_bubbleControls append [_back, _backFrame];

private _heading = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
_heading setVariable [QGVAR(messengerDynamicControl), true];
_heading ctrlSetPosition [0.066, _bubbleY, (_historyWidth - 0.078) max 0.1, 0.05];
_heading ctrlSetTextColor _textColor;
_heading ctrlSetBackgroundColor [0, 0, 0, 0];
_heading ctrlSetStructuredText parseText format ["<t size='1.2'>%1</t>", [_targetName] call _escape];
_heading ctrlCommit 0;
_bubbleControls pushBack _heading;
_bubbleY = _bubbleY + (0.045 max ((ctrlTextHeight _heading) + 0.012)) + _bubbleGap;

if (_contacts isEqualTo []) then {
	["<t color='#9fb6d8'>No device on your allowed side is currently registered.</t>"] call _addHistoryNotice;
} else {
	if (_conversation isEqualTo []) then {
		["<t color='#9fb6d8'>No messages yet.</t>"] call _addHistoryNotice;
	} else {
		{
			private _sent = (_x getOrDefault ["from", ""]) isEqualTo _ownId;
			if (!_sent && {_ownEmail isNotEqualTo ""}) then {
				_sent = (toLowerANSI (_x getOrDefault ["fromEmail", ""])) isEqualTo _ownEmail;
			};
			if (!_sent && {_ownUsername isNotEqualTo ""}) then {
				_sent = (toLowerANSI (_x getOrDefault ["fromUsername", ""])) isEqualTo _ownUsername;
			};
			private _name = [[_x getOrDefault ["fromName", "Unknown"]] call _escape, [_ownName] call _escape] select _sent;
			private _text = [_x getOrDefault ["body", ""]] call _escape;
			private _stamp = format ["%1 %2", _x getOrDefault ["date", ""], _x getOrDefault ["time", ""]];
			private _bubbleX = if (_sent) then {0.012} else {(_historyWidth - _bubbleW - 0.012) max 0.012};
			private _bgColor = [_receivedColor, _sentColor] select _sent;

			private _bg = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc), _group];
			private _textCtrl = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc), _group];
			_bg setVariable [QGVAR(messengerDynamicControl), true];
			_textCtrl setVariable [QGVAR(messengerDynamicControl), true];
			_bg ctrlSetText "";
			_bg ctrlSetBackgroundColor _bgColor;
			_bg ctrlSetPosition [_bubbleX, _bubbleY, _bubbleW, 0.06];
			_bg ctrlCommit 0;

			_textCtrl ctrlSetTextColor _textColor;
			_textCtrl ctrlSetBackgroundColor [0, 0, 0, 0];
			_textCtrl ctrlSetPosition [_bubbleX + _bubblePadding, _bubbleY + 0.006, (_bubbleW - (_bubblePadding * 2)) max 0.04, 0.05];
			_textCtrl ctrlSetStructuredText parseText format [
				"<t size='0.82' color='#9fb6d8'>%1 - %2</t><br/><t size='1.0'>%3</t>",
				_name,
				_stamp,
				_text
			];
			_textCtrl ctrlCommit 0;

			private _bubbleH = 0.052 max ((ctrlTextHeight _textCtrl) + 0.016);
			_bg ctrlSetPosition [_bubbleX, _bubbleY, _bubbleW, _bubbleH];
			_textCtrl ctrlSetPosition [_bubbleX + _bubblePadding, _bubbleY + 0.006, (_bubbleW - (_bubblePadding * 2)) max 0.04, _bubbleH - 0.012];
			_bg ctrlCommit 0;
			_textCtrl ctrlCommit 0;

			_bubbleControls append [_bg, _textCtrl];
			_bubbleY = _bubbleY + _bubbleH + _bubbleGap;
		} forEach _conversation;
	};
};

_history ctrlSetPosition [0, 0, _historyWidth max 0.1, _bubbleY + 0.02];
_history ctrlCommit 0;

_display setVariable [QGVAR(messengerInputBackgroundControl), _inputBg];
_display setVariable [QGVAR(messengerInputGroupControl), _inputGroup];
_display setVariable [QGVAR(messengerInputControl), _input];
_display setVariable [QGVAR(messengerSendControl), _send];
_display setVariable [QGVAR(messengerSendHotspotControl), _sendHotspot];
_display setVariable [QGVAR(messengerSendFrameControl), _sendFrame];
_display setVariable [QGVAR(messengerDynamicControls), _bubbleControls + [_input, _inputBg, _send, _sendHotspot, _sendFrame]];

if (_isMobile) then {
	_display setVariable [QGVAR(mobileRecreatePanesOnTop), true];
	[_display] call FUNC(applyMobileDisplayLayout);
};

if (_scrollToBottom) then {
	[{
		params ["_display"];
		if (isNull _display) exitWith {};
		private _group = _display displayCtrl IDC_MMC_DESKTOP_CONTENT_GROUP;
		if (!isNull _group) then {
			_group ctrlSetScrollValues [1, 0];
		};
	}, [_display], 0] call CBA_fnc_waitAndExecute;
	[{
		params ["_display"];
		if (isNull _display) exitWith {};
		private _group = _display displayCtrl IDC_MMC_DESKTOP_CONTENT_GROUP;
		if (!isNull _group) then {
			_group ctrlSetScrollValues [1, 0];
		};
	}, [_display], 0.05] call CBA_fnc_waitAndExecute;
};
