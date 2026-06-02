#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Resizes the editable mail body inside its scroll group to expose a scroll range.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _ctrl = _display displayCtrl IDC_MMC_MAIL_BODY;
if (isNull _ctrl) exitWith {};

private _group = _display displayCtrl IDC_MMC_MAIL_BODY_GROUP;
private _groupHeight = if (isNull _group) then {0.2} else {(ctrlPosition _group) select 3};
private _text = ctrlText _ctrl;
private _lineCount = ({_x isEqualTo 10} count toArray _text) + 1;
private _wrappedLineCount = ceil ((count _text) / 78);
private _height = _groupHeight max (((_lineCount max _wrappedLineCount) * 0.034) + 0.05);

private _pos = ctrlPosition _ctrl;
_pos set [3, _height];
_ctrl ctrlSetPosition _pos;
_ctrl ctrlCommit 0;
