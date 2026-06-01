#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Toggles the start menu controls.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _open = !(_display getVariable [QGVAR(startMenuOpen), false]);
_display setVariable [QGVAR(startMenuOpen), _open];

{
	(_display displayCtrl _x) ctrlShow _open;
} forEach [IDC_MMC_START_MENU, IDC_MMC_START_BOOT, IDC_MMC_START_SHUTDOWN];
