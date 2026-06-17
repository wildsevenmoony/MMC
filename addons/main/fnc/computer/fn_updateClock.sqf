#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Updates the taskbar clock and date.
 */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (isNull _display) exitWith {};

private _clock = _display displayCtrl IDC_MMC_CLOCK;
private _date = date;
private _year = _date select 0;
private _month = _date select 1;
private _day = _date select 2;
private _hour = _date select 3;
private _minute = _date select 4;
private _pad = {
	params ["_number"];
	private _text = str floor _number;
	if (_number < 10) then {
		_text = "0" + _text;
	};
	_text
};

private _isVerticalMobile = (_display getVariable [QGVAR(isMobileDisplay), false])
	&& {(_display getVariable [QGVAR(mobileOrientation), "horizontal"]) isEqualTo "vertical"};

if (_isVerticalMobile) then {
	_clock ctrlSetText format [
		"%1:%2  %3.%4.%5",
		[_hour] call _pad,
		[_minute] call _pad,
		[_day] call _pad,
		[_month] call _pad,
		_year
	];
} else {
	_clock ctrlSetText format [
		"%1:%2  %3.%4.%5",
		[_hour] call _pad,
		[_minute] call _pad,
		[_day] call _pad,
		[_month] call _pad,
		_year
	];
};
