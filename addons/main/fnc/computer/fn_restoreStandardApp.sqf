#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Restores standard MMC apps on a computer or one user of a computer.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: App ids <STRING or ARRAY> ("files", "mail", "messages", "notes")
 * 2: Username <STRING, default: "">; empty changes the computer default
 *
 * Return Value:
 * Changed <BOOL>
 */

params [
	["_computer", objNull, [objNull]],
	["_apps", [], ["", []]],
	["_username", "", [""]]
];

[_computer, _apps, false, _username] call FUNC(setStandardAppHidden)
