#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Starts or stops local Intrusion Tool hacking sound pulses.
 *
 * Arguments:
 * 0: Unit using the Intrusion Tool <OBJECT>
 * 1: Effects enabled <BOOL>
 *
 * Return Value:
 * Effects handled <BOOL>
 */

params [
	["_unit", player, [objNull]],
	["_enabled", true, [false]]
];

if (!hasInterface || {isNull _unit} || {!local _unit}) exitWith {false};

if (!_enabled) exitWith {
	_unit setVariable [QGVAR(hackingEffectsActive), false, false];
	true
};

if (_unit getVariable [QGVAR(hackingEffectsActive), false]) exitWith {true};
_unit setVariable [QGVAR(hackingEffectsActive), true, false];

[_unit] spawn {
	params ["_unit"];

	private _sounds = [
		QGVAR(hack1),
		QGVAR(hack2),
		QGVAR(hack3),
		QGVAR(hack4),
		QGVAR(hack5),
		QGVAR(hack6),
		QGVAR(hack7)
	];

	private _nextSound = 0;
	while {_unit getVariable [QGVAR(hackingEffectsActive), false]} do {
		if (time >= _nextSound) then {
			[_unit, selectRandom _sounds] remoteExecCall [QFUNC(hackingPlaySoundLocal), 0];
			_nextSound = time + 1.2 + random 1.4;
		};

		uiSleep 0.25;
	};
};

true
