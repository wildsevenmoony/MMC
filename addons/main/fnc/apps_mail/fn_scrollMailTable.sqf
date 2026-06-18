#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Moves the mobile mail table between readable column pages.
 *
 * Arguments:
 * 0: Direction, negative for left and positive for right <NUMBER>
 *
 * Return Value:
 * New column page <NUMBER>
 */

private _args = if (_this isEqualType []) then {_this} else {[_this]};
_args params [["_direction", 0, [0]]];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display || {!(_display getVariable [QGVAR(isMobileDisplay), false])}) exitWith {0};

private _page = _display getVariable [QGVAR(mobileMailTablePage), 0];
_page = ((_page + ([1, -1] select (_direction < 0))) max 0) min 1;
_display setVariable [QGVAR(mobileMailTablePage), _page];
[_display] call FUNC(applyMobileDisplayLayout);

_page
