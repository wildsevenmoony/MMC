#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Updates a progress bar created by MMC_fnc_addAppProgressBar.
 *
 * Arguments:
 * 0: Progress control or value id <CONTROL or STRING>
 * 1: Value from 0 to 1 <NUMBER>
 * 2: Display text override <STRING, default: percentage>
 *
 * Return Value:
 * Updated <BOOL>
 *
 * Example:
 * ["signal", 0.8, "80% / nominal"] call MMC_fnc_setAppProgressBar
 */

params [
	["_target", controlNull, [controlNull, ""]],
	["_value", 0, [0]],
	["_text", "", [""]]
];

private _control = _target;
if (_target isEqualType "") then {
	private _display = uiNamespace getVariable [QGVAR(display), displayNull];
	if (isNull _display) exitWith {false};

	private _map = _display getVariable [QGVAR(appControlMap), createHashMap];
	_control = _map getOrDefault [toLowerANSI _target, controlNull];
};

if (isNull _control) exitWith {false};

private _safeValue = (_value max 0) min 1;
private _pos = ctrlPosition _control;
private _maxW = _control getVariable [QGVAR(progressMaxWidth), _pos select 2];
_pos set [2, 0.001 max (_maxW * _safeValue)];
_control ctrlSetPosition _pos;
_control ctrlCommit 0;

private _valueCtrl = _control getVariable [QGVAR(progressValueControl), controlNull];
if (!isNull _valueCtrl) then {
	private _label = _text;
	if (_label isEqualTo "") then {
		_label = format ["%1%2", round (_safeValue * 100), "%"];
	};
	_valueCtrl ctrlSetText _label;
};

true
