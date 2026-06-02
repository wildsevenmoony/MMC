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
_data set ["closedSystem", _config getOrDefault ["closedSystem", false]];
_data set ["desktopTitle", _config getOrDefault ["desktopTitle", "Welcome"]];
_data set ["desktopContent", _config getOrDefault ["desktopContent", "Select an app on the left. Files, Mail, Messenger, and Notes are wired to the computer data model now.<br/><br/>The Start button controls power state."]];
_data set ["desktopAlign", _config getOrDefault ["desktopAlign", "left"]];
_data set ["users", _config getOrDefault ["users", []]];
_data set ["files", _config getOrDefault ["files", [
	createHashMapFromArray [
		["name", "welcome.txt"],
		["type", "text"],
		["path", "\Desktop\welcome.txt"],
		["content", "Welcome to Moony's Magnificent Computers.\n\nThis is placeholder intel content. Mission makers will be able to inject files, pictures, audio, mail, messages, and notes through modules and scripts."]
	],
	createHashMapFromArray [
		["name", "testpicture.jpg"],
		["type", "picture"],
		["path", "\Pictures\testpicture.jpg"],
		["content", "Test picture file."],
		["texture", PATHTOF(img\testpicture.jpg)]
	],
	createHashMapFromArray [
		["name", "testaudio.ogg"],
		["type", "audio"],
		["path", "\Audio\testaudio.ogg"],
		["content", "Test audio file."],
		["soundClass", QGVAR(sound_testaudio)]
	]
]]];

_data set ["mail", _config getOrDefault ["mail", [
	createHashMapFromArray [
		["from", "admin@mmc.local"],
		["to", "operator@mmc.local"],
		["subject", "System online"],
		["date", "2035-06-01 08:00"],
		["body", "The workstation is available. This placeholder mail proves the inbox renderer is live."]
	]
]]];

_data set ["messages", _config getOrDefault ["messages", []]];

_data set ["notes", _config getOrDefault ["notes", []]];

_data
