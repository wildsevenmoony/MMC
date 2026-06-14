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

if (_object getVariable [QGVAR(destroyed), false]) then {
	_state = "broken";
};

private _deviceConfig = [_object] call FUNC(getScreenDeviceConfig);
_deviceConfig params [["_aspect", "1x1", [""]], ["_selections", [], [[], 0]]];

if (_selections isEqualType 0) then {
	_selections = [_selections];
};

private _layout = createHashMap;
private _data = _object getVariable [QGVAR(data), createHashMap];
if (_data isEqualType createHashMap) then {
	_layout = _data getOrDefault ["layout", createHashMap];
};
if !(_layout isEqualType createHashMap) then {
	_layout = createHashMap;
};

if !(_layout getOrDefault ["applyScreenTextures", true]) exitWith {
	_object setVariable [QGVAR(screenState), _state, true];
	false
};

private _layoutSelections = _layout getOrDefault ["screenSelections", []];
if (_layoutSelections isEqualType [] && {_layoutSelections isNotEqualTo []}) then {
	_selections = _layoutSelections;
};

if (_selections isEqualTo []) exitWith {
	_object setVariable [QGVAR(screenState), _state, true];
	false
};

private _texture = [_object, _state, _aspect] call FUNC(getScreenTexture);

_object setVariable [QGVAR(screenState), _state, true];
{
	_object setObjectTextureGlobal [_x, _texture];
} forEach _selections;
true
