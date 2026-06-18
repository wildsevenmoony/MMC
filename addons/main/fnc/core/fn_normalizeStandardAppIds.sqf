#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Normalizes standard MMC app ids and aliases.
 *
 * Arguments:
 * 0: App id or app ids <STRING or ARRAY>
 *
 * Return Value:
 * Normalized app ids <ARRAY>
 */

params [["_apps", [], ["", []]]];

if (_apps isEqualType "") then {
	_apps = [_apps];
};

private _result = [];
{
	private _app = if (_x isEqualType "") then {_x} else {str _x};
	_app = toLowerANSI _app;

	private _normalized = switch (_app) do {
		case "file";
		case "files": {"files"};
		case "mail";
		case "email";
		case "e-mail": {"mail"};
		case "message";
		case "messages";
		case "messenger": {"messages"};
		case "note";
		case "notes": {"notes"};
		default {""};
	};

	if (_normalized isNotEqualTo "") then {
		_result pushBackUnique _normalized;
	};
} forEach _apps;

_result
