#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Starts a powered-off computer with a short boot sequence.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: Open dialog after boot <BOOL, default: false>
 *
 * Return Value:
 * Started <BOOL>
 */

params [
	["_object", objNull, [objNull]],
	["_openAfterBoot", false, [false]]
];

if (isNull _object || {!(_object getVariable [QGVAR(isComputer), false])}) exitWith {false};
if (_object getVariable [QGVAR(poweredOn), true]) exitWith {
	if (_openAfterBoot) then {
		[_object] call FUNC(open);
	};
	true
};
if (_object getVariable [QGVAR(booting), false]) exitWith {false};

_object setVariable [QGVAR(booting), true, true];

[_object, _openAfterBoot] spawn {
	params ["_object", "_openAfterBoot"];

	if (_openAfterBoot && {hasInterface}) then {
		GVAR(activeComputer) = _object;
		createDialog QGVAR(RscComputer);
		private _display = uiNamespace getVariable [QGVAR(display), displayNull];
		if (!isNull _display) then {
			private _powerScreen = _display displayCtrl IDC_MMC_POWER_SCREEN;
			_powerScreen ctrlShow true;
			_powerScreen ctrlSetStructuredText parseText "<t align='center' size='2.4'><br/><br/><br/><br/>MMC</t><br/><t align='center' size='1.1'>Starting system...</t>";
		};
	};

	sleep 3.5;

	if (isNull _object) exitWith {};

	_object setVariable [QGVAR(poweredOn), true, true];
	_object setVariable [QGVAR(booting), false, true];

	if (_openAfterBoot && {hasInterface}) then {
		private _display = uiNamespace getVariable [QGVAR(display), displayNull];
		if (!isNull _display) then {
			["desktop"] call FUNC(renderApp);
		} else {
			[_object] call FUNC(open);
		};
	};
};

true
