#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Resolves the in-world computer screen texture for an object and state.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: Screen state <STRING>
 * 2: Screen aspect <STRING>
 *
 * Return Value:
 * Texture path <STRING>
 */

params [
	["_object", objNull, [objNull]],
	["_state", "powered_off", [""]],
	["_aspect", "1x1", [""]]
];

private _rawState = toLowerANSI _state;
if (_rawState isEqualTo "broken" || {_object getVariable [QGVAR(destroyed), false]}) exitWith {
	format ["\z\mmc\addons\main\img\screen_%1_broken.paa", _aspect]
};

if (_rawState isEqualTo "powered_off") exitWith {"#(argb,8,8,3)color(0,0,0,0,co)"};

private _screenState = switch (_rawState) do {
	case "startup": {"startup"};
	case "login": {"login"};
	case "desktop": {"desktop"};
	case "power_down": {"shutdown"};
	default {"desktop"};
};

private _profileTheme = toLowerANSI (missionNamespace getVariable [QGVAR(profileTheme), "dark"]);
if !(_profileTheme in ["dark", "light"]) then {
	_profileTheme = "dark";
};

private _normalizeTheme = {
	params [["_value", "default", [""]], ["_fallback", "dark", [""]]];

	private _normalized = toLowerANSI _value;
	private _normalizedFallback = ["default", "default_light"] select ((toLowerANSI _fallback) isEqualTo "light");
	switch (_normalized) do {
		case "": {_normalizedFallback};
		case "default": {_normalizedFallback};
		case "dark": {"default"};
		case "default_dark": {"default"};
		case "light": {"default_light"};
		case "default_light": {"default_light"};
		case "blufor": {"nato"};
		case "opfor": {"csat"};
		case "independent": {"aaf"};
		default {
			["default", _normalized] select (_normalized in ["nato", "csat", "aaf"]);
		};
	};
};

private _data = _object getVariable [QGVAR(data), createHashMap];
private _activeUser = [_object] call FUNC(getActiveUser);
private _layout = createHashMap;
private _theme = "default";

if (count _activeUser > 0) then {
	_theme = _activeUser getOrDefault ["theme", _activeUser getOrDefault ["background", "default"]];
	_layout = _activeUser getOrDefault ["customLayout", createHashMap];
} else {
	private _users = (_data getOrDefault ["users", []]) select {_x isEqualType createHashMap};
	private _directUsers = _users select {(_x getOrDefault ["scope", "global"]) isEqualTo "direct"};

	if (_directUsers isNotEqualTo []) then {
		private _preferredIndex = _directUsers findIf {
			private _userLayout = _x getOrDefault ["customLayout", createHashMap];
			private _themeValue = toLowerANSI (_x getOrDefault ["theme", _x getOrDefault ["background", "default"]]);
			(_userLayout isEqualType createHashMap && {count _userLayout > 0}) || {!(_themeValue in ["", "default", "default_dark", "default_light", "dark", "light"])}
		};
		if (_preferredIndex < 0) then {
			_preferredIndex = 0;
		};

		private _directUser = _directUsers select _preferredIndex;
		_theme = _directUser getOrDefault ["theme", _directUser getOrDefault ["background", "default"]];
		_layout = _directUser getOrDefault ["customLayout", createHashMap];
	} else {
		_layout = _data getOrDefault ["layout", _object getVariable [QGVAR(computerLayout), createHashMap]];
	};
};

if !(_layout isEqualType createHashMap) then {
	_layout = createHashMap;
};

if (count _layout > 0) then {
	_theme = _layout getOrDefault ["preset", _theme];

	private _screenTextures = _layout getOrDefault [format ["screenTextures%1", _aspect], createHashMap];
	if (_screenTextures isEqualType createHashMap) then {
		private _customTexture = _screenTextures getOrDefault [_screenState, ""];
		if (_customTexture isNotEqualTo "") exitWith {_customTexture};
	};
};

private _themeName = [_theme, _profileTheme] call _normalizeTheme;
format ["\z\mmc\addons\main\img\screen_%1_%2_%3.paa", _themeName, _aspect, _screenState]
