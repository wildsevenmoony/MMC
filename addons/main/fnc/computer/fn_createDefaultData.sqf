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
	],
	createHashMapFromArray [
		["name", "intro_video.ogv"],
		["type", "video"],
		["path", "\Videos\intro_video.ogv"],
		["content", "Video playback placeholder using a vanilla Arma 3 OGV file."],
		["videoPath", "A3\Missions_F_EPA\video\A_in_intro.ogv"]
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

_data set ["messages", _config getOrDefault ["messages", [
	createHashMapFromArray [
		["from", "Admin"],
		["date", "08:02"],
		["body", "Messenger placeholder connected."]
	]
]]];

_data set ["notes", _config getOrDefault ["notes", [
	createHashMapFromArray [
		["title", "Mission Notes"],
		["body", "Notes are local computer data for now. Editing and persistence come next."]
	]
]]];

_data
