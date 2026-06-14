#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Builds a layout config from a Layout module logic.
 *
 * Arguments:
 * 0: Layout module logic <OBJECT>
 *
 * Return Value:
 * Layout config <HASHMAP>
 */

params [["_logic", objNull, [objNull]]];

if (isNull _logic) exitWith {createHashMap};

private _colors = createHashMapFromArray [
	["desktop", _logic getVariable [QGVAR(customLayoutDesktopColor), ""]],
	["panel", _logic getVariable [QGVAR(customLayoutPanelColor), ""]],
	["panelStrong", _logic getVariable [QGVAR(customLayoutPanelStrongColor), ""]],
	["button", _logic getVariable [QGVAR(customLayoutButtonColor), ""]],
	["buttonHover", _logic getVariable [QGVAR(customLayoutButtonHoverColor), ""]],
	["accent", _logic getVariable [QGVAR(customLayoutAccentColor), ""]],
	["text", _logic getVariable [QGVAR(customLayoutTextColor), ""]],
	["border", _logic getVariable [QGVAR(customLayoutBorderColor), ""]]
];

private _screenTextures1x1 = createHashMapFromArray [
	["login", _logic getVariable [QGVAR(customLayoutScreen1x1Login), ""]],
	["desktop", _logic getVariable [QGVAR(customLayoutScreen1x1Desktop), ""]],
	["startup", _logic getVariable [QGVAR(customLayoutScreen1x1Startup), ""]],
	["shutdown", _logic getVariable [QGVAR(customLayoutScreen1x1Shutdown), ""]]
];

private _screenTextures2x1 = createHashMapFromArray [
	["login", _logic getVariable [QGVAR(customLayoutScreen2x1Login), ""]],
	["desktop", _logic getVariable [QGVAR(customLayoutScreen2x1Desktop), ""]],
	["startup", _logic getVariable [QGVAR(customLayoutScreen2x1Startup), ""]],
	["shutdown", _logic getVariable [QGVAR(customLayoutScreen2x1Shutdown), ""]]
];

private _screenSelections = [];
private _screenSelectionsText = _logic getVariable [QGVAR(customLayoutScreenSelections), ""];
if (_screenSelectionsText isEqualType "" && {_screenSelectionsText isNotEqualTo ""}) then {
	{
		private _part = [_x] call CBA_fnc_trim;
		private _digits = toArray _part;
		if (_digits isNotEqualTo [] && {_digits findIf {_x < 48 || {_x > 57}} < 0}) then {
			private _selection = floor (parseNumber _part);
			if (_selection >= 0) then {
				_screenSelections pushBackUnique _selection;
			};
		};
	} forEach (_screenSelectionsText splitString ",");
};

createHashMapFromArray [
	["preset", _logic getVariable [QGVAR(customLayoutPreset), "default"]],
	["useCustomColors", _logic getVariable [QGVAR(customLayoutUseCustomColors), false]],
	["background", _logic getVariable [QGVAR(customLayoutBackground), ""]],
	["colors", _colors],
	["applyScreenTextures", _logic getVariable [QGVAR(customLayoutApplyScreenTextures), true]],
	["screenSelections", _screenSelections],
	["screenTextures1x1", _screenTextures1x1],
	["screenTextures2x1", _screenTextures2x1]
]
