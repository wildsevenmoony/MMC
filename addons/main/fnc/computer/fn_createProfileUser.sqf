#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Creates the local client's default MMC user account from CBA settings.
 */

private _username = GVAR(profileLoginName);
private _email = GVAR(profileEmail);

if (_username isEqualTo "") then {
	_username = profileName;
};

if (_email isEqualTo "") then {
	_email = format ["%1@mccsystems.com", _username];
};

createHashMapFromArray [
	["username", _username],
	["password", GVAR(profilePassword)],
	["email", _email],
	["background", GVAR(profileBackground)],
	["source", "profile"]
]
