/*
 * MMC UAV Info App Example
 *
 * Usage:
 * 1. Put this file into your mission folder, for example as uavInfoApp.sqf.
 * 2. Give the MMC laptop and UAVs variable names in Eden.
 * 3. Change the _computer and _uavs values below.
 * 4. Call this file locally, for example from initPlayerLocal.sqf:
 *    [] execVM "uavInfoApp.sqf";
 *
 * The app is local on purpose because custom app callbacks and PiP cameras are local UI code.
 */

if (!hasInterface) exitWith {};

private _computer = missionNamespace getVariable ["laptop_uav_ops", objNull];
if (isNull _computer) exitWith {};

private _uavs = [
	["uav_darter_1", "Darter 1"],
	["uav_darter_2", "Darter 2"],
	["uav_greyhawk_1", "Greyhawk 1"]
];

private _extra = createHashMapFromArray [
	["refreshAfterAction", false],
	["uavs", _uavs]
];

[
	_computer,
	"uav-info",
	"UAV Info",
	[
		{
			params ["_computer", "_activeUser", "_app", "_display"];

			private _uavs = _app getOrDefault ["uavs", []];
			private _selectedVar = _computer getVariable ["TAG_selectedUavFeed", ""];
			private _selectedLabel = "No UAV selected";
			private _selectedUav = objNull;

			{
				_x params ["_varName", "_label"];
				private _uav = missionNamespace getVariable [_varName, objNull];
				private _alive = !isNull _uav && {alive _uav};
				private _buttonText = format ["%1%2", ["", "> "] select (_varName isEqualTo _selectedVar), _label];

				private _button = [
					_buttonText,
					{
						params ["_computer", "_activeUser", "_app", "_display", "_control"];

						private _varName = _control getVariable ["TAG_uavVarName", ""];
						_computer setVariable ["TAG_selectedUavFeed", _varName];
						[format ["custom:%1", _app getOrDefault ["id", ""]]] call MMC_fnc_renderApp;
					},
					format ["Show %1 pilot-camera feed.", _label],
					{true},
					0.18
				] call MMC_fnc_addAppButton;
				if (!isNull _button) then {
					_button setVariable ["TAG_uavVarName", _varName];
				};

				if (_varName isEqualTo _selectedVar) then {
					_selectedLabel = _label;
					_selectedUav = _uav;
				};
			} forEach _uavs;

			[0.012] call MMC_fnc_addAppSpacer;
			["#6ea8ff", 0.002] call MMC_fnc_addAppLine;

			private _status = if (isNull _selectedUav) then {
				if (_selectedVar isEqualTo "") then {
					"Select a UAV feed above."
				} else {
					format ["%1 is not available.", _selectedLabel]
				}
			} else {
				format [
					"<t size='1.05'>%1</t><br/>Status: %2<br/>Position: %3",
					_selectedLabel,
					["Offline", "Online"] select (alive _selectedUav),
					mapGridPosition _selectedUav
				]
			};
			[_status, 0.085] call MMC_fnc_addAppStructuredText;

			if (!isNull _selectedUav && {alive _selectedUav}) then {
				["uavFeed", _selectedUav, 0.38, "Pilot Camera"] call MMC_fnc_addAppUavFeed;
			};
		}
	],
	[],
	_extra
] call MMC_fnc_addApp;
