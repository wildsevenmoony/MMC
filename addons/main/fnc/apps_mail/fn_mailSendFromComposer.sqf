#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Validates and sends the currently composed email.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

private _computer = _display getVariable [QGVAR(computer), objNull];
private _activeUser = [_computer] call FUNC(getActiveUser);
private _from = _activeUser getOrDefault ["email", ""];
private _fromCombo = _display displayCtrl IDC_MMC_MAIL_FROM;
if (!isNull _fromCombo && {ctrlShown _fromCombo}) then {
	private _selected = lbCurSel _fromCombo;
	if (_selected >= 0) then {
		private _selectedFrom = [_fromCombo lbData _selected] call CBA_fnc_trim;
		if (_selectedFrom isNotEqualTo "") then {
			_from = _selectedFrom;
			_display setVariable [QGVAR(mailFrom), _from];
		};
	};
};
private _to = [ctrlText (_display displayCtrl IDC_MMC_MAIL_RECIPIENT)] call CBA_fnc_trim;
private _cc = [ctrlText (_display displayCtrl IDC_MMC_MAIL_CC)] call CBA_fnc_trim;
private _subject = ctrlText (_display displayCtrl IDC_MMC_MAIL_SUBJECT);
private _body = ctrlText (_display displayCtrl IDC_MMC_MAIL_BODY);
private _attachment = [ctrlText (_display displayCtrl IDC_MMC_MAIL_ATTACHMENT)] call CBA_fnc_trim;
private _attachmentDescription = ctrlText (_display displayCtrl IDC_MMC_MAIL_ATTACHMENT_DESC);
private _composeAttachments = _display getVariable [QGVAR(mailComposeAttachments), []];
if !(_composeAttachments isEqualType []) then {
	_composeAttachments = [];
	_display setVariable [QGVAR(mailComposeAttachments), _composeAttachments];
};
private _attachments = [_attachment, _attachmentDescription, _composeAttachments] call FUNC(mailNormalizeAttachments);
private _error = _display displayCtrl IDC_MMC_MAIL_ERROR;

private _setError = {
	params ["_text"];
	_error ctrlSetText _text;
};
[""] call _setError;

if (_to isEqualTo "") exitWith {["Enter a recipient address."] call _setError; false};
if (_subject isEqualTo "") exitWith {["Enter a subject."] call _setError; false};
if (_body isEqualTo "") exitWith {["Enter a message."] call _setError; false};
if (_composeAttachments isEqualTo [] && {_attachment isNotEqualTo "" && {!fileExists _attachment}}) exitWith {["Attachment file does not exist."] call _setError; false};

if (_display getVariable [QGVAR(mailSending), false]) exitWith {false};
_display setVariable [QGVAR(mailSending), true];
(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlEnable false;
["Sending..."] call _setError;

[
	player,
	_computer,
	_from,
	_to,
	_subject,
	_body,
	_attachment,
	_cc,
	_attachmentDescription,
	_attachments
] remoteExecCall [QFUNC(sendMailRequest), 2];
true
