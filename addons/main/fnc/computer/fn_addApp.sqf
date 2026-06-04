#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds or updates a scripted mission app on a registered MMC computer.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: App id <STRING>
 * 2: Display name <STRING>
 * 3: Content text, code, or code/text array <STRING, CODE, or ARRAY, default: "">
 * 4: Actions <ARRAY, default: []>
 * 5: Extra config <HASHMAP, default: createHashMap>
 * 6: Public object variable <BOOL, default: false>
 *
 * Return Value:
 * Added <BOOL>
 */

params [
	["_object", objNull, [objNull]],
	["_id", "", [""]],
	["_label", "", [""]],
	["_content", "", ["", {}, []]],
	["_actions", [], [[]]],
	["_extra", createHashMap, [createHashMap]],
	["_public", false, [false]]
];

if (isNull _object) exitWith {false};
if (_id isEqualTo "") exitWith {false};

private _safeId = toLowerANSI _id;
private _reserved = ["desktop", "files", "mail", "messages", "notes", "select"];
if (_safeId in _reserved) exitWith {false};

private _app = createHashMap;
{
	_app set [_x, _extra get _x];
} forEach keys _extra;

_app set ["id", _safeId];
_app set ["label", [_label, _id] select (_label isEqualTo "")];
_app set ["content", _content];
_app set ["actions", _actions];
_app set ["source", "script"];

private _apps = _object getVariable [QGVAR(customApps), []];
if !(_apps isEqualType []) then {
	_apps = [];
};

private _index = _apps findIf {toLowerANSI (_x getOrDefault ["id", ""]) isEqualTo _safeId};
if (_index < 0) then {
	_apps pushBack _app;
} else {
	_apps set [_index, _app];
};

_object setVariable [QGVAR(customApps), _apps, _public];

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (!isNull _display && {_object isEqualTo (_display getVariable [QGVAR(computer), objNull])}) then {
	[_display] call FUNC(refreshAppButtons);
};

true
