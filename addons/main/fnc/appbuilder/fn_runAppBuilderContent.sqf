#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Runs app builder content from text, code, or ordered arrays.
 *
 * Arguments:
 * 0: Content <STRING, CODE, or ARRAY>
 *
 * Return Value:
 * None
 */

params [["_content", "", ["", {}, []]]];

private _display = uiNamespace getVariable [QGVAR(appBuilderDisplay), displayNull];
private _computer = uiNamespace getVariable [QGVAR(appBuilderComputer), objNull];
private _activeUser = uiNamespace getVariable [QGVAR(appBuilderUser), createHashMap];
private _app = uiNamespace getVariable [QGVAR(appBuilderApp), createHashMap];
if (isNull _display) exitWith {};

private _addResult = {
	params ["_result"];
	if (isNil "_result") exitWith {};
	if (_result isEqualType "") exitWith {
		if (_result isNotEqualTo "") then {
			[_result] call FUNC(addAppStructuredText);
		};
	};
	if (_result isEqualType []) exitWith {
		[_result] call FUNC(runAppBuilderContent);
	};
};

if (_content isEqualType []) exitWith {
	{
		if (_x isEqualType {}) then {
			private _result = [_computer, _activeUser, _app, _display] call _x;
			[_result] call _addResult;
		} else {
			if (_x isEqualType "") then {
				[_x] call _addResult;
			} else {
				if (_x isEqualType []) then {
					[_x] call FUNC(runAppBuilderContent);
				};
			};
		};
	} forEach _content;
};

if (_content isEqualType {}) then {
	private _result = [_computer, _activeUser, _app, _display] call _content;
	[_result] call _addResult;
} else {
	[_content] call _addResult;
};
