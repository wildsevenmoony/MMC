#include "..\..\script_component.hpp"

private _time = systemTime;
private _pad = {
	params ["_value"];
	private _text = str _value;
	if (_value < 10) then {format ["0%1", _text]} else {_text}
};

[
	format ["%1-%2-%3", _time select 0, [_time select 1] call _pad, [_time select 2] call _pad],
	format ["%1:%2", [_time select 3] call _pad, [_time select 4] call _pad]
]
