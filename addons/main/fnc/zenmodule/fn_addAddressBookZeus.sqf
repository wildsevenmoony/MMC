#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds an address book entry to registered users through Zeus.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 */

[
	"Add Mail Address to Address Book",
	[
		["EDIT", ["Username", "Target username. Leave empty to add to all registered users."], "", false],
		["EDIT", ["Display Name", "Name shown in the address book. Leave empty to derive it from the e-mail address."], "", false],
		["EDIT", ["E-Mail Address", "Address to add."], "contact@mmcsystems.com", false]
	],
	{
		params ["_dialogValues"];
		_dialogValues params ["_username", "_name", "_email"];
		_username = toLowerANSI ([_username] call CBA_fnc_trim);
		private _targets = 0;
		{
			private _computer = _x;
			if (!isNull _computer) then {
				private _data = _computer getVariable [QGVAR(data), createHashMap];
				private _users = _data getOrDefault ["users", []];
				private _changed = false;
				{
					private _user = _x;
					if (_username isEqualTo "" || {toLowerANSI (_user getOrDefault ["username", ""]) isEqualTo _username}) then {
						if ([_user, _name, _email] call FUNC(addAddressBookEntry)) then {
							_users set [_forEachIndex, _user];
							_changed = true;
							_targets = _targets + 1;
						};
					};
				} forEach _users;
				if (_changed) then {
					_data set ["users", _users];
					_computer setVariable [QGVAR(data), _data, true];
				};
			};
		} forEach ([] call FUNC(getRegisteredComputers));
		[objNull, format ["ADDRESS ADDED TO %1 USER(S)", _targets]] call BIS_fnc_showCuratorFeedbackMessage;
	},
	{}
] call zen_dialog_fnc_create;
