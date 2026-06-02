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
private _to = ctrlText (_display displayCtrl IDC_MMC_MAIL_RECIPIENT);
private _cc = ctrlText (_display displayCtrl IDC_MMC_MAIL_CC);
private _subject = ctrlText (_display displayCtrl IDC_MMC_MAIL_SUBJECT);
private _body = ctrlText (_display displayCtrl IDC_MMC_MAIL_BODY);
private _attachment = ctrlText (_display displayCtrl IDC_MMC_MAIL_ATTACHMENT);
private _attachmentDescription = ctrlText (_display displayCtrl IDC_MMC_MAIL_ATTACHMENT_DESC);
private _error = _display displayCtrl IDC_MMC_MAIL_ERROR;

private _setError = {
	params ["_text"];
	_error ctrlSetText _text;
};
[""] call _setError;

if (_to isEqualTo "") exitWith {["Enter a recipient address."] call _setError; false};
if (count ([_to] call FUNC(findUserByEmail)) == 0) exitWith {["Recipient address does not exist."] call _setError; false};
if (_subject isEqualTo "") exitWith {["Enter a subject."] call _setError; false};
if (_body isEqualTo "") exitWith {["Enter a message."] call _setError; false};
if (_attachment isNotEqualTo "" && {!fileExists _attachment}) exitWith {["Attachment file does not exist."] call _setError; false};

private _sent = [_from, _to, _subject, _body, _attachment, _cc, _attachmentDescription] call FUNC(sendMail);
if (!_sent) exitWith {["Could not send mail."] call _setError; false};

_display setVariable [QGVAR(mailFolder), "outbox"];
_display setVariable [QGVAR(mailMode), "table"];
["table"] call FUNC(renderMail);
true
