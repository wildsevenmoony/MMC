#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Returns unique mission-defined MMC users from registered computers.
 */

private _users = +GVAR(registeredUsers);
private _computers = [] call FUNC(getRegisteredComputers);

{
	private _data = _x getVariable [QGVAR(data), createHashMap];
	{
		private _username = _x getOrDefault ["username", ""];
		if (_username isNotEqualTo "" && {_users findIf {toLowerANSI (_x getOrDefault ["username", ""]) isEqualTo toLowerANSI _username} < 0}) then {
			_users pushBack _x;
		};
	} forEach (_data getOrDefault ["users", []]);
} forEach _computers;

_users
