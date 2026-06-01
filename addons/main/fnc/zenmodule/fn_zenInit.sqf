#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Registers MMC custom Zeus modules through ZEN.
 */

if (!hasInterface) exitWith {};
if !(isClass (configFile >> "CfgPatches" >> "zen_custom_modules")) exitWith {};

[] spawn {
	private _modules = [
		["Register Computer", {_this call FUNC(registerComputerZeus)}],
		["Power On Computer", {_this call FUNC(powerOnZeus)}],
		["Power Off Computer", {_this call FUNC(powerOffZeus)}],
		["Add Text File", {_this call FUNC(addTextFileZeus)}],
		["Add Mail", {_this call FUNC(addMailZeus)}]
	];

	{
		_x params ["_displayName", "_statement"];
		["Moony's Magnificent Computers", _displayName, _statement] call zen_custom_modules_fnc_register;
	} forEach _modules;
};
