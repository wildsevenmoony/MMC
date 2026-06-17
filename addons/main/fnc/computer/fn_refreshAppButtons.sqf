#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Rebuilds dynamic program buttons for scripted mission apps.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 */

params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {};

[_display, true, false] call FUNC(clearCustomControls);

private _computer = _display getVariable [QGVAR(computer), objNull];
if (isNull _computer) exitWith {};

private _apps = _computer getVariable [QGVAR(customApps), []];
if !(_apps isEqualType []) exitWith {};

if (_display getVariable [QGVAR(isMobileDisplay), false]) exitWith {
	private _validApps = _apps select {
		_x isEqualType createHashMap
		&& {(_x getOrDefault ["id", ""]) isNotEqualTo ""}
	};
	_display setVariable [QGVAR(customAppButtonCount), count _validApps];
};

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _button = _themeConfig getOrDefault ["button", [0.028, 0.032, 0.042, 0.98]];
private _buttonHover = _themeConfig getOrDefault ["buttonHover", [0.07, 0.078, 0.096, 0.98]];
private _buttonText = _themeConfig getOrDefault ["buttonText", [0.92, 0.94, 0.97, 1]];
private _buttonHoverText = _themeConfig getOrDefault ["buttonHoverText", _buttonText];
private _border = _themeConfig getOrDefault ["border", [0, 0, 0, 0.85]];

private _controls = [];
private _step = 0.055;
private _standardCount = _display getVariable [QGVAR(standardAppButtonCount), 4];
private _startY = safeZoneY + 0.09 + (_standardCount * _step);
private _maxButtons = 8;
private _nextY = _startY;

private _colorToHtml = {
	params [["_color", [1, 1, 1, 1], [[]]]];

	private _digits = "0123456789ABCDEF";
	private _out = "#";
	{
		private _value = round (((_x max 0) min 1) * 255);
		private _hi = floor (_value / 16);
		private _lo = _value mod 16;
		_out = _out + (_digits select [_hi, 1]) + (_digits select [_lo, 1]);
	} forEach [_color param [0, 1], _color param [1, 1], _color param [2, 1]];

	_out
};

private _formatLabel = {
	params [["_label", "", [""]], ["_color", "#FFFFFF", [""]]];

	format ["<t align='center' font='RobotoCondensed' shadow='0' size='1' color='%1'>%2</t>", _color, _label]
};

private _wrapLabel = {
	params [["_label", "", [""]], ["_maxChars", 11, [0]]];

	private _words = _label splitString " ";
	private _lines = [];

	if ((count _words) <= 1) then {
		private _remaining = _label;
		while {(count _remaining) > _maxChars} do {
			_lines pushBack (_remaining select [0, _maxChars]);
			_remaining = _remaining select [_maxChars];
		};
		if (_remaining isNotEqualTo "") then {
			_lines pushBack _remaining;
		};
	} else {
		private _current = "";
		{
			private _word = _x;
			if ((count _word) > _maxChars) then {
				if (_current isNotEqualTo "") then {
					_lines pushBack _current;
					_current = "";
				};
				private _remaining = _word;
				while {(count _remaining) > _maxChars} do {
					_lines pushBack (_remaining select [0, _maxChars]);
					_remaining = _remaining select [_maxChars];
				};
				if (_remaining isNotEqualTo "") then {
					_current = _remaining;
				};
			} else {
				private _candidate = [_word, format ["%1 %2", _current, _word]] select (_current isNotEqualTo "");
				if ((count _candidate) > _maxChars) then {
					if (_current isNotEqualTo "") then {
						_lines pushBack _current;
					};
					_current = _word;
				} else {
					_current = _candidate;
				};
			};
		} forEach _words;
		if (_current isNotEqualTo "") then {
			_lines pushBack _current;
		};
	};

	if (_lines isEqualTo []) then {
		_lines = [_label];
	};

	[_lines joinString "<br/>", count _lines]
};

