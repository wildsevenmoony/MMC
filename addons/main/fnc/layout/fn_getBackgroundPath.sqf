#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Resolves a desktop background preset or texture path to a UI texture path.
 *
 * Arguments:
 * 0: Background preset or explicit path <STRING>
 *
 * Return Value:
 * Texture path <STRING>
 */

params [["_background", "", [""]]];

if (_background isEqualTo "") then {
	_background = missionNamespace getVariable [QGVAR(profileTheme), "dark"];
};

if ((toArray _background) param [0, -1] isEqualTo 92) exitWith {_background};

switch (toLowerANSI _background) do {
	case "default": {
		private _theme = toLowerANSI (missionNamespace getVariable [QGVAR(profileTheme), "dark"]);
		[PATHTOF(img\desktop_default_dark.paa), PATHTOF(img\desktop_default_light.paa)] select (_theme isEqualTo "light");
	};
	case "dark": {PATHTOF(img\desktop_default_dark.paa)};
	case "light": {PATHTOF(img\desktop_default_light.paa)};
	case "default_dark": {PATHTOF(img\desktop_default_dark.paa)};
	case "default_light": {PATHTOF(img\desktop_default_light.paa)};
	case "nato": {PATHTOF(img\desktop_nato.paa)};
	case "csat": {PATHTOF(img\desktop_csat.paa)};
	case "aaf": {PATHTOF(img\desktop_aaf.paa)};
	case "fia": {PATHTOF(img\desktop_fia.paa)};
	default {_background};
}
