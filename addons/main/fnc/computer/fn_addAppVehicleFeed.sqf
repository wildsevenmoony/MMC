#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a live vehicle camera feed to the currently rendering scripted app.
 *
 * Arguments:
 * 0: Value id <STRING>
 * 1: Vehicle object <OBJECT>
 * 2: Height <NUMBER, default: 0.34>
 * 3: Label text <STRING, default: "">
 * 4: Mode: auto, driver, gunner, commander, rear, or custom <STRING, default: "auto">
 * 5: Options <HASHMAP, default: createHashMap>
 *    - widthRatio: Width as portion of the app body <NUMBER, default: 1>
 *    - width: Exact control width, overrides widthRatio <NUMBER, default: -1>
 *    - align: left, center, or right <STRING, default: "left">
 *    - updateInterval: Camera refresh interval <NUMBER, default: 0.016>
 *    - renderSize: Render target size <NUMBER, default: 512>
 *    - followTurretAim: Use selected turret weapon/seat view direction <BOOL, default: true>
 *    - turretPath: Turret path to follow, for example [0] <ARRAY, default: auto>
 *    - positionMemory: Camera position memory point <STRING, default: config value>
 *    - directionMemory: Camera direction memory point <STRING, default: config value>
 *    - directionYaw: Additional local yaw correction in degrees <NUMBER, default: 0>
 *
 * Return Value:
 * Created picture control <CONTROL>
 *
 * Example:
 * ["feed", hunter_1, 0.36, "Hunter Turret", "gunner"] call MMC_fnc_addAppVehicleFeed
 */

params [
	["_id", "vehicleFeed", [""]],
	["_vehicle", objNull, [objNull]],
	["_height", 0.34, [0]],
	["_label", "", [""]],
	["_mode", "auto", [""]],
	["_options", createHashMap, [createHashMap]]
];

private _display = uiNamespace getVariable [QGVAR(appBuilderDisplay), displayNull];
private _group = uiNamespace getVariable [QGVAR(appBuilderGroup), controlNull];
if (isNull _display || {isNull _group}) exitWith {controlNull};

if (_label isNotEqualTo "") then {
	[format ["<t size='1.05' font='RobotoCondensedBold'>%1</t>", _label], 0.04] call FUNC(addAppStructuredText);
};

if (isNull _vehicle || {!alive _vehicle}) exitWith {
	["<t color='#ff8888'>Vehicle feed unavailable.</t>", 0.055] call FUNC(addAppStructuredText)
};

private _modeLower = toLowerANSI _mode;
private _cfg = configOf _vehicle;
private _posMem = _options getOrDefault ["positionMemory", ""];
private _dirMem = _options getOrDefault ["directionMemory", ""];
private _useCameraMemoryPair = _posMem isNotEqualTo "" && {_dirMem isNotEqualTo ""};

if (_posMem isEqualTo "" && {_dirMem isEqualTo ""}) then {
	private _seatName = switch (_modeLower) do {
		case "driver": {"Driver"};
		case "gunner": {"Gunner"};
		case "turret": {"Gunner"};
		default {""};
	};

	if (_seatName isNotEqualTo "") then {
		_posMem = getText (_cfg >> format ["uavCamera%1Pos", _seatName]);
		_dirMem = getText (_cfg >> format ["uavCamera%1Dir", _seatName]);
		_useCameraMemoryPair = _posMem isNotEqualTo "" && {_dirMem isNotEqualTo ""};
	};

	if (_modeLower isEqualTo "auto" && {_posMem isEqualTo "" || {_dirMem isEqualTo ""}}) then {
		_posMem = getText (_cfg >> "uavCameraGunnerPos");
		_dirMem = getText (_cfg >> "uavCameraGunnerDir");
		_useCameraMemoryPair = _posMem isNotEqualTo "" && {_dirMem isNotEqualTo ""};
		if (_posMem isEqualTo "" || {_dirMem isEqualTo ""}) then {
			_posMem = getText (_cfg >> "uavCameraDriverPos");
			_dirMem = getText (_cfg >> "uavCameraDriverDir");
			_useCameraMemoryPair = _posMem isNotEqualTo "" && {_dirMem isNotEqualTo ""};
		};
	};
};

