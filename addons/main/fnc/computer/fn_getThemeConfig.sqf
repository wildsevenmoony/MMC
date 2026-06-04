#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Resolves the effective MMC theme, layout colors, and desktop background.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * Theme config <HASHMAP>
 */

params [["_display", displayNull, [displayNull]]];

private _profileTheme = toLowerANSI (missionNamespace getVariable [QGVAR(profileTheme), "dark"]);
if !(_profileTheme in ["dark", "light"]) then {
	_profileTheme = "dark";
};

private _computer = objNull;
private _activeUser = createHashMap;
if (!isNull _display) then {
	_computer = _display getVariable [QGVAR(computer), objNull];
	_activeUser = [_computer] call FUNC(getActiveUser);
};

private _computerLayout = createHashMap;
if (count _activeUser == 0 && {!isNull _computer}) then {
	private _data = _computer getVariable [QGVAR(data), createHashMap];
	private _users = (_data getOrDefault ["users", []]) select {_x isEqualType createHashMap};
	private _directUsers = _users select {(_x getOrDefault ["scope", "global"]) isEqualTo "direct"};

	if (_directUsers isNotEqualTo []) then {
		private _preferredIndex = _directUsers findIf {
			private _layout = _x getOrDefault ["customLayout", createHashMap];
			private _themeValue = toLowerANSI (_x getOrDefault ["theme", _x getOrDefault ["background", "default"]]);
			(_layout isEqualType createHashMap && {count _layout > 0}) || {!(_themeValue in ["", "default", "default_dark", "default_light", "dark", "light"])}
		};
		if (_preferredIndex < 0) then {
			_preferredIndex = 0;
		};
		_activeUser = _directUsers select _preferredIndex;
	} else {
		_computerLayout = _data getOrDefault ["layout", _computer getVariable [QGVAR(computerLayout), createHashMap]];
		if !(_computerLayout isEqualType createHashMap) then {
			_computerLayout = createHashMap;
		};
	};
};

private _theme = _activeUser getOrDefault ["theme", _activeUser getOrDefault ["background", "default"]];
private _customLayout = _activeUser getOrDefault ["customLayout", createHashMap];
if !(_customLayout isEqualType createHashMap) then {
	_customLayout = createHashMap;
};

if (count _activeUser == 0 && {count _computerLayout > 0}) then {
	_customLayout = _computerLayout;
	_theme = _customLayout getOrDefault ["preset", "default"];
};

if (count _customLayout == 0) then {
	private _legacyForceTheme = _activeUser getOrDefault ["forceTheme", ""];
	if (_legacyForceTheme isNotEqualTo "") then {
		_theme = _legacyForceTheme;
	};
} else {
	_theme = _customLayout getOrDefault ["preset", _theme];
};

private _normalizeTheme = {
	params [["_value", "default", [""]], ["_fallback", "dark", [""]]];

	private _normalized = toLowerANSI _value;
	switch (_normalized) do {
		case "";
		case "default": {_fallback};
		case "default_dark": {"dark"};
		case "default_light": {"light"};
		case "blufor": {"nato"};
		case "opfor": {"csat"};
		case "independent": {"aaf"};
		case "civilian": {_fallback};
		case "user": {_fallback};
		default {
			[_fallback, _normalized] select (_normalized in ["dark", "light", "nato", "csat", "aaf", "fia"]);
		};
	};
};

private _useCustomColors = _customLayout getOrDefault ["useCustomColors", false];
private _backgroundThemeName = [_theme, _profileTheme] call _normalizeTheme;
private _themeName = [_backgroundThemeName, "dark"] select _useCustomColors;
private _isLight = _themeName isEqualTo "light";

private _config = createHashMapFromArray [
	["theme", _themeName],
	["isLight", _isLight],
	["desktop", [0.035, 0.075, 0.115, 1]],
	["panel", [0.02, 0.025, 0.035, 0.94]],
	["panelStrong", [0.015, 0.018, 0.024, 0.98]],
	["text", [0.92, 0.94, 0.97, 1]],
	["tint", [0, 0, 0, 0]],
	["button", [0.028, 0.032, 0.042, 0.98]],
	["buttonHover", [0.07, 0.078, 0.096, 0.98]],
	["buttonText", [0.92, 0.94, 0.97, 1]],
	["bootAccent", [0.13, 0.54, 0.21, 0.95]],
	["border", [0, 0, 0, 0.85]],
	["bootBarBg", [1, 1, 1, 0.22]],
	["powerBackground", [0, 0, 0, 0.96]]
];

