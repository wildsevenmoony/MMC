#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Returns all files visible to the active mail user.
 *
 * Arguments:
 * 0: Computer/device object <OBJECT>
 * 1: Active user <HASHMAP>
 *
 * Return Value:
 * Visible files <ARRAY>
 */

params [
	["_computer", objNull, [objNull]],
	["_activeUser", createHashMap, [createHashMap]]
];

private _data = if (isNull _computer) then {
	private _display = uiNamespace getVariable [QGVAR(display), displayNull];
	_display getVariable [QGVAR(data), createHashMap]
} else {
	_computer getVariable [QGVAR(data), createHashMap]
};

private _files = (_data getOrDefault ["files", []]) + (_activeUser getOrDefault ["files", []]);
_files select {_x isEqualType createHashMap}