private _offset = _options getOrDefault ["offset", switch (_modeLower) do {
	case "driver": {[0, 1.8, 1.45]};
	case "commander": {[0, 0.35, 2.25]};
	case "rear": {[0, -5, 2.0]};
	default {[0, 2.0, 1.8]};
}];
private _targetOffset = _options getOrDefault ["targetOffset", switch (_modeLower) do {
	case "rear": {[0, -12, 1.6]};
	default {[0, 12, 1.5]};
}];

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
private _rttName = format ["mmc_vehicle_%1", _unique];
private _renderSize = round (_options getOrDefault ["renderSize", 512]);
_renderSize = (_renderSize max 128) min 2048;
private _texture = format ["#(argb,%1,%1,1)r2t(%2,1.0)", _renderSize, _rttName];
private _token = format [QGVAR(vehicleFeedActive_%1), _unique];

private _picture = _display ctrlCreate ["RscPicture", _idc, _group];
_picture ctrlSetPosition [_x, _y, _w, _height max 0.1];
_picture ctrlSetText _texture;
_picture ctrlSetBackgroundColor _panel;
_picture ctrlCommit 0;
_picture setVariable [QGVAR(valueType), "vehicleFeed"];
_picture setVariable [QGVAR(valueId), toLowerANSI _id];

[_display, _group, [_x, _y, _w + 0.004, _height max 0.1], _border] call FUNC(createAppBorder);

private _map = _display getVariable [QGVAR(appControlMap), createHashMap];
_map set [toLowerANSI _id, _picture];
_display setVariable [QGVAR(appControlMap), _map];
_display setVariable [_token, true];

private _camera = "camera" camCreate [0, 0, 0];
_camera cameraEffect ["Internal", "Back", _rttName];
_camera camSetFov (_options getOrDefault ["fov", 0.55]);
_camera camCommit 0;

private _pipEffect = _options getOrDefault ["pipEffect", []];
if (_pipEffect isNotEqualTo []) then {
	_rttName setPiPEffect _pipEffect;
};

private _followTurretAim = _options getOrDefault ["followTurretAim", true];
private _turretPath = _options getOrDefault ["turretPath", []];
private _directionYaw = _options getOrDefault ["directionYaw", 0];
private _viewUnit = objNull;
switch (_modeLower) do {
	case "driver": {
		_viewUnit = driver _vehicle;
		if (_turretPath isEqualTo []) then {
			_turretPath = [-1];
		};
	};
	case "turret": {
		_viewUnit = gunner _vehicle;
	};
	case "gunner": {
		_viewUnit = gunner _vehicle;
	};
	case "commander": {
		_viewUnit = commander _vehicle;
	};
	default {
		_viewUnit = gunner _vehicle;
	};
};

if (_turretPath isEqualTo [] && {!isNull _viewUnit} && {!isNil "CBA_fnc_turretPath"}) then {
	_turretPath = _viewUnit call CBA_fnc_turretPath;
};
if (_turretPath isEqualTo [] && {_modeLower in ["auto", "gunner", "turret"]}) then {
	_turretPath = [0];
};

private _fnc_turretConfig = {
	params ["_vehicle", "_turretPath"];

	private _turretCfg = configOf _vehicle;
	{
		private _turrets = configProperties [_turretCfg >> "Turrets", "isClass _x", true];
		if (_x < 0 || {_x >= count _turrets}) exitWith {
			_turretCfg = configNull;
		};
		_turretCfg = _turrets select _x;
	} forEach _turretPath;

	_turretCfg
};

private _turretCfg = if (_turretPath isEqualTo []) then {configNull} else {[_vehicle, _turretPath] call _fnc_turretConfig};
private _opticsMem = if (isNull _turretCfg) then {""} else {getText (_turretCfg >> "memoryPointGunnerOptics")};

if (_posMem isEqualTo "" && {_opticsMem isNotEqualTo ""}) then {
	_posMem = _opticsMem;
};

if (_useCameraMemoryPair) then {
	_camera attachTo [_vehicle, [0, 0, 0], _posMem];
};

