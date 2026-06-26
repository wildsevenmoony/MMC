#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Requests the player's personal MMC mobile device from the server and opens it locally.
 *
 * Arguments:
 * 0: Selected mobile device record <HASHMAP, optional>
 *
 * Return Value:
 * Request sent <BOOL>
 */

private _device = createHashMap;
if (_this isEqualType createHashMap) then {
	_device = _this;
} else {
	if (_this isEqualType [] && {_this isNotEqualTo []}) then {
		private _first = _this param [0, createHashMap];
		if (_first isEqualType createHashMap) then {
			_device = _first;
		} else {
			private _params = _this param [2, []];
			if (_params isEqualType [] && {_params isNotEqualTo []}) then {
				private _paramDevice = _params param [0, createHashMap];
				if (_paramDevice isEqualType createHashMap) then {
					_device = _paramDevice;
				};
			};
		};
	};
};

if (!hasInterface || {isNull player}) exitWith {false};
if !(call FUNC(hasMobileDeviceItem)) exitWith {
	["No MMC mobile device found.", 1.5, player, 12] call ace_common_fnc_displayTextStructured;
	false
};

if (call FUNC(ensureUniqueMobileDevicesLocal)) exitWith {
	["Preparing mobile device...", 1.5, player, 12] call ace_common_fnc_displayTextStructured;
	false
};

if (count _device == 0) then {
	private _devices = [] call FUNC(getMobileInventoryDevices);
	_device = _devices param [0, createHashMap, [createHashMap]];
};

if (count _device == 0) exitWith {
	["No MMC mobile device found.", 1.5, player, 12] call ace_common_fnc_displayTextStructured;
	false
};

_device set ["clientLockCode", missionNamespace getVariable [QGVAR(mobileLockCode), ""]];

["Mobile", "Requesting mobile open from client", createHashMapFromArray [
	["player", format ["%1:%2:%3", name player, getPlayerUID player, typeOf player]],
	["device", _device]
]] call FUNC(debugLog);
[player, _device] remoteExecCall [QFUNC(openMobileServer), 2];
true
