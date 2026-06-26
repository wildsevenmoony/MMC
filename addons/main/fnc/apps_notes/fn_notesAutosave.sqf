#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Debounces and silently saves the currently edited personal note.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Scheduled <BOOL>
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display || {!GVAR(notesAutosaveEnabled)}) exitWith {false};

private _generation = (_display getVariable [QGVAR(notesAutosaveGeneration), 0]) + 1;
_display setVariable [QGVAR(notesAutosaveGeneration), _generation];

private _titleControl = _display getVariable [QGVAR(notesTitleControl), controlNull];
private _bodyControl = _display getVariable [QGVAR(notesBodyControl), controlNull];
if (!isNull _titleControl && {!isNull _bodyControl}) then {
	_display setVariable [QGVAR(notesDraftId), _display getVariable [QGVAR(selectedNoteId), ""]];
	_display setVariable [QGVAR(notesDraftSource), _display getVariable [QGVAR(selectedNoteSource), "user"]];
	_display setVariable [QGVAR(notesDraftTitle), ctrlText _titleControl];
	_display setVariable [QGVAR(notesDraftBody), ctrlText _bodyControl];
};

[{
	params ["_display", "_generation"];
	if (
		!isNull _display
		&& {(_display getVariable [QGVAR(notesAutosaveGeneration), -1]) isEqualTo _generation}
		&& {(_display getVariable [QGVAR(currentApp), ""]) isEqualTo "notes"}
	) then {
		[false, false, false] call MMC_fnc_notesSave;
	};
}, [_display, _generation], 1.25] call CBA_fnc_waitAndExecute;

true
