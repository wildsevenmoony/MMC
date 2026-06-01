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
[_object, "startup"] call FUNC(setScreenState);

[_object, _openAfterBoot] spawn {
	params ["_object", "_openAfterBoot"];

	if (_openAfterBoot && {hasInterface}) then {
		private _ownerUid = getPlayerUID player;
		private _inUseBy = _object getVariable [QGVAR(inUseBy), ""];
		if (_inUseBy isNotEqualTo "" && {_inUseBy isNotEqualTo _ownerUid}) exitWith {
			_object setVariable [QGVAR(booting), false, true];
			["This computer is already in use.", 1.5, player, 12] call ace_common_fnc_displayTextStructured;
		};
		_object setVariable [QGVAR(inUseBy), _ownerUid, true];
		GVAR(activeComputer) = _object;
		createDialog QGVAR(RscComputer);
		private _display = uiNamespace getVariable [QGVAR(display), displayNull];
		if (!isNull _display) then {
			[
				_display,
				true,
				["MMC", "Starting system...", "Powering hardware interfaces"],
				0.08
			] call FUNC(setSystemOverlay);
		};
	};

	if (_openAfterBoot && {hasInterface}) then {
		private _steps = [
			[0.22, "Initializing file system..."],
			[0.42, "Loading user profile..."],
			[0.64, "Starting desktop services..."],
			[0.82, "Mounting applications..."],
			[1.0, "Finalizing session..."]
		];

		{
			uiSleep (0.45 + random 0.85);
			private _display = uiNamespace getVariable [QGVAR(display), displayNull];
			if (!isNull _display) then {
				_x params ["_progress", "_message"];
				[
					_display,
					true,
					["MMC", "Starting system...", _message],
					_progress
				] call FUNC(setSystemOverlay);
			};
		} forEach _steps;
	} else {
		sleep (2.8 + random 2.4);
	};

	if (isNull _object) exitWith {};

	_object setVariable [QGVAR(poweredOn), true, true];
	_object setVariable [QGVAR(booting), false, true];

	if (_openAfterBoot && {hasInterface}) then {
		private _display = uiNamespace getVariable [QGVAR(display), displayNull];
		if (!isNull _display) then {
			private _activeUser = [_object] call FUNC(getActiveUser);
			if (count _activeUser == 0) then {
				[_display] call FUNC(showLogin);
			} else {
				[_display] call FUNC(hideLogin);
				["desktop"] call FUNC(renderApp);
			};
		} else {
			[_object] call FUNC(open);
		};
	} else {
		[_object, ["desktop", "login"] select (count ([_object] call FUNC(getActiveUser)) == 0)] call FUNC(setScreenState);
	};
};

true
