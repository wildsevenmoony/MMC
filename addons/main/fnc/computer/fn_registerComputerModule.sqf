#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Registers synced objects as MMC computers from an Eden/Zeus module.
 */

params ["_logic"];

private _objects = synchronizedObjects _logic;
private _config = createHashMapFromArray [
	["poweredOn", _logic getVariable [QGVAR(poweredOn), true]],
	["background", _logic getVariable [QGVAR(background), ""]],
	["systemName", _logic getVariable [QGVAR(systemName), "MMC Workstation"]]
];

{
	if (!isNull _x) then {
		[_x, _config] call FUNC(registerObject);
	};
} forEach _objects;

deleteVehicle _logic;
