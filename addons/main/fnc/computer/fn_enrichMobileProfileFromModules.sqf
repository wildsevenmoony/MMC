#include "..\..\script_component.hpp"

/*
 * Author: Moony
 * Adds synced MMC layout, desktop, file, picture, and mail module data to a
 * mobile profile hashmap without executing or deleting those synced modules.
 *
 * Arguments:
 * 0: Profile <HASHMAP>
 * 1: Synced objects <ARRAY>
 * 2: Profile module logic <OBJECT, optional>
 *
 * Return Value:
 * Enriched profile <HASHMAP>
 *
 * Example:
 * [_profile, synchronizedObjects _logic] call MMC_fnc_enrichMobileProfileFromModules
 */

params [
	["_profile", createHashMap, [createHashMap]],
	["_objects", [], [[]]],
	["_profileModule", objNull, [objNull]]
];

private _profileOut = +_profile;
private _contentTypes = [
	QGVAR(customLayout),
	QGVAR(modifyDesktop),
	QGVAR(addTextFile),
	QGVAR(addPicture),
	QGVAR(addMail)
];

if (!isNull _profileModule) then {
	private _logics = (allMissionObjects "Logic") + (allMissionObjects "Module_F");
	_logics = _logics arrayIntersect _logics;
	{
		if (typeOf _x in _contentTypes && {_profileModule in (synchronizedObjects _x)}) then {
			_objects pushBackUnique _x;
		};
	} forEach _logics;
};

_objects = _objects select {typeOf _x in _contentTypes};
_objects = _objects arrayIntersect _objects;

["MobileProfile", "Enriching profile from synced content", createHashMapFromArray [
	["profileModule", _profileModule],
	["contentObjects", _objects apply {format ["%1:%2", typeOf _x, _x]}]
]] call FUNC(debugLog);

{
	private _type = typeOf _x;

	switch (_type) do {
		case QGVAR(customLayout): {
			_profileOut set ["layout", [_x] call FUNC(getLayoutFromModule)];
			["MobileProfile", "Enriched layout", createHashMapFromArray [
				["module", _x],
				["preset", (_profileOut getOrDefault ["layout", createHashMap]) getOrDefault ["preset", ""]]
			]] call FUNC(debugLog);
		};
		case QGVAR(modifyDesktop): {
			_profileOut set ["desktopTitle", _x getVariable [QGVAR(desktopTitle), "Welcome"]];
			_profileOut set ["desktopContent", _x getVariable [QGVAR(desktopContent), "Select an app on the left."]];
			_profileOut set ["desktopAlign", _x getVariable [QGVAR(desktopAlign), "left"]];
			_profileOut set ["desktopScript", _x getVariable [QGVAR(desktopScript), ""]];
			["MobileProfile", "Enriched desktop", createHashMapFromArray [
				["module", _x],
				["title", _profileOut getOrDefault ["desktopTitle", ""]],
				["script", _profileOut getOrDefault ["desktopScript", ""]]
			]] call FUNC(debugLog);
		};
		case QGVAR(addTextFile): {
			private _sourceModule = netId _x;
			private _files = +(_profileOut getOrDefault ["files", []]);
			_files = _files select {!(_x isEqualType createHashMap) || {_x getOrDefault ["sourceModule", ""] isNotEqualTo _sourceModule}};
			_files pushBack createHashMapFromArray [
				["sourceModule", _sourceModule],
				["name", _x getVariable [QGVAR(fileName), "intel.txt"]],
				["type", "text"],
				["path", _x getVariable [QGVAR(filePath), "\Desktop\intel.txt"]],
				["content", _x getVariable [QGVAR(fileContent), "Mission intel goes here."]]
			];
			_profileOut set ["files", _files];
			private _lastFile = _files select -1;
			["MobileProfile", "Enriched text file", createHashMapFromArray [
				["module", _x],
				["name", _lastFile getOrDefault ["name", ""]],
				["fileCount", count _files]
			]] call FUNC(debugLog);
		};
		case QGVAR(addPicture): {
			private _sourceModule = netId _x;
			private _name = _x getVariable [QGVAR(fileName), "picture.paa"];
			private _path = _x getVariable [QGVAR(filePath), "\Pictures\picture.paa"];
			private _texture = _x getVariable [QGVAR(fileTexture), ""];
			if (_texture isEqualTo "") then {
				_texture = _path;
			};

			private _files = +(_profileOut getOrDefault ["files", []]);
			_files = _files select {!(_x isEqualType createHashMap) || {_x getOrDefault ["sourceModule", ""] isNotEqualTo _sourceModule}};
			_files pushBack createHashMapFromArray [
				["sourceModule", _sourceModule],
				["name", _name],
				["type", "picture"],
				["path", _path],
				["content", _x getVariable [QGVAR(fileDescription), ""]],
				["texture", _texture]
			];
			_profileOut set ["files", _files];
			["MobileProfile", "Enriched picture", createHashMapFromArray [
				["module", _x],
				["name", _name],
				["texture", _texture],
				["fileCount", count _files]
			]] call FUNC(debugLog);
		};
		case QGVAR(addMail): {
			private _sourceModule = netId _x;
			private _mails = +(_profileOut getOrDefault ["mails", []]);
			_mails = _mails select {!(_x isEqualType createHashMap) || {_x getOrDefault ["sourceModule", ""] isNotEqualTo _sourceModule}};
			_mails pushBack createHashMapFromArray [
				["sourceModule", _sourceModule],
				["direction", _x getVariable [QGVAR(mailDirection), "inbox"]],
				["counterpart", _x getVariable [QGVAR(mailCounterpart), _x getVariable [QGVAR(mailFrom), "sender@mmc.local"]]],
				["cc", _x getVariable [QGVAR(mailCc), ""]],
				["subject", _x getVariable [QGVAR(mailSubject), "Mission Update"]],
				["body", _x getVariable [QGVAR(mailBody), "Mail body goes here."]],
				["date", _x getVariable [QGVAR(mailDate), ""]],
				["time", _x getVariable [QGVAR(mailTime), ""]],
				["attachment", _x getVariable [QGVAR(mailAttachment), ""]],
				["attachmentDescription", _x getVariable [QGVAR(mailAttachmentDescription), ""]],
				["recipientRead", _x getVariable [QGVAR(mailRecipientRead), false]],
				["senderRead", _x getVariable [QGVAR(mailSenderRead), true]],
				["ccRead", _x getVariable [QGVAR(mailCcRead), false]]
			];
			_profileOut set ["mails", _mails];
			private _lastMail = _mails select -1;
			["MobileProfile", "Enriched mail", createHashMapFromArray [
				["module", _x],
				["direction", _lastMail getOrDefault ["direction", ""]],
				["counterpart", _lastMail getOrDefault ["counterpart", ""]],
				["subject", _lastMail getOrDefault ["subject", ""]],
				["mailCount", count _mails]
			]] call FUNC(debugLog);
		};
	};
} forEach _objects;

_profileOut
