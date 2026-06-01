#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Toggles the login password field between masked and visible text.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _hidden = _display displayCtrl IDC_MMC_LOGIN_PASSWORD;
private _visible = _display displayCtrl IDC_MMC_LOGIN_PASSWORD_VISIBLE;
private _showVisible = !(_display getVariable [QGVAR(passwordVisible), false]);
private _password = _display getVariable [QGVAR(loginPassword), ""];

if (_showVisible) then {
	_visible ctrlSetText _password;
} else {
	_password = ctrlText _visible;
	_display setVariable [QGVAR(loginPassword), _password];
	private _masked = "";
	for "_i" from 1 to (count toArray _password) do {
		_masked = _masked + "*";
	};
	_hidden ctrlSetText _masked;
};

_display setVariable [QGVAR(passwordVisible), _showVisible];
_hidden ctrlShow !_showVisible;
_visible ctrlShow _showVisible;
(_display displayCtrl IDC_MMC_LOGIN_PASSWORD_TOGGLE) ctrlSetText (["Show", "Hide"] select _showVisible);
ctrlSetFocus ([_hidden, _visible] select _showVisible);
