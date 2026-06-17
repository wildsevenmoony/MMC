/*
 * MMC Building Blocks Test App Example
 *
 * Usage as a normal computer app:
 * 1. Put this file into your mission folder, for example as buildingBlocksTestApp.sqf.
 * 2. Give the MMC laptop/computer a variable name in Eden.
 * 3. Change the fallback variable below from laptop_test_app to your computer variable.
 * 4. Call this file locally, for example from initPlayerLocal.sqf:
 *    [] execVM "buildingBlocksTestApp.sqf";
 *
 * Usage as a Mobile Profile app script:
 * - Put this path into the Mobile: Profile module's Custom App Script Files field.
 * - MMC passes the mobile device as the first argument, so no fallback variable is needed.
 *
 * This app intentionally avoids unit/UAV/vehicle camera feeds so it works in an empty test mission.
 */

if (!hasInterface) exitWith {};

params [
	["_computer", objNull, [objNull]],
	["_player", objNull, [objNull]],
	["_profile", createHashMap, [createHashMap]]
];

if (isNull _computer) then {
	_computer = missionNamespace getVariable ["laptop_test_app", objNull];
};
if (isNull _computer) exitWith {
	systemChat "MMC Building Blocks Test App: No computer found. Set laptop_test_app or pass a computer object.";
};

private _extra = createHashMapFromArray [
	["tooltip", "Open the MMC building blocks test app."],
	["refreshAfterAction", false]
];

[
	_computer,
	"building-blocks-test",
	"Block Test",
	[
		{
			params ["_computer", "_activeUser", "_app", "_display"];

			[
				"<t size='1.35'>MMC Building Blocks</t><br/>This app touches most reusable app builder controls. It should work on desktop computers and mobile devices."
			] call MMC_fnc_addAppStructuredText;

			[] call MMC_fnc_addAppLine;
			[0.01] call MMC_fnc_addAppSpacer;

			[
				[
					"<t size='1.08'>Status Panel</t><br/>Theme-aware box, nested structured text, nested line, and nested spacer.",
					{["#6ea8ff", 0.002] call MMC_fnc_addAppLine},
					{[0.006] call MMC_fnc_addAppSpacer},
					{"<t color='#9fd8ff'>Nested content is rendered inside its own scrollable group.</t>"}
				],
				"",
				"",
				0.42,
				0.16
			] call MMC_fnc_addAppBox;

			["signal", "Live Signal Strength", 0.35, 0.024, -1, "#4bc06f", "", true, "Animated by a local cleanup-safe loop."] call MMC_fnc_addAppProgressBar;
			["load", "System Load", 0.68, 0.024, -1, "#d6b24a", "", true, "Static progress bar."] call MMC_fnc_addAppProgressBar;

			private _runKey = format ["MMC_TestApp_Running_%1", diag_tickTime];
			_display setVariable [_runKey, true];
			[
				{
					params ["_display", "_key"];
					if (!isNull _display) then {
						_display setVariable [_key, false];
					};
				},
				_runKey
			] call MMC_fnc_addAppCleanup;

			[_display, _runKey] spawn {
				params ["_display", "_key"];
				while {!isNull _display && {_display getVariable [_key, false]}} do {
					private _value = 0.5 + ((sin (diag_tickTime * 70)) * 0.32);
					["signal", _value, format ["%1%2 / pulsing", round (_value * 100), "%"]] call MMC_fnc_setAppProgressBar;
					uiSleep 0.35;
				};
			};

			[0.008] call MMC_fnc_addAppSpacer;
			["#6ea8ff", 0.002] call MMC_fnc_addAppLine;

			["test_name", "Edit Field", "Operator"] call MMC_fnc_addAppEdit;
			[
				"test_check",
				"Checkbox: Enable diagnostic flag",
				true,
				{
					params ["_computer", "_activeUser", "_app", "_display", "_control", "_checked"];
					_computer setVariable ["TAG_mmcTestDiagnosticFlag", _checked];
				}
			] call MMC_fnc_addAppCheckbox;
			[
				"test_mode",
				"Combo Field",
				[["standby", "Standby"], ["active", "Active"], ["locked", "Locked"]],
				"active",
				{
					params ["_computer", "_activeUser", "_app", "_display", "_control", "_value"];
					_computer setVariable ["TAG_mmcTestMode", _value];
				}
			] call MMC_fnc_addAppCombo;

			[
				"Read Values",
				{
					params ["_computer", "_activeUser", "_app", "_display"];
					private _name = ["test_name", ""] call MMC_fnc_getAppControlValue;
					private _flag = ["test_check", false] call MMC_fnc_getAppControlValue;
					private _mode = ["test_mode", ""] call MMC_fnc_getAppControlValue;
					[
						"readout",
						format [
							"<t size='1.05'>Readout</t><br/>Name: %1<br/>Diagnostic: %2<br/>Mode: %3",
							_name,
							["No", "Yes"] select _flag,
							toUpperANSI _mode
						],
						true
					] call MMC_fnc_setAppControlText;
				},
				"Reads the edit, checkbox, and combo values.",
				{true},
				0.17
			] call MMC_fnc_addAppButton;

			[
				{
					private _armed = _computer getVariable ["TAG_mmcTestArmed", false];
					["Arm System", "Disarm System"] select _armed
				},
				{
					params ["_computer"];
					_computer setVariable ["TAG_mmcTestArmed", true];
					["toggle_status", "Disarm System"] call MMC_fnc_setAppControlText;
				},
				{
					params ["_computer"];
					_computer setVariable ["TAG_mmcTestArmed", false];
					["toggle_status", "Arm System"] call MMC_fnc_setAppControlText;
				},
				{true},
				0.17,
				"toggle_status"
			] call MMC_fnc_addAppButton;

			[0.02] call MMC_fnc_addAppSpacer;
			["#6ea8ff", 0.002] call MMC_fnc_addAppLine;
			[0.02] call MMC_fnc_addAppSpacer;

			[
				"color_patch",
				"RscText",
				0.055,
				{
					params ["_control"];
					_control ctrlSetText "Raw RscText color patch";
					_control ctrlSetTooltip "Created through MMC_fnc_addAppControl.";
					_control ctrlSetBackgroundColor [0.10, 0.22, 0.32, 0.82];
					_control ctrlSetTextColor [0.90, 0.96, 1, 1];
				}
			] call MMC_fnc_addAppControl;

			[
				"image_patch",
				"RscPicture",
				0.11,
				{
					params ["_control"];
					_control ctrlSetText "#(argb,8,8,3)color(0.08,0.16,0.22,1)";
					_control ctrlSetTooltip "Raw RscPicture placeholder.";
				},
				0.22
			] call MMC_fnc_addAppControl;

			[0.5] call MMC_fnc_addAppSpacer;
			[
				"<t color='#9fb6d8'>End of test app. The last spacer is intentional, so scrolling can be checked on compact mobile screens.</t>",
				0.055
			] call MMC_fnc_addAppStructuredText;
		}
	],
	[],
	_extra
] call MMC_fnc_addApp;

"building-blocks-test"
