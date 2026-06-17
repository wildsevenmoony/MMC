#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds a live UAV pilot-camera feed to the currently rendering scripted app.
 *
 * Arguments:
 * 0: Value id <STRING>
 * 1: UAV object <OBJECT>
 * 2: Height <NUMBER, default: 0.34>
 * 3: Label text <STRING, default: "">
 * 4: Options <HASHMAP, default: createHashMap>
 *    - widthRatio: Width as portion of the app body <NUMBER, default: 1>
 *    - width: Exact control width, overrides widthRatio <NUMBER, default: -1>
 *    - align: left, center, or right <STRING, default: "left">
 *    - updateInterval: Camera refresh interval <NUMBER, default: 0.016>
 *    - renderSize: Render target size <NUMBER, default: 512>
 *    - turretPath: Turret path used as fallback aim direction <ARRAY, default: [0]>
 *    - followTurretAim: Use selected turret weapon/seat view direction <BOOL, default: true>
 *    - cameraMode: auto, turret, pilot, memory, or fallback <STRING, default: auto>
 *    - preferPilotCamera: Prefer getPilotCameraPosition/Direction when available <BOOL, default: false>
 *    - positionMemory: Camera position memory point <STRING, default: config value>
 *    - directionMemory: Camera direction memory point <STRING, default: config value>
 *    - directionYaw: Additional local yaw correction in degrees <NUMBER, default: 0>
 *
 * Return Value:
 * Created picture control <CONTROL>
 *
 * Example:
 * ["feed", uav_1, 0.36, "Darter 1"] call MMC_fnc_addAppUavFeed
 */

