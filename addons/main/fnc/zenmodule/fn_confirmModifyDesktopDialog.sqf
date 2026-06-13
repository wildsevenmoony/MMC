#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Confirms the Modify Desktop dynamic dialog.
 */

params ["_display", "_values", "_arguments"];

private _getValue = {
	params ["_key", "_default"];
	private _index = _values findIf {(_x select 0) isEqualTo _key};
	if (_index < 0) exitWith {_default};
	(_values select _index) select 3
};

private _title = ["desktopTitle", "Welcome"] call _getValue;
private _content = ["desktopContent", "Select an app on the left."] call _getValue;
private _align = toLowerANSI (["desktopAlign", "left"] call _getValue);
private _selected = (_display getVariable [QGVAR(userCheckboxes), []]) select {cbChecked (_x select 1)};

if !(_align in ["left", "center", "right"]) then {
	_align = "left";
};

if (_selected isEqualTo []) exitWith {
	[objNull, "NO USERS SELECTED"] call BIS_fnc_showCuratorFeedbackMessage;
	false
};

{
	private _computer = _x;
	{
		[_computer, _x select 0, _title, _content, _align] remoteExecCall [QFUNC(modifyDesktop), 2];
	} forEach _selected;
} forEach ([] call FUNC(getRegisteredComputers));

[objNull, "DESKTOP MODIFIED"] call BIS_fnc_showCuratorFeedbackMessage;
true
