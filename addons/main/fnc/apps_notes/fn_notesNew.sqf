#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Opens a blank personal note in the Notes app.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

_display setVariable [QGVAR(selectedNoteId), ""];
_display setVariable [QGVAR(selectedNoteSource), "user"];
_display setVariable [QGVAR(notesStatus), ""];
_display setVariable [QGVAR(notesDraftId), "__none"];
_display setVariable [QGVAR(notesDraftSource), "user"];
_display setVariable [QGVAR(notesDraftTitle), ""];
_display setVariable [QGVAR(notesDraftBody), ""];
["render"] call FUNC(renderNotes);
