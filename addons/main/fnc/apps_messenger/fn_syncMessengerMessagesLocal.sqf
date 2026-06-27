#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Synchronizes Messenger messages on the local client and refreshes an open Messenger view.
 *
 * Arguments:
 * 0: Messenger messages <ARRAY>
 *
 * Return Value:
 * Synchronized <BOOL>
 */

params [["_messages", [], [[]]]];

missionNamespace setVariable [QGVAR(messengerMessages), _messages, false];
GVAR(messengerMessages) = _messages;

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
if (!isNull _display && {(_display getVariable [QGVAR(currentApp), ""]) isEqualTo "messages"}) then {
	_display setVariable [QGVAR(messengerForceScrollBottom), true];
	_display setVariable [QGVAR(messengerKeepSelection), true];
	["select", [controlNull, -1]] call FUNC(renderApp);
};

true
