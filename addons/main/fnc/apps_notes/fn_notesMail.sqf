#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Opens the mail composer with the current note as a draft.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Opened <BOOL>
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

private _titleControl = _display getVariable [QGVAR(notesTitleControl), controlNull];
private _bodyControl = _display getVariable [QGVAR(notesBodyControl), controlNull];
if (isNull _titleControl || {isNull _bodyControl}) exitWith {false};

private _title = [ctrlText _titleControl] call CBA_fnc_trim;
private _body = ctrlText _bodyControl;
if (_title isEqualTo "") then {
	_title = "Untitled note";
};

[_display, false, true] call FUNC(clearCustomControls);
(_display displayCtrl IDC_MMC_DESKTOP_CONTENT_GROUP) ctrlShow false;
(_display displayCtrl IDC_MMC_DESKTOP_CONTENT_BODY) ctrlShow false;
(_display displayCtrl IDC_MMC_DESKTOP_CONTENT_BODY) ctrlSetStructuredText parseText "";
_display setVariable [QGVAR(currentApp), "mail"];
_display setVariable [QGVAR(mailMode), "compose"];
_display setVariable [QGVAR(composeMode), "new"];
_display setVariable [QGVAR(mailFrom), ""];
["compose"] call FUNC(renderMail);

(_display displayCtrl IDC_MMC_MAIL_RECIPIENT) ctrlSetText "";
(_display displayCtrl IDC_MMC_MAIL_CC) ctrlSetText "";
(_display displayCtrl IDC_MMC_MAIL_SUBJECT) ctrlSetText format ["Note: %1", _title];
(_display displayCtrl IDC_MMC_MAIL_BODY) ctrlSetText _body;
(_display displayCtrl IDC_MMC_MAIL_ATTACHMENT) ctrlSetText "";
(_display displayCtrl IDC_MMC_MAIL_ATTACHMENT_DESC) ctrlSetText "";
(_display displayCtrl IDC_MMC_MAIL_ERROR) ctrlSetText "";
_display setVariable [QGVAR(mailComposeAttachments), []];
_display setVariable [QGVAR(mailComposeDraft), createHashMap];
call FUNC(resizeMailBody);

[_display] call FUNC(refreshStandardApps);
[_display] call FUNC(refreshAppButtons);
if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
	[_display] call FUNC(applyMobileDisplayLayout);
};

["Notes", "Opened note in mail composer", createHashMapFromArray [
	["title", _title]
]] call FUNC(debugLog);

true
