#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Toggles the mobile MMC display between horizontal and vertical layouts.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * New orientation <STRING>
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {GVAR(mobileOrientation)};

private _orientation = _display getVariable [QGVAR(mobileOrientation), GVAR(mobileOrientation)];
_orientation = ["vertical", "horizontal"] select (_orientation isEqualTo "vertical");
_display setVariable [QGVAR(mobileOrientation), _orientation];

private _computer = _display getVariable [QGVAR(computer), objNull];
if (!isNull _computer) then {
	_computer setVariable [QGVAR(mobileDefaultOrientation), _orientation, true];
	[_computer, _orientation] remoteExecCall [QFUNC(setMobileOrientationServer), 2];
};

if (_display getVariable [QGVAR(mobileLockScreen), false]) exitWith {
	[_display] call FUNC(applyMobileDisplayLayout);
	_orientation
};

private _currentApp = _display getVariable [QGVAR(currentApp), ""];
if (_currentApp isEqualTo "notes") then {
	private _titleControl = _display getVariable [QGVAR(notesTitleControl), controlNull];
	private _bodyControl = _display getVariable [QGVAR(notesBodyControl), controlNull];
	if (!isNull _titleControl && {!isNull _bodyControl}) then {
		_display setVariable [QGVAR(notesDraftId), _display getVariable [QGVAR(selectedNoteId), ""]];
		_display setVariable [QGVAR(notesDraftSource), _display getVariable [QGVAR(selectedNoteSource), "user"]];
		_display setVariable [QGVAR(notesDraftTitle), ctrlText _titleControl];
		_display setVariable [QGVAR(notesDraftBody), ctrlText _bodyControl];
	};
};
if (_currentApp in ["files", "messages", "notes"] || {(_currentApp select [0, 7]) isEqualTo "custom:"}) then {
	private _paneSelection = ["", "customApps"] select (_display getVariable [QGVAR(mobileCustomAppsOpen), false]);
	if (_display getVariable [QGVAR(mobileNavOpen), false]) then {
		_paneSelection = "nav";
	};
	_display setVariable [QGVAR(mobilePaneSelection), _paneSelection];
	if (_currentApp isEqualTo "messages") then {
		[_display] call FUNC(applyMobileDisplayLayout);
	};
	if (_currentApp isEqualTo "files") then {
		["select", [controlNull, -1]] call FUNC(renderApp);
	} else {
		[_currentApp] call FUNC(renderApp);
	};
} else {
	[_display] call FUNC(applyMobileDisplayLayout);
};

_orientation
