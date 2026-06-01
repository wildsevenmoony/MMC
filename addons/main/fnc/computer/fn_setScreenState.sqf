#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Applies a placeholder screen texture to the computer object for a state.
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

private _data = _object getVariable [QGVAR(data), createHashMap];
private _screenTextures = _data getOrDefault ["screenTextures", createHashMap];
private _texture = "";

if (_screenTextures isEqualType createHashMap) then {
	_texture = _screenTextures getOrDefault [_state, ""];
};

if (_texture isEqualTo "") then {
	_texture = PATHTOF(img\desktop_placeholder.paa);
};

_object setVariable [QGVAR(screenState), _state, true];
_object setObjectTextureGlobal [0, _texture];
true
