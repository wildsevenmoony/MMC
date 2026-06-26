#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Normalizes address book input into unique name/e-mail hashmap entries.
 *
 * Arguments:
 * 0: Entries <ARRAY or STRING>
 *
 * Return Value:
 * Address book entries <ARRAY>
 */

params [["_entries", [], [[], ""]]];

if (_entries isEqualType "") then {
	_entries = _entries splitString ",;";
};

private _out = [];
{
	private _name = "";
	private _email = "";
	if (_x isEqualType createHashMap) then {
		_name = [_x getOrDefault ["name", ""]] call CBA_fnc_trim;
		_email = [_x getOrDefault ["email", ""]] call CBA_fnc_trim;
	} else {
		private _text = [_x] call CBA_fnc_trim;
		if (_text isNotEqualTo "") then {
			private _lt = _text find "<";
			private _gt = _text find ">";
			if (_lt >= 0 && {_gt > _lt}) then {
				_name = [_text select [0, _lt]] call CBA_fnc_trim;
				_email = [_text select [_lt + 1, _gt - _lt - 1]] call CBA_fnc_trim;
			} else {
				_email = _text;
			};
		};
	};
	if (_email isNotEqualTo "" && {_email find "@" >= 0}) then {
		if (_name isEqualTo "") then {
			_name = (_email splitString "@") param [0, _email];
		};
		private _lookup = toLowerANSI _email;
		private _index = _out findIf {toLowerANSI (_x getOrDefault ["email", ""]) isEqualTo _lookup};
		private _entry = createHashMapFromArray [
			["name", _name],
			["email", _email]
		];
		if (_index < 0) then {
			_out pushBack _entry;
		} else {
			_out set [_index, _entry];
		};
	};
} forEach _entries;

_out
