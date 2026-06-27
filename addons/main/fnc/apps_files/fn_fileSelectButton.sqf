#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Selects a file from the Files app content button list.
 *
 * Arguments:
 * 0: File index in the current folder <NUMBER>
 *
 * Return Value:
 * Selected <BOOL>
 */

params [["_index", -1, [0]]];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

if (_index isEqualTo -2) exitWith {
	_display setVariable [QGVAR(filesFolder), ""];
	_display setVariable [QGVAR(selectedFileIndex), -1];
	["select", [controlNull, -1]] call FUNC(renderApp);
	true
};

if (_index isEqualTo -1) exitWith {
	_display setVariable [QGVAR(selectedFileIndex), -1];
	["select", [controlNull, -1]] call FUNC(renderApp);
	true
};

_display setVariable [QGVAR(selectedFileIndex), _index];
["select", [controlNull, -1]] call FUNC(renderApp);
true
