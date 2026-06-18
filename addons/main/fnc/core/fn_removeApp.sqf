#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Removes a scripted mission app from a registered MMC computer.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: App id <STRING>
 * 2: Public object variable <BOOL, default: false>
 *
 * Return Value:
 * Removed <BOOL>
 */

params [
	["_object", objNull, [objNull]],
	["_id", "", [""]],
	["_public", false, [false]]
];

if (isNull _object || {_id isEqualTo ""}) exitWith {false};

private _lookup = toLowerANSI _id;
private _apps = _object getVariable [QGVAR(customApps), []];
if !(_apps isEqualType []) exitWith {false};

private _oldCount = count _apps;
_apps = _apps select {toLowerANSI (_x getOrDefault ["id", ""]) isNotEqualTo _lookup};
_object setVariable [QGVAR(customApps), _apps, _public];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (!isNull _display && {_object isEqualTo (_display getVariable [QGVAR(computer), objNull])}) then {
	if ((_display getVariable [QGVAR(currentApp), "desktop"]) isEqualTo format ["custom:%1", _lookup]) then {
		["desktop"] call FUNC(renderApp);
	} else {
		[_display] call FUNC(refreshAppButtons);
	};
};

_oldCount isNotEqualTo count _apps
