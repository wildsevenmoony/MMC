#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Applies solid themed button hover colors.
 */

params [
	["_control", controlNull, [controlNull]],
	["_hovered", false, [false]]
];

if (isNull _control) exitWith {};

private _themeConfig = [ctrlParent _control] call FUNC(getThemeConfig);
private _button = _themeConfig getOrDefault ["button", [0.028, 0.032, 0.042, 0.98]];
private _hover = _themeConfig getOrDefault ["buttonHover", [0.07, 0.078, 0.096, 0.98]];

_control ctrlSetBackgroundColor ([_button, _hover] select _hovered);
