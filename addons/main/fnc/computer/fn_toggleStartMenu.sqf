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
private _data = _computer getVariable [QGVAR(data), createHashMap];
private _loginRequired = _data getOrDefault ["loginRequired", true];
private _showLogout = _poweredOn && {_loginRequired};
private _twoRows = _poweredOn && {_showLogout};
private _menuY = if (_twoRows) then {safeZoneY + safeZoneH - 0.153} else {safeZoneY + safeZoneH - 0.108};
private _menuH = [0.053, 0.098] select _twoRows;

{
	(_display displayCtrl _x) ctrlSetPositionY _menuY;
	(_display displayCtrl _x) ctrlSetPositionH _menuH;
	(_display displayCtrl _x) ctrlCommit 0;
} forEach [IDC_MMC_START_MENU, IDC_MMC_FRAME_START_MENU];

(_display displayCtrl IDC_MMC_START_MENU) ctrlShow _open;
(_display displayCtrl IDC_MMC_FRAME_START_MENU) ctrlShow _open;
(_display displayCtrl IDC_MMC_START_BOOT) ctrlShow (_open && {!_poweredOn} && {!_booting});
(_display displayCtrl IDC_MMC_FRAME_START_BOOT) ctrlShow (_open && {!_poweredOn} && {!_booting});
(_display displayCtrl IDC_MMC_START_LOGOUT) ctrlShow (_open && {_showLogout});
(_display displayCtrl IDC_MMC_FRAME_START_LOGOUT) ctrlShow (_open && {_showLogout});
(_display displayCtrl IDC_MMC_START_SHUTDOWN) ctrlShow (_open && {_poweredOn});
(_display displayCtrl IDC_MMC_FRAME_START_SHUTDOWN) ctrlShow (_open && {_poweredOn});

// The app list frame sits just under the start menu edge; hide it while the menu is open.
(_display displayCtrl IDC_MMC_FRAME_APP_LIST) ctrlShow !_open;

{
	if !(_open) then {
		(_display displayCtrl _x) ctrlShow false;
	};
} forEach [
	IDC_MMC_START_BOOT,
	IDC_MMC_FRAME_START_BOOT,
	IDC_MMC_START_LOGOUT,
	IDC_MMC_FRAME_START_LOGOUT,
	IDC_MMC_START_SHUTDOWN,
	IDC_MMC_FRAME_START_SHUTDOWN
];
