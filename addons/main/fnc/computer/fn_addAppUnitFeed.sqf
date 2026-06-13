#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a live unit helmet-camera style feed to the currently rendering scripted app.
 *
 * Arguments:
 * 0: Value id <STRING>
 * 1: Unit object <OBJECT>
 * 2: Height <NUMBER, default: 0.34>
 * 3: Label text <STRING, default: "">
 * 4: Options <HASHMAP, default: createHashMap>
 *    - widthRatio: Width as portion of the app body <NUMBER, default: 1>
 *    - width: Exact control width, overrides widthRatio <NUMBER, default: -1>
 *    - align: left, center, or right <STRING, default: "left">
 *    - updateInterval: Camera refresh interval <NUMBER, default: 0.01>
 *    - renderSize: Render target size <NUMBER, default: 512>
 *
 * Return Value:
 * Created picture control <CONTROL>
 *
 * Example:
 * ["feed", alpha_1, 0.36, "Alpha 1"] call MMC_fnc_addAppUnitFeed
 */

params [
	["_id", "unitFeed", [""]],
	["_unit", objNull, [objNull]],
	["_height", 0.34, [0]],
	["_label", "", [""]],
	["_options", createHashMap, [createHashMap]]
];

private _display = uiNamespace getVariable [QGVAR(appBuilderDisplay), displayNull];
private _group = uiNamespace getVariable [QGVAR(appBuilderGroup), controlNull];
if (isNull _display || {isNull _group}) exitWith {controlNull};

if (_label isNotEqualTo "") then {
	[format ["<t size='1.05' font='RobotoCondensedBold'>%1</t>", _label], 0.04] call FUNC(addAppStructuredText);
};

if (isNull _unit || {!alive _unit || {!(_unit isKindOf "CAManBase")}}) exitWith {
	["<t color='#ff8888'>Unit feed unavailable.</t>", 0.055] call FUNC(addAppStructuredText)
};

private _themeConfig = [_display] call FUNC(getThemeConfig);
private _panel = _themeConfig getOrDefault ["panelStrong", [0.01, 0.012, 0.018, 0.98]];
private _border = _themeConfig getOrDefault ["border", [0, 0, 0, 0.85]];
private _groupW = (ctrlPosition _group) select 2;
private _availableW = _groupW - 0.045;
private _w = _options getOrDefault ["width", -1];
if (_w <= 0) then {
	_w = _availableW * ((_options getOrDefault ["widthRatio", 1]) max 0.1 min 1);
} else {
	_w = _w min _availableW;
};
private _align = toLowerANSI (_options getOrDefault ["align", "left"]);
private _x = _options getOrDefault ["x", switch (_align) do {
	case "center": {0.015 + ((_availableW - _w) / 2)};
	case "right": {0.015 + (_availableW - _w)};
	default {0.015};
}];
private _y = uiNamespace getVariable [QGVAR(appBuilderY), 0.015];
private _idc = [_display] call FUNC(nextDynamicIdc);
private _unique = format ["%1_%2", _idc, floor random 100000];
private _rttName = format ["mmc_unit_%1", _unique];
private _renderSize = round (_options getOrDefault ["renderSize", 512]);
_renderSize = (_renderSize max 128) min 2048;
private _texture = format ["#(argb,%1,%1,1)r2t(%2,1.0)", _renderSize, _rttName];
private _token = format [QGVAR(unitFeedActive_%1), _unique];

private _picture = _display ctrlCreate ["RscPicture", _idc, _group];
_picture ctrlSetPosition [_x, _y, _w, _height max 0.1];
_picture ctrlSetText _texture;
_picture ctrlSetBackgroundColor _panel;
_picture ctrlCommit 0;
_picture setVariable [QGVAR(valueType), "unitFeed"];
_picture setVariable [QGVAR(valueId), toLowerANSI _id];

[_display, _group, [_x, _y, _w + 0.004, _height max 0.1], _border] call FUNC(createAppBorder);

private _map = _display getVariable [QGVAR(appControlMap), createHashMap];
_map set [toLowerANSI _id, _picture];
_display setVariable [QGVAR(appControlMap), _map];
_display setVariable [_token, true];

private _camera = "camera" camCreate [0, 0, 0];
_camera cameraEffect ["Internal", "Back", _rttName];
_camera camSetFov (_options getOrDefault ["fov", 0.7]);
_camera camCommit 0;

private _pipEffect = _options getOrDefault ["pipEffect", []];
if (_pipEffect isNotEqualTo []) then {
	_rttName setPiPEffect _pipEffect;
};

[
	{
		params ["_display", "_args"];
		_args params ["_token"];
		_display setVariable [_token, false];
	},
	[_token]
] call FUNC(addAppCleanup);

[
	_display,
	_picture,
	_unit,
	_camera,
	_rttName,
	_token,
	_options getOrDefault ["offset", [0.08, 0.06, 0.08]],
	_options getOrDefault ["fallbackHeight", 1.62],
	(_options getOrDefault ["updateInterval", 0.01]) max 0.001
] spawn {
	params ["_display", "_picture", "_unit", "_camera", "_rttName", "_token", "_offset", "_fallbackHeight", "_updateInterval"];

	while {
		!isNull _display
		&& {!isNull _picture}
		&& {!isNull _unit}
		&& {alive _unit}
		&& {_display getVariable [_token, false]}
	} do {
		private _head = _unit selectionPosition "Head";
		if (_head isEqualTo [0, 0, 0]) then {
			_head = [0, 0, _fallbackHeight];
		};

		private _posASL = _unit modelToWorldWorld (_head vectorAdd _offset);
		private _dir = getCameraViewDirection _unit;
		if (_dir isEqualTo [0, 0, 0]) then {
			_dir = eyeDirection _unit;
		};
		if (_dir isEqualTo [0, 0, 0]) then {
			_dir = vectorDir _unit;
		};

		_camera setPosASL _posASL;
		_camera setVectorDirAndUp [_dir, vectorUp _unit];

		uiSleep _updateInterval;
	};

	_camera cameraEffect ["Terminate", "Back", _rttName];
	camDestroy _camera;
};

uiNamespace setVariable [QGVAR(appBuilderY), _y + (_height max 0.1) + 0.018];
_picture
