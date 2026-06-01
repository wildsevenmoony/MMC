#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a configured text file to synced MMC computers.
 */

params ["_logic"];

private _name = _logic getVariable [QGVAR(fileName), "intel.txt"];
private _path = _logic getVariable [QGVAR(filePath), "\Desktop\intel.txt"];
private _content = _logic getVariable [QGVAR(fileContent), "Mission intel goes here."];

{
	if (!isNull _x) then {
		[_x, _name, _content, "text", _path] call FUNC(addFile);
	};
} forEach synchronizedObjects _logic;

deleteVehicle _logic;
