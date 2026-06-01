#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Toggles the start menu controls.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _open = !(_display getVariable [QGVAR(startMenuOpen), false]);
_display setVariable [QGVAR(startMenuOpen), _open];

private _computer = _display getVariable [QGVAR(computer), objNull];
private _poweredOn = _computer getVariable [QGVAR(poweredOn), true];
private _booting = _computer getVariable [QGVAR(booting), false];

(_display displayCtrl IDC_MMC_START_MENU) ctrlShow _open;
(_display displayCtrl IDC_MMC_START_BOOT) ctrlShow (_open && {!_poweredOn} && {!_booting});
(_display displayCtrl IDC_MMC_START_SHUTDOWN) ctrlShow (_open && {_poweredOn});

{
	if !(_open) then {
		(_display displayCtrl _x) ctrlShow false;
	};
} forEach [IDC_MMC_START_BOOT, IDC_MMC_START_SHUTDOWN];
