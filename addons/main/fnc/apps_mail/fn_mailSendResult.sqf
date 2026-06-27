#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Applies the server result of a composed email request to the local computer dialog.
 *
 * Arguments:
 * 0: Success <BOOL>
 * 1: Message <STRING>
 * 2: Active computer <OBJECT>
 * 3: Updated computer data <HASHMAP>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [
	["_success", false, [false]],
	["_message", "", [""]],
	["_computer", objNull, [objNull]],
	["_data", createHashMap, [createHashMap]]
];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

_display setVariable [QGVAR(mailSending), false];
(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlEnable true;

private _error = _display displayCtrl IDC_MMC_MAIL_ERROR;

if (!_success) exitWith {
	_error ctrlSetText _message;
};

if (!isNull _computer && {count _data > 0}) then {
	_computer setVariable [QGVAR(data), _data];
	_display setVariable [QGVAR(data), _data];
	private _activeUser = [_computer] call FUNC(getActiveUser);
	_display setVariable [QGVAR(activeUser), _activeUser];
};

_error ctrlSetText "";
_display setVariable [QGVAR(mailComposeAttachments), []];
_display setVariable [QGVAR(mailComposeDraft), createHashMap];
_display setVariable [QGVAR(mailFolder), "outbox"];
_display setVariable [QGVAR(mailMode), "table"];
["table"] call FUNC(renderMail);
