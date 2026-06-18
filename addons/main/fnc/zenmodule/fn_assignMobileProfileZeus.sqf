#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Assigns a live mobile profile to the unit under the Zeus cursor.
 *
 * Arguments:
 * 0: Module position <ARRAY>
 * 1: Object under cursor <OBJECT>
 *
 * Return Value:
 * None
 */

params [
	["_position", [], [[]]],
	["_objectUnderCursor", objNull, [objNull]]
];

if (isNull _objectUnderCursor || {!(_objectUnderCursor isKindOf "CAManBase")}) exitWith {
	[objNull, "PLACE ON A UNIT"] call BIS_fnc_showCuratorFeedbackMessage;
};

[
	"Assign Mobile Profile",
	[
		["CHECKBOX", ["Add Device", "If checked, the selected unit receives the chosen MMC mobile device item."], false, false],
		[
			"COMBO",
			["Device", "Device item to add when Add Device is checked. The profile also applies to compatible devices taken later."],
			[
				[
					QGVAR(smartphone),
					QGVAR(ruggedTabletBlack),
					QGVAR(ruggedTabletGreen),
					QGVAR(ruggedTabletSand),
					QGVAR(tablet)
				],
				[
					"Smartphone",
					"Rugged Tablet (Black)",
					"Rugged Tablet (Green)",
					"Rugged Tablet (Sand)",
					"Tablet"
				],
				0
			],
			false
		],
		["EDIT", ["E-Mail Address", "Primary mobile e-mail address. Leave empty to use PLAYERNAME@mmcsystems.com."], "", false],
		["EDIT", ["Linked E-Mail Addresses", "Optional comma-separated e-mail aliases linked to the same profile."], "", false],
		["EDIT", ["Messenger Username", "Display name shown in Messenger. Leave empty to use the unit/player name."], "", false],
		[
			"COMBO",
			["Messenger Side", "Side used by Messenger. Auto uses the unit's current side."],
			[
				["", "west", "east", "guer", "civ", "hidden"],
				["Auto (Unit)", "BLUFOR", "OPFOR", "Independent", "Civilian", "Hidden"],
				0
			],
			false
		],
		[
			"COMBO",
			["Theme", "Preset theme for this assigned mobile profile."],
			[
				["default", "nato", "csat", "aaf"],
				["Default", "NATO", "CSAT", "AAF"],
				0
			],
			false
		],
		["EDIT", ["Custom App Script Files", "Optional comma-separated mission or mod SQF files that add custom apps with MMC_fnc_addApp."], "", false],
		["CHECKBOX", ["Files App", "If unchecked, the Files app is hidden for this profile."], true, false],
		["CHECKBOX", ["Mail App", "If unchecked, the Mail app is hidden for this profile."], true, false],
		["CHECKBOX", ["Messenger App", "If unchecked, the Messenger app is hidden for this profile."], true, false],
		["CHECKBOX", ["Notes App", "If unchecked, the Notes app is hidden for this profile."], true, false]
	],
	{
		params ["_dialogValues", "_unit"];
		_dialogValues params [
			"_giveDevice",
			"_deviceClass",
			"_email",
			"_aliasesText",
			"_messengerName",
			"_messengerSide",
			"_theme",
			"_appScriptsText",
			"_filesEnabled",
			"_mailEnabled",
			"_messagesEnabled",
			"_notesEnabled"
		];

		if (isNull _unit) exitWith {
			[objNull, "NO UNIT SELECTED"] call BIS_fnc_showCuratorFeedbackMessage;
		};

		private _splitList = {
			params [["_text", "", [""]]];
			private _list = [];
			{
				private _entry = [_x] call CBA_fnc_trim;
				_entry = _entry splitString """'" joinString "";
				if (_entry isNotEqualTo "") then {
					_list pushBackUnique _entry;
				};
			} forEach (_text splitString ",");
			_list
		};

		private _id = format ["zeus_assigned_%1", netId _unit];
		_id = toLowerANSI (_id splitString ":" joinString "_");
		private _unitName = name _unit;
		_messengerName = [_messengerName] call CBA_fnc_trim;
		if (_messengerName isEqualTo "") then {
			_messengerName = _unitName;
		};
		if (_messengerSide isEqualTo "") then {
			_messengerSide = str (side group _unit);
		};

		private _disabledApps = [];
		if (!_filesEnabled) then {_disabledApps pushBack "files"};
		if (!_mailEnabled) then {_disabledApps pushBack "mail"};
		if (!_messagesEnabled) then {_disabledApps pushBack "messages"};
		if (!_notesEnabled) then {_disabledApps pushBack "notes"};

		private _unitVars = [];
		private _var = vehicleVarName _unit;
		if (_var isNotEqualTo "") then {
			_unitVars pushBack _var;
		};

		private _profile = createHashMapFromArray [
			["id", _id],
			["priority", 150],
			["sources", ["personal"]],
			["units", [_unit]],
			["unitNetIds", [netId _unit] select { _x isNotEqualTo "" }],
			["unitVars", _unitVars],
			["theme", _theme],
			["aliases", [_aliasesText] call _splitList],
			["displayName", _messengerName],
			["messengerName", _messengerName],
			["side", _messengerSide],
			["messengerSide", _messengerSide],
			["disabledApps", _disabledApps],
			["appScripts", [_appScriptsText] call _splitList]
		];
		_email = [_email] call CBA_fnc_trim;
		if (_email isNotEqualTo "") then {
			_profile set ["primaryEmail", _email];
		};

		private _assignedProfiles = _unit getVariable [QGVAR(assignedMobileProfileIds), []];
		if !(_assignedProfiles isEqualType []) then {
			_assignedProfiles = [];
		};
		_assignedProfiles pushBackUnique _id;
		_unit setVariable [QGVAR(assignedMobileProfileIds), _assignedProfiles, true];

		private _assignedConfigs = _unit getVariable [QGVAR(assignedMobileProfileConfigs), []];
		if !(_assignedConfigs isEqualType []) then {
			_assignedConfigs = [];
		};
		private _assignedProfile = +_profile;
		_assignedProfile deleteAt "units";
		private _configIndex = _assignedConfigs findIf {
			_x isEqualType createHashMap && {toLowerANSI (_x getOrDefault ["id", ""]) isEqualTo _id}
		};
		if (_configIndex < 0) then {
			_assignedConfigs pushBack _assignedProfile;
		} else {
			_assignedConfigs set [_configIndex, _assignedProfile];
		};
		_unit setVariable [QGVAR(assignedMobileProfileConfigs), _assignedConfigs, true];

		[_id, _profile] call FUNC(registerMobileProfile);
		[_id, _profile] remoteExecCall [QFUNC(registerMobileProfile), 0, format [QGVAR(mobileProfile_%1), _id]];

		if (_giveDevice && {_deviceClass isNotEqualTo ""}) then {
			[_unit, _deviceClass] call FUNC(addMobileDeviceItemLocal);
		};

		["Zeus", "Assigned mobile profile", createHashMapFromArray [
			["unit", format ["%1:%2", name _unit, typeOf _unit]],
			["id", _id],
			["email", _email],
			["aliases", _profile getOrDefault ["aliases", []]],
			["messengerName", _messengerName],
			["messengerSide", _messengerSide],
			["theme", _theme],
			["giveDevice", _giveDevice],
			["deviceClass", _deviceClass]
		]] call FUNC(debugLog);

		[objNull, "MOBILE PROFILE ASSIGNED"] call BIS_fnc_showCuratorFeedbackMessage;
	},
	{},
	_objectUnderCursor
] call zen_dialog_fnc_create;