private _eh = addMissionEventHandler ["Draw3D", {
	_thisArgs params [
		"_display",
		"_picture",
		"_vehicle",
		"_camera",
		"_token",
		"_posMem",
		"_dirMem",
		"_offset",
		"_targetOffset",
		"_modeLower",
		"_followTurretAim",
		"_turretPath",
		"_directionYaw",
		"_useCameraMemoryPair"
	];

	if (
		isNull _display
		|| {isNull _picture}
		|| {isNull _vehicle}
		|| {!alive _vehicle}
		|| {!(_display getVariable [_token, false])}
	) exitWith {};

	if (_useCameraMemoryPair) exitWith {
		private _dirModel = (_vehicle selectionPosition _posMem) vectorFromTo (_vehicle selectionPosition _dirMem);
		if (_dirModel isEqualTo [0, 0, 0]) then {
			_dirModel = [0, 1, 0];
		};
		if (_directionYaw != 0) then {
			private _dirX = _dirModel select 0;
			private _dirY = _dirModel select 1;
			private _cosYaw = cos _directionYaw;
			private _sinYaw = sin _directionYaw;
			_dirModel = [
				(_dirX * _cosYaw) - (_dirY * _sinYaw),
				(_dirX * _sinYaw) + (_dirY * _cosYaw),
				_dirModel select 2
			];
		};

		private _rightModel = [_dirModel select 1, -(_dirModel select 0), 0];
		private _upModel = _rightModel vectorCrossProduct _dirModel;
		if (_upModel isEqualTo [0, 0, 0]) then {
			_upModel = [0, 0, 1];
		};

		_camera setVectorDirAndUp [_dirModel, _upModel];
	};

	private _posASL = if (_posMem isNotEqualTo "") then {
		_vehicle modelToWorldVisualWorld (_vehicle selectionPosition _posMem)
	} else {
		_vehicle modelToWorldVisualWorld _offset
	};
	private _targetASL = _vehicle modelToWorldVisualWorld _targetOffset;
	private _dir = _posASL vectorFromTo _targetASL;

	if (_followTurretAim) then {
		private _aimDir = [0, 0, 0];
		private _viewUnit = switch (_modeLower) do {
			case "driver": {driver _vehicle};
			case "commander": {commander _vehicle};
			default {gunner _vehicle};
		};

		if (_turretPath isNotEqualTo []) then {
			private _weapon = _vehicle currentWeaponTurret _turretPath;
			if (_weapon isNotEqualTo "") then {
				_aimDir = _vehicle weaponDirection _weapon;
			};
		};

		if (_aimDir isEqualTo [0, 0, 0] && {_modeLower isEqualTo "commander"}) then {
			_aimDir = eyeDirection _vehicle;
		};
		if (_aimDir isEqualTo [0, 0, 0] && {!isNull _viewUnit}) then {
			_aimDir = getCameraViewDirection _viewUnit;
		};
		if (_aimDir isEqualTo [0, 0, 0] && {!isNull _viewUnit}) then {
			_aimDir = eyeDirection _viewUnit;
		};
		if (_aimDir isNotEqualTo [0, 0, 0]) then {
			_dir = _aimDir;
		};
	};

	if (_dir isEqualTo [0, 0, 0]) then {
		_dir = vectorDirVisual _vehicle;
	};

	_camera setPosASL _posASL;
	_camera setVectorDirAndUp [_dir, vectorUpVisual _vehicle];
}, [
	_display,
	_picture,
	_vehicle,
	_camera,
	_token,
	_posMem,
	_dirMem,
	_offset,
	_targetOffset,
	_modeLower,
	_followTurretAim,
	_turretPath,
	_directionYaw,
	_useCameraMemoryPair
]];

[
	{
		params ["_display", "_args"];
		_args params ["_token", "_camera", "_rttName", "_eh"];
		_display setVariable [_token, false];
		removeMissionEventHandler ["Draw3D", _eh];
		detach _camera;
		_camera cameraEffect ["Terminate", "Back", _rttName];
		camDestroy _camera;
	},
	[_token, _camera, _rttName, _eh]
] call FUNC(addAppCleanup);

uiNamespace setVariable [QGVAR(appBuilderY), _y + (_height max 0.1) + 0.018];
_picture
