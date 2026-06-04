#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Renders a scripted mission app.
 *
 * Arguments:
 * 0: App id <STRING>
 *
 * Return Value:
 * Rendered <BOOL>
 */

params [["_id", "", [""]]];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

[_display, false, true] call FUNC(clearCustomControls);

private _computer = _display getVariable [QGVAR(computer), objNull];
private _activeUser = [_computer] call FUNC(getActiveUser);
private _apps = _computer getVariable [QGVAR(customApps), []];
private _lookup = toLowerANSI _id;
private _index = _apps findIf {toLowerANSI (_x getOrDefault ["id", ""]) isEqualTo _lookup};
if (_index < 0) exitWith {false};

private _app = _apps select _index;
private _title = _display displayCtrl IDC_MMC_APP_TITLE;
private _body = _display displayCtrl IDC_MMC_APP_BODY;
private _bodyPos = [safeZoneX + 0.43, safeZoneY + 0.135, safeZoneW - 0.61, safeZoneH - 0.315];

_title ctrlSetText (_app getOrDefault ["label", _id]);
_body ctrlSetPosition _bodyPos;
_body ctrlSetStructuredText parseText "";
_body ctrlCommit 0;

private _group = _display ctrlCreate [QGVAR(RscComputerAppGroup), [_display] call FUNC(nextDynamicIdc)];
_group ctrlSetPosition _bodyPos;
_group ctrlSetText "";
_group ctrlCommit 0;

_display setVariable [QGVAR(customActionControls), [_group]];
_display setVariable [QGVAR(appControlMap), createHashMap];
_display setVariable [QGVAR(currentCustomApp), _app];

uiNamespace setVariable [QGVAR(appBuilderDisplay), _display];
uiNamespace setVariable [QGVAR(appBuilderComputer), _computer];
uiNamespace setVariable [QGVAR(appBuilderUser), _activeUser];
uiNamespace setVariable [QGVAR(appBuilderApp), _app];
uiNamespace setVariable [QGVAR(appBuilderGroup), _group];
uiNamespace setVariable [QGVAR(appBuilderY), 0.015];

[_app getOrDefault ["content", ""]] call FUNC(runAppBuilderContent);

{
	private _label = if (_x isEqualType createHashMap) then {_x getOrDefault ["label", "Action"]} else {_x param [0, "Action", [""]]};
	private _statement = if (_x isEqualType createHashMap) then {_x getOrDefault ["statement", {}]} else {_x param [1, {}, [{}]]};
	private _tooltip = if (_x isEqualType createHashMap) then {_x getOrDefault ["tooltip", _label]} else {_x param [2, _label, [""]]};
	private _condition = if (_x isEqualType createHashMap) then {_x getOrDefault ["condition", {true}]} else {_x param [3, {true}, [{}]]};

	if (_statement isEqualType {} && {_condition isEqualType {}}) then {
		[_label, _statement, _tooltip, _condition] call FUNC(addAppButton);
	};
} forEach (_app getOrDefault ["actions", []]);

uiNamespace setVariable [QGVAR(appBuilderDisplay), displayNull];
uiNamespace setVariable [QGVAR(appBuilderComputer), objNull];
uiNamespace setVariable [QGVAR(appBuilderUser), createHashMap];
uiNamespace setVariable [QGVAR(appBuilderApp), createHashMap];
uiNamespace setVariable [QGVAR(appBuilderGroup), controlNull];
uiNamespace setVariable [QGVAR(appBuilderY), 0];

true
