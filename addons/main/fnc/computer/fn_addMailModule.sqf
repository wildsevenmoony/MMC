#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a configured email to synced MMC computers.
 */

params ["_logic"];

private _from = _logic getVariable [QGVAR(mailFrom), "sender@mmc.local"];
private _to = _logic getVariable [QGVAR(mailTo), "operator@mmc.local"];
private _subject = _logic getVariable [QGVAR(mailSubject), "Mission Update"];
private _body = _logic getVariable [QGVAR(mailBody), "Mail body goes here."];
private _date = _logic getVariable [QGVAR(mailDate), "2035-06-01 08:00"];

{
	if (!isNull _x) then {
		[_x, _from, _to, _subject, _body, _date] call FUNC(addMail);
	};
} forEach synchronizedObjects _logic;

deleteVehicle _logic;
