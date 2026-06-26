#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Creates the default data model for a new MMC computer.
 *
 * Arguments:
 * 0: Optional config hashmap <HASHMAP>
 *
 * Return Value:
 * Computer data <HASHMAP>
 */

params [["_config", createHashMap, [createHashMap]]];

private _data = createHashMap;

_data set ["systemName", _config getOrDefault ["systemName", "MMC Workstation"]];
_data set ["background", _config getOrDefault ["background", ""]];
_data set ["layout", _config getOrDefault ["layout", createHashMap]];
_data set ["closedSystem", _config getOrDefault ["closedSystem", false]];
_data set ["loginRequired", _config getOrDefault ["loginRequired", true]];
_data set ["autoLoginUsername", _config getOrDefault ["autoLoginUsername", ""]];
if ("mobileLockCode" in keys _config) then {
	_data set ["mobileLockCode", _config getOrDefault ["mobileLockCode", ""]];
};
_data set ["disabledApps", [_config getOrDefault ["disabledApps", []]] call FUNC(normalizeStandardAppIds)];
_data set ["desktopTitle", _config getOrDefault ["desktopTitle", "Welcome"]];
_data set ["desktopContent", _config getOrDefault ["desktopContent", "Select an app on the left. Files, Mail, Messenger, and Notes are wired to the computer data model now.<br/><br/>The Start button controls power state."]];
_data set ["desktopAlign", _config getOrDefault ["desktopAlign", "left"]];
_data set ["users", _config getOrDefault ["users", []]];
_data set ["files", _config getOrDefault ["files", []]];

_data set ["mail", _config getOrDefault ["mail", []]];

_data set ["messages", _config getOrDefault ["messages", []]];

_data set ["notes", _config getOrDefault ["notes", []]];

_data
