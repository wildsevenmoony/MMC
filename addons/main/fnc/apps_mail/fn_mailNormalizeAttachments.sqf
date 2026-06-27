#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Normalizes legacy single attachment fields and new attachment arrays.
 *
 * Arguments:
 * 0: Legacy attachment path <STRING>
 * 1: Legacy attachment description <STRING>
 * 2: Attachment array <ARRAY>
 *
 * Return Value:
 * Normalized attachment array <ARRAY>
 */

params [
	["_attachment", "", [""]],
	["_attachmentDescription", "", [""]],
	["_attachments", [], [[]]]
];

private _normalized = [];
{
	if (_x isEqualType createHashMap) then {
		private _entry = +_x;
		private _name = [_entry getOrDefault ["name", ""]] call CBA_fnc_trim;
		private _path = [_entry getOrDefault ["path", ""]] call CBA_fnc_trim;
		private _texture = [_entry getOrDefault ["texture", ""]] call CBA_fnc_trim;
		if (_name isEqualTo "") then {
			private _source = [_path, _texture] select (_path isEqualTo "");
			private _parts = _source splitString "\/";
			_name = _parts param [((count _parts) - 1) max 0, "attachment"];
			_entry set ["name", _name];
		};
		if (_path isNotEqualTo "" || {_texture isNotEqualTo "" || {(_entry getOrDefault ["content", ""]) isNotEqualTo ""}}) then {
			_normalized pushBack _entry;
		};
	};
} forEach _attachments;

_attachment = [_attachment] call CBA_fnc_trim;
if (_normalized isEqualTo [] && {_attachment isNotEqualTo ""}) then {
	private _parts = _attachment splitString "\/";
	private _name = _parts param [((count _parts) - 1) max 0, "attachment.paa"];
	_normalized pushBack createHashMapFromArray [
		["name", _name],
		["type", "picture"],
		["path", format ["\Pictures\%1", _name]],
		["content", [_attachmentDescription] call FUNC(normalizeStructuredText)],
		["texture", _attachment]
	];
};

_normalized
