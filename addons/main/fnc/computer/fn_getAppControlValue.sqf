#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Returns the value of a control created by the scripted app builder.
 *
 * Arguments:
 * 0: Value id <STRING>
 * 1: Default value <ANY, default: "">
 *
 * Return Value:
 * Control value <ANY>
 */

params [
	["_id", "", [""]],
	["_default", ""]
];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display || {_id isEqualTo ""}) exitWith {_default};

private _map = _display getVariable [QGVAR(appControlMap), createHashMap];
private _control = _map getOrDefault [toLowerANSI _id, controlNull];
if (isNull _control) exitWith {_default};

switch (_control getVariable [QGVAR(valueType), ""]) do {
	case "checkbox": {cbChecked _control};
	case "combo": {
		private _index = lbCurSel _control;
		if (_index < 0) exitWith {_default};
		_control lbData _index
	};
	default {ctrlText _control};
}