switch (_themeName) do {
	case "light": {
		_config set ["desktop", [0.9, 0.92, 0.94, 1]];
		_config set ["panel", [0.98, 0.985, 0.99, 0.94]];
		_config set ["panelStrong", [0.84, 0.86, 0.88, 0.98]];
		_config set ["text", [0.035, 0.04, 0.05, 1]];
		_config set ["button", [0.88, 0.895, 0.91, 0.98]];
		_config set ["buttonHover", [0.76, 0.78, 0.81, 0.98]];
		_config set ["buttonText", [0.035, 0.04, 0.05, 1]];
		_config set ["bootAccent", [0.18, 0.24, 0.32, 0.98]];
		_config set ["border", [0.1, 0.12, 0.14, 0.75]];
		_config set ["bootBarBg", [0.08, 0.1, 0.12, 0.18]];
		_config set ["powerBackground", [0.9, 0.92, 0.94, 0.96]];
	};
	case "nato": {
		_config set ["desktop", [0.004, 0.02, 0.045, 1]];
		_config set ["panel", [0.006, 0.03, 0.07, 0.94]];
		_config set ["panelStrong", [0, 0.267, 0.6, 0.98]];
		_config set ["button", [0, 0.333, 0.706, 0.98]];
		_config set ["buttonHover", [0.08, 0.42, 0.8, 0.98]];
		_config set ["bootAccent", [0, 0.333, 0.706, 0.95]];
		_config set ["border", [0, 0, 0.08, 0.9]];
	};
	case "csat": {
		_config set ["desktop", [0.045, 0.004, 0.004, 1]];
		_config set ["panel", [0.07, 0.01, 0.01, 0.94]];
		_config set ["panelStrong", [0.576, 0, 0, 0.98]];
		_config set ["button", [0.886, 0, 0, 0.98]];
		_config set ["buttonHover", [1, 0.13, 0.13, 0.98]];
		_config set ["bootAccent", [0.886, 0, 0, 0.95]];
		_config set ["border", [0.12, 0, 0, 0.9]];
	};
	case "aaf": {
		_config set ["desktop", [0.004, 0.04, 0.004, 1]];
		_config set ["panel", [0.008, 0.06, 0.008, 0.94]];
		_config set ["panelStrong", [0, 0.42, 0, 0.98]];
		_config set ["button", [0, 0.561, 0, 0.98]];
		_config set ["buttonHover", [0.12, 0.66, 0.12, 0.98]];
		_config set ["bootAccent", [0, 0.561, 0, 0.95]];
		_config set ["border", [0, 0.1, 0, 0.9]];
	};
};

private _parseHexColor = {
	params [["_value", "", [""]], ["_alpha", 1, [0]]];

	private _text = toUpperANSI (trim _value);
	if (_text isEqualTo "") exitWith {[]};
	if ((_text select [0, 1]) isEqualTo "#") then {
		_text = _text select [1];
	};
	if ((_text select [0, 2]) isEqualTo "0X") then {
		_text = _text select [2];
	};
	if !((count _text) in [6, 8]) exitWith {[]};

	private _digits = "0123456789ABCDEF";
	private _pair = {
		params ["_pairText", "_digits"];
		private _chars = toArray _pairText;
		private _hi = _digits find (toString [_chars param [0, 0]]);
		private _lo = _digits find (toString [_chars param [1, 0]]);
		if (_hi < 0 || {_lo < 0}) exitWith {-1};
		((_hi * 16) + _lo) / 255
	};

	private _red = [_text select [0, 2], _digits] call _pair;
	private _green = [_text select [2, 2], _digits] call _pair;
	private _blue = [_text select [4, 2], _digits] call _pair;
	private _outAlpha = _alpha;

	if (_red < 0 || {_green < 0 || {_blue < 0}}) exitWith {[]};
	if ((count _text) == 8) then {
		_outAlpha = [_text select [6, 2], _digits] call _pair;
		if (_outAlpha < 0) exitWith {[]};
	};

	[_red, _green, _blue, _outAlpha]
};

if (_useCustomColors) then {
	private _colors = _customLayout getOrDefault ["colors", createHashMap];
	if (_colors isEqualType createHashMap) then {
		private _applyColor = {
			params ["_config", "_colors", "_configKey", "_colorKey", "_alpha", "_parseHexColor"];
			private _parsed = [_colors getOrDefault [_colorKey, ""], _alpha] call _parseHexColor;
			if (_parsed isNotEqualTo []) then {
				_config set [_configKey, _parsed];
			};
		};

		[_config, _colors, "desktop", "desktop", 1, _parseHexColor] call _applyColor;
		[_config, _colors, "panel", "panel", 0.94, _parseHexColor] call _applyColor;
		[_config, _colors, "panelStrong", "panelStrong", 0.98, _parseHexColor] call _applyColor;
		[_config, _colors, "button", "button", 0.98, _parseHexColor] call _applyColor;
		[_config, _colors, "buttonHover", "buttonHover", 0.98, _parseHexColor] call _applyColor;
		[_config, _colors, "bootAccent", "accent", 0.95, _parseHexColor] call _applyColor;
		[_config, _colors, "text", "text", 1, _parseHexColor] call _applyColor;
		[_config, _colors, "border", "border", 0.85, _parseHexColor] call _applyColor;
		_config set ["buttonText", _config getOrDefault ["text", [0.92, 0.94, 0.97, 1]]];
	};
};

private _background = _customLayout getOrDefault ["background", ""];
if (_background isEqualTo "") then {
	_background = _backgroundThemeName;
};
_config set ["backgroundTexture", [_background] call FUNC(getBackgroundPath)];

_config
