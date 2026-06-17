#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Resolves legacy configured mobile e-mail aliases for a player.
 *
 * This hook is kept for backwards compatibility. Mobile aliases are now assigned
 * through Mobile Profile modules or MMC_fnc_setMobileEmailAliases.
 *
 * Arguments:
 * 0: Player <OBJECT>
 *
 * Return Value:
 * E-mail aliases <ARRAY>
 */

params [["_player", objNull, [objNull]]];

if (isNull _player) exitWith {[]};

[]