params [
	["_id", "uavFeed", [""]],
	["_uav", objNull, [objNull]],
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

if (isNull _uav || {!alive _uav}) exitWith {
	["<t color='#ff8888'>UAV feed unavailable.</t>", 0.055] call FUNC(addAppStructuredText)
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
private _rttName = format ["mmc_uav_%1", _unique];
private _requestedRenderSize = round (_options getOrDefault ["renderSize", 512]);
private _renderSize = 512;
{
	if (_requestedRenderSize >= _x) then {
		_renderSize = _x;
	};
} forEach [128, 256, 512, 1024, 2048];
private _texture = format ["#(argb,%1,%1,1)r2t(%2,1.0)", _renderSize, _rttName];
private _token = format [QGVAR(uavFeedActive_%1), _unique];

private _picture = _display ctrlCreate ["RscPicture", _idc, _group];
_picture ctrlSetPosition [_x, _y, _w, _height max 0.1];
_picture ctrlSetText _texture;
_picture ctrlSetTextColor [1, 1, 1, 1];
_picture ctrlSetBackgroundColor _panel;
_picture ctrlCommit 0;
_picture setVariable [QGVAR(valueType), "uavFeed"];
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

private _turretPath = _options getOrDefault ["turretPath", [0]];
private _posMem = _options getOrDefault ["positionMemory", getText (configOf _uav >> "uavCameraGunnerPos")];
private _dirMem = _options getOrDefault ["directionMemory", getText (configOf _uav >> "uavCameraGunnerDir")];
private _directionYaw = _options getOrDefault ["directionYaw", 0];
private _cameraMode = toLowerANSI (_options getOrDefault ["cameraMode", "auto"]);
if !(_cameraMode in ["auto", "turret", "pilot", "memory", "fallback"]) then {
	_cameraMode = "auto";
};
private _preferPilotCamera = _options getOrDefault ["preferPilotCamera", false];
if (_cameraMode isEqualTo "pilot") then {
	_preferPilotCamera = true;
};
private _followTurretAim = _options getOrDefault ["followTurretAim", true];
if (_cameraMode isEqualTo "turret") then {
	_followTurretAim = true;
	_preferPilotCamera = false;
};
if (_cameraMode in ["memory", "fallback"]) then {
	_followTurretAim = false;
	_preferPilotCamera = false;
};
private _useMemoryPoints = _posMem isNotEqualTo "" && {_dirMem isNotEqualTo ""};

private _eh = addMissionEventHandler ["Draw3D", {
	_thisArgs params [
		"_display",
		"_picture",
		"_uav",
		"_camera",
		"_token",
		"_turretPath",
		"_posMem",
		"_dirMem",
		"_directionYaw",
		"_cameraMode",
		"_preferPilotCamera",
		"_followTurretAim",
		"_useMemoryPoints"
	];

	if (
		isNull _display
		|| {isNull _picture}
		|| {isNull _uav}
		|| {!alive _uav}
		|| {!(_display getVariable [_token, false])}
	) exitWith {};

	private _fnc_applyYaw = {
		params [
			["_dir", [0, 1, 0], [[]]],
			["_yaw", 0, [0]]
		];

		if (_yaw == 0) exitWith {_dir};

		private _dirX = _dir select 0;
		private _dirY = _dir select 1;
		private _cosYaw = cos _yaw;
		private _sinYaw = sin _yaw;

		[
			(_dirX * _cosYaw) - (_dirY * _sinYaw),
			(_dirX * _sinYaw) + (_dirY * _cosYaw),
			_dir select 2
		]
	};

	private _fnc_modelDirectionToWorld = {
		params [
			["_uav", objNull, [objNull]],
			["_dirModel", [0, 1, 0], [[]]],
			["_directionYaw", 0, [0]]
		];

		if (_dirModel isEqualTo [0, 0, 0]) then {
			_dirModel = [0, 1, 0];
		};

		_dirModel = [_dirModel, _directionYaw] call _fnc_applyYaw;
		private _rightModel = [_dirModel select 1, -(_dirModel select 0), 0];
		private _upModel = _rightModel vectorCrossProduct _dirModel;
		if (_upModel isEqualTo [0, 0, 0]) then {
			_upModel = [0, 0, 1];
		};

		[
			_uav vectorModelToWorldVisual _dirModel,
			_uav vectorModelToWorldVisual _upModel
		]
	};

	private _fnc_applyCamera = {
		params [
			["_camera", objNull, [objNull]],
			["_posASL", [0, 0, 0], [[]]],
			["_dir", [0, 1, 0], [[]]],
			["_up", [0, 0, 1], [[]]]
		];

		if (_dir isEqualTo [0, 0, 0]) then {
			_dir = [0, 1, 0];
		};
		if (_up isEqualTo [0, 0, 0]) then {
			_up = [0, 0, 1];
		};

		_camera setPosASL _posASL;
		_camera setVectorDirAndUp [_dir, _up];
	};

	private _hasPilotCamera = hasPilotCamera _uav;
	private _posModel = [0, 2, 0.5];
	private _posFound = false;

	if (_useMemoryPoints && {_cameraMode in ["auto", "turret", "memory"]}) then {
		private _memoryPosModel = _uav selectionPosition [_posMem, "Memory"];
		if (_memoryPosModel isNotEqualTo [0, 0, 0]) then {
			_posModel = _memoryPosModel;
			_posFound = true;
		};
	};

	if (!_posFound && _hasPilotCamera && {_cameraMode in ["auto", "turret", "pilot", "memory"]}) then {
		private _pilotPosModel = getPilotCameraPosition _uav;
		if (_pilotPosModel isNotEqualTo [0, 0, 0]) then {
			_posModel = _pilotPosModel;
			_posFound = true;
		};
	};

	private _posASL = _uav modelToWorldVisualWorld _posModel;
	private _dir = [0, 0, 0];
	private _up = vectorUpVisual _uav;
	private _directionYawApplied = false;

	if (_preferPilotCamera && {_cameraMode isEqualTo "pilot"} && _hasPilotCamera) then {
		([_uav, getPilotCameraDirection _uav, _directionYaw] call _fnc_modelDirectionToWorld) params ["_pilotDir", "_pilotUp"];
		[_camera, _posASL, _pilotDir, _pilotUp] call _fnc_applyCamera;
	} else {
	if (_followTurretAim && {_cameraMode in ["auto", "turret"]}) then {
		private _weapon = "";
		if (_turretPath isNotEqualTo []) then {
			_weapon = _uav currentWeaponTurret _turretPath;
		};
		if (_weapon isNotEqualTo "") then {
			_dir = _uav weaponDirection _weapon;
		};

		private _viewUnit = if (_turretPath isEqualTo [-1]) then {
			driver _uav
		} else {
			if (_turretPath isEqualTo []) then {gunner _uav} else {_uav turretUnit _turretPath}
		};
		if (isNull _viewUnit) then {
			_viewUnit = gunner _uav;
		};

		if (_dir isEqualTo [0, 0, 0] && {!isNull _viewUnit}) then {
			_dir = getCameraViewDirection _viewUnit;
		};
		if (_dir isEqualTo [0, 0, 0] && {!isNull _viewUnit}) then {
			_dir = eyeDirection _viewUnit;
		};
	};

	if (_dir isEqualTo [0, 0, 0] && _hasPilotCamera && {_cameraMode in ["auto", "turret"]}) then {
		([_uav, getPilotCameraDirection _uav, _directionYaw] call _fnc_modelDirectionToWorld) params ["_pilotDir", "_pilotUp"];
		_dir = _pilotDir;
		_up = _pilotUp;
		_directionYawApplied = true;
	};

	if (_dir isEqualTo [0, 0, 0] && _useMemoryPoints && {_cameraMode in ["auto", "turret", "memory"]}) then {
		private _posModel = _uav selectionPosition [_posMem, "Memory"];
		private _dirPosModel = _uav selectionPosition [_dirMem, "Memory"];
		private _dirModel = _posModel vectorFromTo _dirPosModel;

		if !(_posModel isEqualTo [0, 0, 0] && {_dirPosModel isEqualTo [0, 0, 0]}) then {
			if (_dirModel isNotEqualTo [0, 0, 0]) then {
				([_uav, _dirModel, _directionYaw] call _fnc_modelDirectionToWorld) params ["_memoryDir", "_memoryUp"];
				_dir = _memoryDir;
				_up = _memoryUp;
				_directionYawApplied = true;
			};
		};
	};

	if (_dir isEqualTo [0, 0, 0] && _preferPilotCamera && {_cameraMode in ["auto", "pilot"]} && _hasPilotCamera) then {
		([_uav, getPilotCameraDirection _uav, _directionYaw] call _fnc_modelDirectionToWorld) params ["_pilotDir", "_pilotUp"];
		_dir = _pilotDir;
		_up = _pilotUp;
		_directionYawApplied = true;
	};

	if (_dir isEqualTo [0, 0, 0]) then {
		_dir = vectorDirVisual _uav;
	};
	if (_directionYaw != 0 && {!_directionYawApplied} && {_dir isNotEqualTo [0, 0, 0]} && {_dir isEqualType []}) then {
		_dir = [_dir, _directionYaw] call _fnc_applyYaw;
	};

	[_camera, _posASL, _dir, _up] call _fnc_applyCamera;
	};
}, [_display, _picture, _uav, _camera, _token, _turretPath, _posMem, _dirMem, _directionYaw, _cameraMode, _preferPilotCamera, _followTurretAim, _useMemoryPoints]];

[
	{
		params ["_display", "_args"];
		_args params ["_token", "_camera", "_rttName", "_eh"];
		_display setVariable [_token, false];
		removeMissionEventHandler ["Draw3D", _eh];
		_camera cameraEffect ["Terminate", "Back", _rttName];
		camDestroy _camera;
	},
	[_token, _camera, _rttName, _eh]
] call FUNC(addAppCleanup);

uiNamespace setVariable [QGVAR(appBuilderY), _y + (_height max 0.1) + 0.018];
_picture
