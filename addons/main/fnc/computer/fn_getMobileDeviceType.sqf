#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Finds an MMC mobile device definition by item or object class.
 *
 * Arguments:
 * 0: Item or object classname <STRING>
 *
 * Return Value:
 * Device definition, or empty hashmap <HASHMAP>
 */

params [["_className", "", [""]]];

private _lookup = toLowerANSI _className;
if (_lookup isEqualTo "") exitWith {createHashMap};

private _weaponConfig = configFile >> "CfgWeapons" >> _className;
private _uniqueBase = "";
private _uniqueIndex = -1;
if (isClass _weaponConfig) then {
	_uniqueBase = getText (_weaponConfig >> QGVAR(mobileBase));
	if (getNumber (_weaponConfig >> QGVAR(mobileUnique)) == 1) then {
		_uniqueIndex = getNumber (_weaponConfig >> QGVAR(mobileUniqueIndex));
	};
};
private _baseLookup = if (_uniqueBase isNotEqualTo "") then {toLowerANSI _uniqueBase} else {_lookup};

private _types = [] call FUNC(getMobileDeviceTypes);
private _index = _types findIf {
	toLowerANSI (_x getOrDefault ["itemClass", ""]) isEqualTo _baseLookup
	|| {toLowerANSI (_x getOrDefault ["objectClass", ""]) isEqualTo _lookup}
};

if (_index < 0) exitWith {createHashMap};

private _type = +(_types select _index);
private _baseItemClass = _type getOrDefault ["itemClass", ""];
_type set ["baseItemClass", _baseItemClass];

if (_uniqueBase isNotEqualTo "") then {
	_type set ["itemClass", _className];
	_type set ["unique", true];
	_type set ["uniqueIndex", _uniqueIndex];
	_type set ["uniqueKey", _className];
};

_type
