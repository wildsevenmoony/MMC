#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Registers cleanup code for the currently rendering scripted app.
 *
 * Arguments:
 * 0: Cleanup callback <CODE>
 * 1: Callback arguments <ANY, default: []>
 *
 * Return Value:
 * Registered <BOOL>
 *
 * Example:
 * [{params ["_display", "_args"]; systemChat "Cleaning app"}] call MMC_fnc_addAppCleanup
 */

params [
	["_cleanup", {}, [{}]],
	["_args", []]
];

private _display = uiNamespace getVariable [QGVAR(appBuilderDisplay), displayNull];
if (isNull _display) exitWith {false};

private _handlers = _display getVariable [QGVAR(appCleanupHandlers), []];
_handlers pushBack [_cleanup, _args];
_display setVariable [QGVAR(appCleanupHandlers), _handlers];

true
