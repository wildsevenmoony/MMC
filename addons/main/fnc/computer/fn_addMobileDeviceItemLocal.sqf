#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds an MMC mobile device item to a unit on the unit's locality.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Mobile device item class <STRING>
 *
 * Return Value:
 * Item added or already present <BOOL>
 */

params [
	["_unit", objNull, [objNull]],
	["_itemClass", "", [""]]
];

if (isNull _unit || {_itemClass isEqualTo ""}) exitWith {false};
if (!local _unit) exitWith {
	[_unit, _itemClass] remoteExecCall [QFUNC(addMobileDeviceItemLocal), _unit];
	true
};

private _inventory = (items _unit) + (assignedItems _unit);
private _hasMatchingDevice = _itemClass in _inventory;
if (!_hasMatchingDevice) then {
	{
		private _type = [_x] call FUNC(getMobileDeviceType);
		if (count _type > 0 && {_type getOrDefault ["baseItemClass", _type getOrDefault ["itemClass", ""]] isEqualTo _itemClass}) exitWith {
			_hasMatchingDevice = true;
		};
	} forEach _inventory;
};

if (!_hasMatchingDevice) then {
	_unit addItem _itemClass;
};

["Mobile", "Ensured mobile device item on unit", createHashMapFromArray [
	["unit", format ["%1:%2", name _unit, typeOf _unit]],
	["itemClass", _itemClass],
	["alreadyHadMatchingDevice", _hasMatchingDevice],
	["local", local _unit]
]] call FUNC(debugLog);

if (hasInterface && {_unit isEqualTo player}) then {
	call FUNC(ensureUniqueMobileDevicesLocal);
};

true
