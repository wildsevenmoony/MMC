#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Keeps the editable mail body fitted to its fixed edit box.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _ctrl = _display displayCtrl IDC_MMC_MAIL_BODY;
if (isNull _ctrl) exitWith {};

private _group = _display displayCtrl IDC_MMC_MAIL_BODY_GROUP;
if (isNull _group) exitWith {};

private _groupPos = ctrlPosition _group;
private _targetWidth = ((_groupPos select 2) - 0.014) max 0.05;
private _targetHeight = (_groupPos select 3) max 0.05;
private _pos = ctrlPosition _ctrl;
if (
	abs ((_pos select 0) - 0) > 0.0005 ||
	abs ((_pos select 1) - 0) > 0.0005 ||
	abs ((_pos select 2) - _targetWidth) > 0.0005 ||
	abs ((_pos select 3) - _targetHeight) > 0.0005
) then {
	_ctrl ctrlSetPosition [0, 0, _targetWidth, _targetHeight];
	_ctrl ctrlCommit 0;
};
