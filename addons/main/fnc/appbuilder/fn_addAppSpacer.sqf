#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds vertical spacing to the currently rendering scripted app.
 *
 * Arguments:
 * 0: Height <NUMBER, default: 0.02>
 *
 * Return Value:
 * Added <BOOL>
 */

params [["_height", 0.02, [0]]];

private _display = uiNamespace getVariable [QGVAR(appBuilderDisplay), displayNull];
private _group = uiNamespace getVariable [QGVAR(appBuilderGroup), controlNull];
if (isNull _display || {isNull _group}) exitWith {false};

private _y = uiNamespace getVariable [QGVAR(appBuilderY), 0.015];
uiNamespace setVariable [QGVAR(appBuilderY), _y + (_height max 0)];

true
