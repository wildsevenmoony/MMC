#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Reads standard app enable checkboxes from a module or object config holder.
 *
 * Arguments:
 * 0: Config source <OBJECT>
 *
 * Return Value:
 * Disabled standard app ids <ARRAY>
 */

params [["_source", objNull, [objNull]]];

if (isNull _source) exitWith {[]};

private _disabled = [];
{
	_x params ["_variable", "_app"];
	if !(_source getVariable [_variable, true]) then {
		_disabled pushBack _app;
	};
} forEach [
	[QGVAR(appFilesEnabled), "files"],
	[QGVAR(appMailEnabled), "mail"],
	[QGVAR(appMessagesEnabled), "messages"],
	[QGVAR(appNotesEnabled), "notes"]
];

[_disabled] call FUNC(normalizeStandardAppIds)
