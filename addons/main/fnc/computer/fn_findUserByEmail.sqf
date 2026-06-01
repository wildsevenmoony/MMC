#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Finds a registered user by email address.
 */

params [["_email", "", [""]]];

private _lookup = toLowerANSI _email;
private _result = createHashMap;

{
	if (toLowerANSI (_x getOrDefault ["email", ""]) isEqualTo _lookup) exitWith {
		_result = _x;
	};
} forEach (GVAR(registeredUsers) select {_x isEqualType createHashMap});

_result
