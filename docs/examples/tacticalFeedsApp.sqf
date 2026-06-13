/*
 * MMC Tactical Feeds App Example
 *
 * Usage:
 * 1. Put this file into your mission folder, for example as tacticalFeedsApp.sqf.
 * 2. Give the MMC laptop, units, UAVs, and vehicles variable names in Eden.
 * 3. Change the _computer and _feeds values below.
 * 4. Call this file locally, for example from initPlayerLocal.sqf:
 *    [] execVM "tacticalFeedsApp.sqf";
 *
 * Feed types:
 * - "unit": helmet/body style camera from a unit's head position.
 * - "uav": UAV pilot camera.
 * - "vehicle": vehicle camera. Mode can be auto, driver, gunner, commander, rear, or custom.
 *
 * Optional feed settings:
 * - widthRatio: 0.1 to 1, where 1 uses the full content width.
 * - align: left, center, or right.
 * - turretPath: explicit turret path, for example [0] for many vanilla gunner seats.
 * - positionMemory / directionMemory: explicit camera memory points for vehicles with unusual configs.
 * - directionYaw: camera direction correction in degrees if a model's camera axis is offset.
 */

if (!hasInterface) exitWith {};

private _computer = missionNamespace getVariable ["laptop_tactical_feeds", objNull];
if (isNull _computer) exitWith {};

private _feeds = [
	["unit", "alpha_1", "Alpha 1 Headcam"],
	["unit", "alpha_2", "Alpha 2 Headcam"],
	["uav", "uav_darter_1", "Darter 1"],
	["vehicle", "hunter_1", "Hunter Turret", "gunner"],
	["vehicle", "ifv_1", "IFV Commander", "commander"]
];

private _extra = createHashMapFromArray [
	["refreshAfterAction", false],
	["feeds", _feeds]
];

[
	_computer,
	"tactical-feeds",
	"Tactical Feeds",
	[
		{
			params ["_computer", "_activeUser", "_app", "_display"];

			private _feeds = _app getOrDefault ["feeds", []];
			private _selected = _computer getVariable ["TAG_selectedTacticalFeed", []];

			if (_selected isEqualTo [] && {_feeds isNotEqualTo []}) then {
				_selected = _feeds select 0;
				_computer setVariable ["TAG_selectedTacticalFeed", _selected];
			};

			{
				private _feed = _x;
				_feed params ["_type", "_varName", "_label"];
				private _isSelected = _feed isEqualTo _selected;
				private _button = [
					format ["%1%2", ["", "> "] select _isSelected, _label],
					{
						params ["_computer", "_activeUser", "_app", "_display", "_control"];

						_computer setVariable ["TAG_selectedTacticalFeed", _control getVariable ["TAG_feedData", []]];
						[format ["custom:%1", _app getOrDefault ["id", ""]]] call MMC_fnc_renderApp;
					},
					format ["Show %1.", _label],
					{true},
					0.22
				] call MMC_fnc_addAppButton;

				if (!isNull _button) then {
					_button setVariable ["TAG_feedData", _feed];
				};
			} forEach _feeds;

			[0.012] call MMC_fnc_addAppSpacer;
			["#6ea8ff", 0.002] call MMC_fnc_addAppLine;

			if (_selected isEqualTo []) exitWith {
				["No feeds configured.", 0.06] call MMC_fnc_addAppStructuredText;
			};

			_selected params ["_type", "_varName", "_label", ["_mode", "auto"]];
			private _target = missionNamespace getVariable [_varName, objNull];
			private _status = if (isNull _target) then {
				format ["%1 is unavailable.", _label]
			} else {
				format [
					"<t size='1.05'>%1</t><br/>Type: %2<br/>Status: %3<br/>Grid: %4",
					_label,
					toUpper _type,
					["Offline", "Online"] select (alive _target),
					mapGridPosition _target
				]
			};
			[_status, 0.09] call MMC_fnc_addAppStructuredText;

			if (isNull _target || {!alive _target}) exitWith {};

			private _options = createHashMapFromArray [
				["widthRatio", 0.86],
				["align", "center"]
			];

			switch (toLowerANSI _type) do {
				case "unit": {
					_options set ["updateInterval", 0.01];
					["feed", _target, 0.38, "Helmet Camera", _options] call MMC_fnc_addAppUnitFeed;
				};
				case "uav": {
					_options set ["turretPath", [0]];
					["feed", _target, 0.38, "UAV Camera", _options] call MMC_fnc_addAppUavFeed;
				};
				case "vehicle": {
					if ((toLowerANSI _mode) isEqualTo "commander") then {
						_options set ["offset", [0, 0.35, 2.35]];
						_options set ["targetOffset", [0, 14, 2.0]];
						_options set ["fov", 0.5];
					};
					["feed", _target, 0.38, "Vehicle Camera", _mode, _options] call MMC_fnc_addAppVehicleFeed;
				};
			};
		}
	],
	[],
	_extra
] call MMC_fnc_addApp;
