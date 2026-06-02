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

_ctrl ctrlSetText ((ctrlText _ctrl) + toString [10]);
call FUNC(resizeMailBody);

private _display = ctrlParent _ctrl;
ctrlSetFocus (_display displayCtrl IDC_MMC_MAIL_SUBJECT);
ctrlSetFocus _ctrl;
true
