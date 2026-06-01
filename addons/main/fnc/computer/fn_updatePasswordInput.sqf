#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Keeps the hidden login password field masked while storing the real value.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};
if (_display getVariable [QGVAR(passwordVisible), false]) exitWith {};

private _control = _display displayCtrl IDC_MMC_LOGIN_PASSWORD;
private _text = ctrlText _control;
private _password = _display getVariable [QGVAR(loginPassword), ""];

if (_text isEqualTo "") then {
	_password = "";
} else {
	private _chars = toArray _text;
	private _plainChars = _chars select {_x != 42};

	if (_plainChars isNotEqualTo []) then {
		_password = _password + toString _plainChars;
	} else {
		private _targetLength = count _chars;
		private _currentLength = count toArray _password;
		if (_targetLength < _currentLength) then {
			_password = _password select [0, _targetLength];
		};
	};
};

_display setVariable [QGVAR(loginPassword), _password];

private _masked = "";
for "_i" from 1 to (count toArray _password) do {
	_masked = _masked + "*";
};
_control ctrlSetText _masked;
