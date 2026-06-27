#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Shows a local MMC notification and plays the mobile notification sound.
 *
 * Arguments:
 * 0: Notification type <STRING>
 * 1: Sender/source name <STRING>
 * 2: Subject or preview <STRING>
 *
 * Return Value:
 * Shown <BOOL>
 */

params [
	["_type", "message", [""]],
	["_from", "Unknown", [""]],
	["_preview", "", [""]]
];

private _title = switch (toLowerANSI _type) do {
	case "mail": {"New Mail"};
	case "message": {"New Message"};
	default {"MMC Notification"};
};

private _notificationSize = switch (toLowerANSI _type) do {
	case "mail": {2.5};
	case "message": {1.5};
	default {2.5};
};

private _escape = {
	params [["_text", "", [""]]];
	_text = _text splitString "&" joinString "&amp;";
	_text = _text splitString "<" joinString "&lt;";
	_text = _text splitString ">" joinString "&gt;";
	_text = _text splitString (toString [13, 10]) joinString " ";
	_text = _text splitString (toString [10]) joinString " ";
	if (count _text > 96) then {
		_text = (_text select [0, 93]) + "...";
	};
	_text
};
_from = [_from] call _escape;
_preview = [_preview] call _escape;
if ((toLowerANSI _type) isEqualTo "message") then {
	_preview = "";
};

private _line = if (_preview isEqualTo "") then {
	format ["%1 from %2", _title, _from]
} else {
	format ["%1 from %2<br/><t size='0.85'>%3</t>", _title, _from, _preview]
};

[_line, _notificationSize, player, 12] call ace_common_fnc_displayTextStructured;
if (GVAR(notificationSoundEnabled)) then {
	playSound ([
		QGVAR(phoneVibrate),
		QGVAR(mailNotification)
	] select ((toLowerANSI _type) isEqualTo "mail"));
};

if ((toLowerANSI _type) isEqualTo "mail") then {
	[{
		private _display = uiNamespace getVariable [QGVAR(display), displayNull];
		if (isNull _display) exitWith {};
		if ((_display getVariable [QGVAR(currentApp), ""]) isNotEqualTo "mail") exitWith {};
		if ((_display getVariable [QGVAR(mailMode), "table"]) isNotEqualTo "table") exitWith {};
		if ((_display getVariable [QGVAR(mailFolder), "inbox"]) isNotEqualTo "inbox") exitWith {};

		private _computer = _display getVariable [QGVAR(computer), objNull];
		if (isNull _computer) exitWith {};
		_display setVariable [QGVAR(data), _computer getVariable [QGVAR(data), createHashMap]];
		["table"] call FUNC(renderMail);
		if (_display getVariable [QGVAR(isMobileDisplay), false]) then {
			[_display] call FUNC(applyMobileDisplayLayout);
		};
	}, [], 0.25] call CBA_fnc_waitAndExecute;
};

true
