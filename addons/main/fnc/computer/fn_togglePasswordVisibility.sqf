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

if (_showVisible) then {
	_visible ctrlSetText ctrlText _hidden;
} else {
	_hidden ctrlSetText ctrlText _visible;
};

_display setVariable [QGVAR(passwordVisible), _showVisible];
_hidden ctrlShow !_showVisible;
_visible ctrlShow _showVisible;
(_display displayCtrl IDC_MMC_LOGIN_PASSWORD_TOGGLE) ctrlSetText (["Show", "Hide"] select _showVisible);
ctrlSetFocus ([_hidden, _visible] select _showVisible);
