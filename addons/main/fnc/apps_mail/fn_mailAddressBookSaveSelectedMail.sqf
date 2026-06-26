#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Saves the sender/recipient of the currently opened mail to the active user's address book.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Saved <BOOL>
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

private _mail = _display getVariable [QGVAR(selectedMail), createHashMap];
private _folder = _display getVariable [QGVAR(selectedMailFolder), "inbox"];
private _key = ["from", "to"] select (_folder isEqualTo "outbox");
private _email = [_mail getOrDefault [_key, ""]] call CBA_fnc_trim;
if (_email isEqualTo "") exitWith {false};
(_display displayCtrl IDC_MMC_MAIL_RECIPIENT) ctrlSetText ((_email splitString "@") param [0, _email]);
(_display displayCtrl IDC_MMC_MAIL_SUBJECT) ctrlSetText _email;
call FUNC(mailAddressBookSave)
