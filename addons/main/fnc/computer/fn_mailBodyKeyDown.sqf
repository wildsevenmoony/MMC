#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Handles mail body editor keys.
 */

params [
	["_ctrl", controlNull, [controlNull]],
	["_key", -1, [0]]
];

if (isNull _ctrl) exitWith {false};
if !(_key in [28, 156]) exitWith {false};

private _display = ctrlParent _ctrl;
_ctrl ctrlSetText ((ctrlText _ctrl) + toString [13, 10]);
call FUNC(resizeMailBody);

[_display, _ctrl] spawn {
	params ["_display", "_ctrl"];
	uiSleep 0.01;
	if (!isNull _display && {!isNull _ctrl}) then {
		ctrlSetFocus (_display displayCtrl IDC_MMC_MAIL_SUBJECT);
		uiSleep 0.01;
		ctrlSetFocus _ctrl;
		call MMC_fnc_resizeMailBody;
	};
};
true
