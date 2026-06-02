#include "..\..\script_component.hpp"

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {false};

private _table = _display displayCtrl IDC_MMC_MAIL_TABLE;
private _index = lbCurSel _table;
private _rows = _display getVariable [QGVAR(mailRows), []];
private _mail = _rows param [_index, createHashMap];
if (count _mail == 0) exitWith {false};

_display setVariable [QGVAR(selectedMail), _mail];
_display setVariable [QGVAR(selectedMailFolder), _display getVariable [QGVAR(mailFolder), "inbox"]];
if ((_display getVariable [QGVAR(mailFolder), "inbox"]) isEqualTo "inbox") then {
	[_mail] call FUNC(markMailRead);
};
_display setVariable [QGVAR(mailMode), "read"];
["read"] call FUNC(renderMail);
true
