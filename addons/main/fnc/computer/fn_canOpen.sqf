#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Checks whether a computer can currently be opened.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 *
 * Return Value:
 * Can open <BOOL>
 */

params [["_object", objNull, [objNull]]];

!(isNull _object)
&& {_object getVariable [QGVAR(isComputer), false]}