{
	if (_forEachIndex < _maxButtons) then {
		private _id = _x getOrDefault ["id", ""];
		if (_id isNotEqualTo "") then {
			private _rawLabel = _x getOrDefault ["label", _id];
			private _wrapped = [_rawLabel] call _wrapLabel;
			_wrapped params ["_buttonLabel", "_lineCount"];
			private _buttonH = 0.05 max (0.028 + (_lineCount * 0.026));
			private _y = _nextY;
			private _labelColor = [_buttonText] call _colorToHtml;
			private _labelHoverColor = [_buttonHoverText] call _colorToHtml;
			private _backgroundCtrl = _display ctrlCreate ["RscText", [_display] call FUNC(nextDynamicIdc)];
			_backgroundCtrl ctrlSetPosition [safeZoneX + 0.035, _y, 0.105, _buttonH];
			_backgroundCtrl ctrlSetText "";
			_backgroundCtrl ctrlSetBackgroundColor _button;
			_backgroundCtrl ctrlCommit 0;

			private _labelCtrl = _display ctrlCreate ["RscStructuredText", [_display] call FUNC(nextDynamicIdc)];
			_labelCtrl ctrlSetPosition [safeZoneX + 0.039, _y + 0.003, 0.097, _buttonH - 0.006];
			_labelCtrl ctrlSetBackgroundColor [0, 0, 0, 0];
			_labelCtrl ctrlSetTextColor _buttonText;
			_labelCtrl ctrlSetStructuredText parseText ([_buttonLabel, _labelColor] call _formatLabel);
			_labelCtrl ctrlSetTooltip (_x getOrDefault ["tooltip", format ["Open %1.", _rawLabel]]);
			_labelCtrl ctrlCommit 0;

			private _buttonCtrl = _display ctrlCreate [QGVAR(RscComputerButton), [_display] call FUNC(nextDynamicIdc)];
			_buttonCtrl ctrlSetPosition [safeZoneX + 0.035, _y, 0.105, _buttonH];
			_buttonCtrl ctrlSetText "";
			_buttonCtrl ctrlSetTooltip (_x getOrDefault ["tooltip", format ["Open %1.", _rawLabel]]);
			_buttonCtrl ctrlSetBackgroundColor [0, 0, 0, 0];
			_buttonCtrl ctrlSetTextColor [0, 0, 0, 0];
			_buttonCtrl ctrlSetActiveColor [0, 0, 0, 0];
			_buttonCtrl setVariable [QGVAR(appId), _id];
			_buttonCtrl setVariable [QGVAR(launcherBackground), _backgroundCtrl];
			_buttonCtrl setVariable [QGVAR(launcherLabel), _labelCtrl];
			_buttonCtrl setVariable [QGVAR(launcherButton), _button];
			_buttonCtrl setVariable [QGVAR(launcherButtonHover), _buttonHover];
			_buttonCtrl setVariable [QGVAR(launcherText), _buttonText];
			_buttonCtrl setVariable [QGVAR(launcherTextHover), _buttonHoverText];
			_buttonCtrl setVariable [QGVAR(launcherLabelText), _buttonLabel];
			_buttonCtrl setVariable [QGVAR(launcherLabelColor), _labelColor];
			_buttonCtrl setVariable [QGVAR(launcherLabelHoverColor), _labelHoverColor];
			_buttonCtrl ctrlAddEventHandler ["MouseEnter", {
				params ["_control"];
				private _background = _control getVariable [QGVAR(launcherBackground), controlNull];
				private _label = _control getVariable [QGVAR(launcherLabel), controlNull];
				private _labelText = _control getVariable [QGVAR(launcherLabelText), ""];
				private _hoverColor = _control getVariable [QGVAR(launcherLabelHoverColor), "#FFFFFF"];
				if (!isNull _background) then {
					_background ctrlSetBackgroundColor (_control getVariable [QGVAR(launcherButtonHover), [0.07, 0.078, 0.096, 0.98]]);
				};
				if (!isNull _label) then {
					_label ctrlSetTextColor (_control getVariable [QGVAR(launcherTextHover), [0.92, 0.94, 0.97, 1]]);
					_label ctrlSetStructuredText parseText format ["<t align='center' font='RobotoCondensed' shadow='0' size='1' color='%1'>%2</t>", _hoverColor, _labelText];
				};
			}];
			_buttonCtrl ctrlAddEventHandler ["MouseExit", {
				params ["_control"];
				private _background = _control getVariable [QGVAR(launcherBackground), controlNull];
				private _label = _control getVariable [QGVAR(launcherLabel), controlNull];
				private _labelText = _control getVariable [QGVAR(launcherLabelText), ""];
				private _labelColor = _control getVariable [QGVAR(launcherLabelColor), "#FFFFFF"];
				if (!isNull _background) then {
					_background ctrlSetBackgroundColor (_control getVariable [QGVAR(launcherButton), [0.028, 0.032, 0.042, 0.98]]);
				};
				if (!isNull _label) then {
					_label ctrlSetTextColor (_control getVariable [QGVAR(launcherText), [0.92, 0.94, 0.97, 1]]);
					_label ctrlSetStructuredText parseText format ["<t align='center' font='RobotoCondensed' shadow='0' size='1' color='%1'>%2</t>", _labelColor, _labelText];
				};
			}];
			_buttonCtrl ctrlAddEventHandler ["ButtonClick", {
				params ["_control"];
				[format ["custom:%1", _control getVariable [QGVAR(appId), ""]]] call MMC_fnc_renderApp;
			}];
			_buttonCtrl ctrlCommit 0;

			private _borderControls = [_display, controlNull, [safeZoneX + 0.035, _y, 0.107, _buttonH], _border] call FUNC(createAppBorder);

			_controls pushBack _backgroundCtrl;
			_controls pushBack _labelCtrl;
			_controls pushBack _buttonCtrl;
			_controls append _borderControls;
			_nextY = _nextY + _buttonH + 0.005;
		};
	};
} forEach _apps;

_display setVariable [QGVAR(customAppControls), _controls];
