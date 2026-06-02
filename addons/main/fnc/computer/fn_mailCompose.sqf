#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Opens the mail composer for a new, reply, or forwarded message.
 */

params [["_mode", "new", [""]]];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

private _mail = _display getVariable [QGVAR(selectedMail), createHashMap];
private _recipient = "";
private _cc = "";
private _subject = "";
private _body = "";

switch (_mode) do {
	case "reply": {
		_recipient = _mail getOrDefault ["from", ""];
		_cc = _mail getOrDefault ["cc", ""];
		_subject = _mail getOrDefault ["subject", ""];
		if ((_subject select [0, 4]) isNotEqualTo "Re: ") then {
			_subject = format ["Re: %1", _subject];
		};
	};
	case "forward": {
		private _nl = toString [10];
		_subject = _mail getOrDefault ["subject", ""];
		if ((_subject select [0, 5]) isNotEqualTo "Fwd: ") then {
			_subject = format ["Fwd: %1", _subject];
		};
		_body = format [
			"Forwarded message:%6From: %1%6To: %2%6CC: %7%6Date: %3 %4%6%6%5",
			_mail getOrDefault ["from", ""],
			_mail getOrDefault ["to", ""],
			_mail getOrDefault ["date", ""],
			_mail getOrDefault ["time", ""],
			_mail getOrDefault ["body", ""],
			_nl,
			_mail getOrDefault ["cc", ""]
		];
	};
};

(_display displayCtrl IDC_MMC_MAIL_RECIPIENT) ctrlSetText _recipient;
(_display displayCtrl IDC_MMC_MAIL_CC) ctrlSetText _cc;
(_display displayCtrl IDC_MMC_MAIL_SUBJECT) ctrlSetText _subject;
(_display displayCtrl IDC_MMC_MAIL_BODY) ctrlSetText _body;
(_display displayCtrl IDC_MMC_MAIL_ATTACHMENT) ctrlSetText "";
(_display displayCtrl IDC_MMC_MAIL_ERROR) ctrlSetText "";
_display setVariable [QGVAR(mailMode), "compose"];
_display setVariable [QGVAR(composeMode), _mode];
["compose"] call FUNC(renderMail);
call FUNC(resizeMailBody);
true
