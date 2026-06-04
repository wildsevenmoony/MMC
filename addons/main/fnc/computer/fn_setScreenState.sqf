#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Applies the correct in-world screen texture to the computer object for a state.
 *
 * Arguments:
 * 0: Computer object <OBJECT>
 * 1: Screen state <STRING>
 *
 * Return Value:
 * Applied <BOOL>
 */

params [
	["_object", objNull, [objNull]],
	["_state", "powered_off", [""]]
];

if (isNull _object) exitWith {false};

private _deviceConfig = [_object] call FUNC(getScreenDeviceConfig);
_deviceConfig params [["_aspect", "1x1", [""]], ["_selection", 0, [0]]];

private _texture = [_object, _state, _aspect] call FUNC(getScreenTexture);

_object setVariable [QGVAR(screenState), _state, true];
_object setObjectTextureGlobal [_selection, _texture];
true
