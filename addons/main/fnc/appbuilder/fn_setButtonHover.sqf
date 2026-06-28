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
if (!isNull (_control getVariable [QGVAR(launcherBackground), controlNull])) exitWith {};

private _themeConfig = [ctrlParent _control] call FUNC(getThemeConfig);
private _button = _control getVariable [QGVAR(buttonColor), _themeConfig getOrDefault ["button", [0.028, 0.032, 0.042, 0.98]]];
private _hover = _control getVariable [QGVAR(buttonHoverColor), _themeConfig getOrDefault ["buttonHover", [0.07, 0.078, 0.096, 0.98]]];
private _buttonText = _control getVariable [QGVAR(buttonTextColor), _themeConfig getOrDefault ["buttonText", [0.92, 0.94, 0.97, 1]]];
private _hoverText = _control getVariable [QGVAR(buttonHoverTextColor), _themeConfig getOrDefault ["buttonHoverText", _buttonText]];

_control ctrlSetBackgroundColor ([_button, _hover] select _hovered);
_control ctrlSetTextColor ([_buttonText, _hoverText] select _hovered);
_control ctrlSetActiveColor ([_buttonText, _hoverText] select _hovered);

private _icon = _control getVariable [QGVAR(mobileIconControl), controlNull];
if (!isNull _icon) then {
	private _iconPath = _control getVariable [[QGVAR(mobileIconPath), QGVAR(mobileIconHoverPath)] select _hovered, ""];
	if (_iconPath isNotEqualTo "") then {
		_icon ctrlSetText _iconPath;
	};
	_icon ctrlSetTextColor ([_buttonText, _hoverText] select _hovered);
};
