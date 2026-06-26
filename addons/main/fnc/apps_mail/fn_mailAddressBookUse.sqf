#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Opens the composer with the selected address as recipient or CC.
 *
 * Arguments:
 * 0: Target field, "to" or "cc" <STRING>
 *
 * Return Value:
 * Opened <BOOL>
 */

params [["_target", "to", [""]]];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

private _entry = _display getVariable [QGVAR(selectedAddressBookEntry), createHashMap];
private _email = [_entry getOrDefault ["email", ""]] call CBA_fnc_trim;
if (_email isEqualTo "") exitWith {
	_display setVariable [QGVAR(mailAddressBookStatus), "Select an e-mail address first."];
	["addressbook"] call FUNC(renderMail);
	false
};

_display setVariable [QGVAR(mailMode), "compose"];
_display setVariable [QGVAR(composeMode), "new"];
_display setVariable [QGVAR(mailAddressBookStatus), ""];
["compose"] call FUNC(renderMail);

private _draft = _display getVariable [QGVAR(mailComposeDraft), createHashMap];
(_display displayCtrl IDC_MMC_MAIL_RECIPIENT) ctrlSetText (_draft getOrDefault ["recipient", ""]);
(_display displayCtrl IDC_MMC_MAIL_CC) ctrlSetText (_draft getOrDefault ["cc", ""]);
(_display displayCtrl IDC_MMC_MAIL_SUBJECT) ctrlSetText (_draft getOrDefault ["subject", ""]);
(_display displayCtrl IDC_MMC_MAIL_BODY) ctrlSetText (_draft getOrDefault ["body", ""]);
(_display displayCtrl IDC_MMC_MAIL_ATTACHMENT) ctrlSetText (_draft getOrDefault ["attachment", ""]);
(_display displayCtrl IDC_MMC_MAIL_ATTACHMENT_DESC) ctrlSetText (_draft getOrDefault ["attachmentDescription", ""]);
_display setVariable [QGVAR(mailComposeDraft), createHashMap];

if (_target isEqualTo "cc") then {
	private _cc = ctrlText (_display displayCtrl IDC_MMC_MAIL_CC);
	private _ccEntries = [];
	{
		private _entry = [_x] call CBA_fnc_trim;
		if (_entry isNotEqualTo "") then {
			_ccEntries pushBackUnique _entry;
		};
	} forEach (_cc splitString ",");
	_ccEntries pushBackUnique _email;
	(_display displayCtrl IDC_MMC_MAIL_CC) ctrlSetText (_ccEntries joinString ", ");
} else {
	(_display displayCtrl IDC_MMC_MAIL_RECIPIENT) ctrlSetText _email;
};
call FUNC(resizeMailBody);
true
