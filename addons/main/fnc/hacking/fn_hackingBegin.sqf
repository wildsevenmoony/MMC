#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Builds the word puzzle after the timed hacking phase completes.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Hacking state <HASHMAP>
 *
 * Return Value:
 * Puzzle opened <BOOL>
 */

params [
	["_display", displayNull, [displayNull]],
	["_state", createHashMap, [createHashMap]]
];

if (isNull _display || {count _state == 0}) exitWith {false};

[_state getOrDefault ["hacker", player], false] call FUNC(hackingSetEffectsLocal);

private _wordPool = [
	"ACCESS",
	"ACCEPT",
	"BACKUP",
	"BINARY",
	"BRIDGE",
	"BUFFER",
	"CIPHER",
	"CLIENT",
	"COOKIE",
	"DECODE",
	"DELETE",
	"DEVICE",
	"DETECT",
	"DOMAIN",
	"DRIVER",
	"ENCODE",
	"CRYPTS",
	"FILTER",
	"HEADER",
	"INJECT",
	"KEYPAD",
	"LOCKED",
	"LOGGER",
	"LOGINS",
	"MEMORY",
	"MOBILE",
	"MODULE",
	"PACKET",
	"PAYLOD",
	"PORTAL",
	"REMOTE",
	"REMOVE",
	"REPLAY",
	"REPORT",
	"ROUTER",
	"SCHEMA",
	"SCREEN",
	"SECRET",
	"SCRIPT",
	"SECURE",
	"SECTOR",
	"SENSOR",
	"SERVER",
	"SIGNAL",
	"SILENT",
	"SOCKET",
	"STREAM",
	"SWITCH",
	"SYSTEM",
	"SYNTAX",
	"TARGET",
	"TERMIN",
	"THREAD",
	"TRACEA",
	"VECTOR"
];
private _wordCount = round (missionNamespace getVariable [QGVAR(hackingWordCount), 21]);
_wordCount = (_wordCount max 6) min (count _wordPool);

private _targetWord = selectRandom _wordPool;
private _pool = _wordPool select {_x isNotEqualTo _targetWord};
private _takeRandom = {
	params [["_source", [], [[]]], ["_amount", 0, [0]]];

	private _out = [];
	private _localPool = +_source;
	for "_i" from 1 to (round _amount) do {
		if (_localPool isEqualTo []) exitWith {};
		private _index = floor random (count _localPool);
		_out pushBack (_localPool deleteAt _index);
	};
	_out
};
private _shuffle = {
	params [["_source", [], [[]]]];

	private _out = [];
	private _localPool = +_source;
	while {_localPool isNotEqualTo []} do {
		private _index = floor random (count _localPool);
		_out pushBack (_localPool deleteAt _index);
	};
	_out
};

private _similar = _pool select {([_x, _targetWord] call FUNC(hackingLikeness)) > 0};
private _similarCount = round (((_wordCount - 1) * 0.7) max 3);
private _words = [_targetWord] + ([_similar, _similarCount] call _takeRandom);
private _remaining = _pool select {!(_x in _words)};
_words append ([_remaining, _wordCount - (count _words)] call _takeRandom);
_words = [_words] call _shuffle;

private _attempts = round (missionNamespace getVariable [QGVAR(hackingAttempts), 4]) max 1;
_state set ["words", _words];
_state set ["targetWord", _targetWord];
_state set ["attemptsLeft", _attempts];
_state set ["attemptsMax", _attempts];
_state set ["history", []];
_state set ["lockedOut", false];

_display setVariable [QGVAR(hackingState), _state];
_display setVariable [QGVAR(hackingBusy), false];

[_display] call FUNC(hackingRender);
true
