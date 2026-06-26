#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Enables the Address Book save button only when both editor fields contain text.
 *
 * Arguments:
 * 0: Display, edit control, or key event array <DISPLAY, CONTROL or ARRAY, optional>
 *
 * Return Value:
 * Save allowed <BOOL>
 */

params [["_source", displayNull, [displayNull, controlNull, []]]];

private _display = displayNull;
if (_source isEqualType displayNull) then {
	_display = _source;
};
if (_source isEqualType controlNull) then {
	_display = ctrlParent _source;
};
if (_source isEqualType []) then {
	private _control = _source param [0, controlNull, [controlNull]];
	if (!isNull _control) then {
		_display = ctrlParent _control;
	};
};
if (isNull _display) then {
	_display = uiNamespace getVariable [QGVAR(display), displayNull];
};
if (isNull _display) exitWith {false};

private _name = [ctrlText (_display displayCtrl IDC_MMC_MAIL_RECIPIENT)] call CBA_fnc_trim;
private _email = [ctrlText (_display displayCtrl IDC_MMC_MAIL_SUBJECT)] call CBA_fnc_trim;
private _canSave = _name isNotEqualTo "" && {_email isNotEqualTo ""};

(_display displayCtrl IDC_MMC_MAIL_SEND) ctrlEnable _canSave;

_canSave
