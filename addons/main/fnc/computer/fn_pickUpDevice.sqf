#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Requests pickup of a placeable MMC mobile device object.
 *
 * Arguments:
 * 0: Device object <OBJECT>
 *
 * Return Value:
 * Request sent <BOOL>
 */

params [["_object", objNull, [objNull]]];

if (!hasInterface || {isNull player} || {isNull _object}) exitWith {false};

private _type = [typeOf _object] call FUNC(getMobileDeviceType);
if (count _type == 0) exitWith {false};

private _itemClass = _type getOrDefault ["itemClass", ""];
if (_itemClass isEqualTo "") exitWith {false};

if !(player canAdd _itemClass) exitWith {
	["No inventory space for this device.", 1.5, player, 12] call ace_common_fnc_displayTextStructured;
	false
};

[_object, player] remoteExecCall [QFUNC(pickUpDeviceServer), 2];
true
