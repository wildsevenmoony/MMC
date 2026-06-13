#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Finds a registered user by email address.
 */

params [["_email", "", [""]]];

private _lookup = toLowerANSI ([_email] call CBA_fnc_trim);
private _result = createHashMap;

{
	if (toLowerANSI ([(_x getOrDefault ["email", ""])] call CBA_fnc_trim) isEqualTo _lookup) exitWith {
		_result = _x;
	};
} forEach (([] call FUNC(getRegisteredUsers)) select {_x isEqualType createHashMap});

_result
