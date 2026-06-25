# Moony's Magnificent Computers

Moony's Magnificent Computers, or MMC, is an Arma 3 framework for interactive in-mission computer systems. Mission makers can register laptops, PCs, or other objects as computers and use them for files, pictures, e-mail, user accounts, and mission intel.

## Features

- Register objects as computers through Eden modules, Zeus modules, or script.
- Open registered computers through ACE interaction.
- Zeus operators get an ACE Zeus action that lists all registered computers and can open or start them remotely.
- Power states with startup, shutdown, login, desktop, and powered-off flows.
- PC-style screen with desktop background, taskbar, clock/date, start menu, and app buttons.
- ACE self-interaction mobile computers for players carrying MMC phone/tablet items.
- MMC Smartphone, Tablet, and Rugged Tablet inventory items for mobile computer access.
- Placeable MMC phone/tablet objects under Eden Things > MMC Devices, with device user and app attributes.
- User accounts with username, password, e-mail address, theme, and closed-system support.
- Eden mobile profiles for PvP-safe arsenal/personal device setup by synced unit, side, role, UID, faction, item class, or picked-up device source.
- Client CBA settings for default dark/light theme preference and logging out when the computer dialog is closed.
- Theme layouts for Default, NATO, CSAT, and AAF styles, plus an Eden layout module for mission-specific colors and desktop pictures.
- File browser with folders for text files, pictures, and audio files.
- Text files and desktop text support structured text, image tags, and `\n` or `<br/>` line breaks.
- Picture files support a texture path and description shown below the image.
- Mail app with inbox, outbox, unread/read state, reply, forward, CC, linked mobile sender identities, picture attachment support, and mission-time timestamps.
- Messenger app with side-filtered device contacts and a scrollable chat history for registered desktop and mobile devices.
- Notes app for multiple personal note files per user, with save/delete editing and a handoff into the mail composer.
- Standard apps can be hidden per computer or per user.
- Scripted custom apps that mission makers can add to individual computers, including structured text, buttons, fields, checkboxes, combo boxes, progress bars, raw controls, and live camera feeds.
- Zeus modules for registering computers, changing power state, adding users, assigning live mobile profiles, adding text files, pictures, notes, mail, and modifying desktop/home text.
- Eden modules for registering computers, adding users, layouts, adding text files, adding pictures, adding mail, and modifying desktop text.

## Current State

MMC is playable as a mission-maker tool, but it is still under active development. The current focus is the computer shell, user system, files, pictures, mail, messenger, and notes workflow.

Richer media handling and more polished computer-screen object textures are still future work. Video support was investigated and intentionally left out for now because Arma UI playback behavior is not reliable enough for the intended workflow.

## Mission-Maker Notes

- The `Register Computer` module turns synced objects into MMC computers.
- Zeus operators can use `ACE Zeus Actions > Computer` to list every registered computer, including computers created during the mission. The action opens powered computers and starts powered-off computers before opening them.
- The `Add User` module can be synced to specific registered computers. If it is not synced to a computer, the user is treated as globally available to registered computers unless a computer is marked as a closed system.
- Text, picture, and mail modules can be synced to an `Add User` module for user content, a registered computer object for one computer, or a `Register Computer` module for every computer registered by that module.
- Desktop modules can target users or computers depending on their sync setup.
- `MMC: Modify Desktop` should normally be synced to a `Register Computer` module for computer defaults, to an `Add User` module for user-specific desktop text, or to a mobile profile module for mobile desktops. Direct object sync still works as a fallback.
- Startup and login screens use a direct user layout first. If no user is added directly to that computer, they use a synced `MMC: Layout` module on the `Register Computer` module or computer object, then fall back to the client default.
- The `MMC: Layout` module syncs to `Register Computer` modules, registered computers, or mobile profile modules and can set preset colors/backgrounds or custom mission-specific colors and a desktop picture.
- Uncheck standard app boxes on `Register Computer` to hide apps for the whole computer, or on `Add User` to hide apps only while that user is logged in.
- In-world screen textures are applied automatically only for supported 1x1 and 2x1 laptop/PC/TV objects. Add more supported device classes in `fn_getScreenDeviceConfig.sqf`.
- The `MMC: Layout` module can disable in-world screen texture application, or override the `setObjectTexture` selections with a comma-separated list such as `0` or `0,1`.
- Messenger lists registered devices on the user's own side by default. A CBA setting can allow friendly-side devices too, and another setting can hide civilian devices from that friendly list.
- Use `Messenger Username` fields when a contact should appear under a mission-specific callsign or role name instead of the device name, account username, or e-mail prefix.
- Desktop users use `Messenger Side` in the `Computer: Add User` module. `Auto (Theme)` derives NATO as BLUFOR, CSAT as OPFOR, and AAF as Independent; use `Hidden` to keep a user out of Messenger contact lists. Physical mobile devices can set a `Messenger Side` in their Eden attributes, while mobile profile devices receive their side from the synced unit or from the player opening an arsenal/personal device.
- Messenger sends with Enter. Use Shift+Enter for line breaks inside a longer message.
- Notes are stored on the active user account. Users can create multiple notes, save/delete them, and open a note as a prefilled e-mail draft.
- Script-created mobile profiles can include a `notes` array with `title` and `body` fields to seed personal notes on matching devices.
- Picture texture paths should point to valid `.paa` textures from the mission or a mod.
- The file path fields are paths inside the computer's file browser, not necessarily real filesystem paths.
- Audio playback currently relies on configured mod sounds. Mission-file audio is not treated as a reliable general-purpose file format yet.
- Placeable MMC device objects are compact/mobile computers. Their Eden attributes can set powered state, login behavior, the built-in username/password/e-mail, theme, and visible standard apps.
- The `Mobile: Assign Profile` module is the simple route for player slots: sync it to playable or AI units, optionally give them a phone/tablet item, set their primary and linked e-mail addresses, theme, app scripts, and visible apps.
- The advanced `Mobile: Profile` module configures personal/arsenal mobile devices without requiring one preplaced device per player. Use its selector fields to target a side, faction, UID, player name, unit variable, unit class, group, item class, device id, or picked-up device source.
- Sync `MMC: Layout`, `MMC: Modify Desktop`, `MMC: Add Text File`, `MMC: Add Picture`, and `MMC: Add Mail` modules to `Mobile: Assign Profile` or `Mobile: Profile` to give matching devices the same kind of layout, desktop, files, pictures, and mail content as desktop computers.
- Zeus can assign a compact live mobile profile to a unit with `Assign Mobile Profile`. This is intended for ad-hoc mission control during play; use the Eden `Mobile: Assign Profile` or `Mobile: Profile` modules for preplanned profile content and synced layout/file/mail setup.

## Debugging

MMC has an optional CBA debug setting at `Moony's Magnificent Computers > Debug > Debug Logging`. It is disabled by default. When enabled, MMC writes detailed `[MMC DEBUG]` lines to the RPT for module sync resolution, mobile profile selection and application, unique mobile device preparation, file/mail/note seeding, custom app script loading, and mail recipient lookup.

Enable this only while testing a mission. For mobile profile issues, open the affected device once, then search the RPT for `[MMC DEBUG]`, `AssignProfile`, `MobileProfile`, `Modules`, and `Mail`.

## Mobile Devices

MMC can also create a personal mobile computer for each player carrying one of MMC's own inventory devices:

```text
MMC_main_smartphone, MMC_main_ruggedTabletBlack, MMC_main_ruggedTabletGreen, MMC_main_ruggedTabletSand, MMC_main_tablet
```

Players open mobile devices through `ACE Self Actions > Mobile Device`. If a player carries more than one MMC device, every available device appears as a separate child action. Arsenal/prototype inventory phones and tablets are automatically replaced with hidden unique subclasses such as `MMC_main_smartphone_1`. That unique classname is used as the device id, so the phone/tablet keeps its own mail, files, apps, and desktop data if it is dropped, looted, stolen, or moved to another player.

The personal mobile device is backed by a server-registered hidden MMC computer, so mail validation, delivery, and Messenger contacts still work on dedicated servers. It opens straight to a personal desktop and uses the same Files, Mail, Messenger, Notes, and custom app renderer as normal computers. The dialog is constrained into a compact mobile surface and includes a `Rotate` button to switch between horizontal and vertical layouts. Smartphones start in vertical orientation; tablets start horizontal.

On mobile, the built-in apps stay on the icon dock. Scripted custom apps appear in a collapsible `Apps` drawer so long app names do not have to fit into the compact icon buttons. In vertical mode the drawer opens from the right side of the content area; in horizontal mode it opens from the bottom.

The new device items appear as ACE misc items:

- `MMC_main_smartphone`
- `MMC_main_ruggedTabletBlack`
- `MMC_main_ruggedTabletGreen`
- `MMC_main_ruggedTabletSand`
- `MMC_main_tablet`

Mission makers can also place physical device objects from `Things > MMC Devices`. These are useful for a phone/tablet lying on a desk: they register themselves as compact MMC computers and can be configured directly through Eden object attributes. Players can pick these objects up with ACE interaction, turning them into a hidden unique inventory item while preserving the configured device content.

The default mobile address is generated from the player's current profile name as `PLAYERNAME@mmcsystems.com`. Mission makers can add role/shared addresses through `Mobile: Assign Profile`, `Mobile: Profile`, synced mail modules, or script. If you prefer direct script control, call the helper on server or client:

```sqf
[player, ["bravo1-4@aaf.ass", "radio-watch@aaf.ass"]] call MMC_fnc_setMobileEmailAliases;
["76561198000000000", "overlord@aaf.ass"] call MMC_fnc_setMobileEmailAliases;
```

Aliases behave like real addresses for mail lookup. A player keeps their generated personal address, but mail sent to any linked alias reaches the same mobile inbox. On mobile devices, the mail composer shows a `From` dropdown when more than one sender address is available.

### Mobile Profiles

Inventory mobile devices from the arsenal can be configured through mobile profiles. Profiles are matched when the player opens the device and can add primary e-mail addresses, aliases, themes, layout, desktop text, files, mail, notes, and local scripted apps. This keeps arsenal devices dynamic without blindly giving every side the same apps in PvP.

For ordinary player-slot setup, use `Mobile: Assign Profile`:

- Sync the module to one or more playable or AI units.
- Enable `Add Device` if those units should receive a chosen MMC phone/tablet at mission start.
- Leave `E-Mail Address` empty to use the generated `PLAYERNAME@mmcsystems.com` mobile address, or fill it to force a primary address.
- Use `Link E-Mail to Profile` for comma-separated role/shared addresses such as `overlord@mmcsystems.com` or `bravo1-4@aaf.ass`.
- Use `Messenger Username` if that mobile profile should appear in Messenger as a callsign or role name instead of the synced unit name.
- Sync `MMC: Layout`, `MMC: Modify Desktop`, `MMC: Add Text File`, `MMC: Add Picture`, and `MMC: Add Mail` modules to the assign module to seed that profile.

The assigned profile applies when a personal MMC inventory device is first prepared, including devices taken from an arsenal after mission start. After that, the unique device keeps its own data. If an enemy steals the phone from a corpse, they open that phone's existing data rather than getting their own profile on it. Physical placed devices picked up from the world keep their own configured data from the start, which is usually what you want for stealable intel devices.

During a live mission, Zeus can use the `Assign Mobile Profile` Zeus module on a unit to set a simple personal profile, optionally give a device, set a primary address, linked addresses, Messenger username/side, theme, custom app script files, and visible apps. It does not replace the full Eden profile module surface, but it is useful for quick role handoff or emergency devices.

The advanced route is the `Mobile: Profile` Eden module. Configure its selectors, then sync `MMC: Layout`, `MMC: Modify Desktop`, `MMC: Add Text File`, `MMC: Add Picture`, and `MMC: Add Mail` modules to it. The module broadcasts the profile to clients/JIP, while app script files listed in `Custom App Script Files` are still executed locally and therefore need to exist in the mission or a loaded mod.

Script profiles are still available for advanced or dynamic setup. Register script-created profiles on server and clients, usually from `init.sqf` or from a file called by both `initServer.sqf` and `initPlayerLocal.sqf`. Server-side data such as files and mail is applied on the server. App code is applied locally on the client, so app profiles with code need to exist client-side too.

Profiles stack from lowest to highest priority. A broad profile can add harmless defaults, while a higher-priority side, role, UID, or unit profile can add restricted apps or override layout choices. By default, profiles only match personal arsenal devices (`source = "personal"`), not picked-up placed devices. Add `sources = ["picked"]` or `sources = ["personal", "picked"]` only if you intentionally want that.

```sqf
[
    "aaf_mobile_default",
    createHashMapFromArray [
        ["priority", 0],
        ["side", independent],
        ["itemClasses", ["MMC_main_ruggedTabletGreen", "MMC_main_tablet"]],
        ["theme", "aaf"],
        ["aliases", ["aaf.user@aaf.ass"]],
        ["desktopTitle", "AAF MilNet"],
        ["desktopContent", "Authenticated field terminal.<br/>Use only approved channels."],
        ["disabledApps", ["messages", "notes"]]
    ]
] call MMC_fnc_registerMobileProfile;

[
    "aaf_drone_operator",
    createHashMapFromArray [
        ["priority", 50],
        ["unitVars", ["aaf_drone_operator_1", "aaf_drone_operator_2"]],
        ["itemClasses", ["MMC_main_ruggedTabletGreen"]],
        ["aliases", ["drone-ops@aaf.ass"]],
        ["appScripts", ["droneOperatorApp.sqf"]]
    ]
] call MMC_fnc_registerMobileProfile;
```

Supported selector keys include `itemClasses`, `deviceIds`, `sources`, `playerUIDs`, `playerNames`, `unitVars`, `unitClasses`, `sides`, `factions`, `groups`, and `condition`. A condition receives `[player, deviceInfo, profile]` and should return `true` or `false`.

Useful content keys:

```sqf
"systemName", "theme", "layout", "disabledApps",
"desktopTitle", "desktopContent", "desktopAlign", "desktopScript",
"aliases", "files", "mails", "notes", "apps", "appScripts"
```

Files, mails, and notes are seeded once per device/profile so reopening the same arsenal device does not duplicate content. Set `reapplyContent = true` on a profile only when repeated seeding is intentional.

Local app scripts are called as:

```sqf
params ["_device", "_player", "_profile"];
[_device, "app_id", "App Name", [{["Hello"] call MMC_fnc_addAppStructuredText;}]] call MMC_fnc_addApp;
"app_id"
```

Returning the app id, or an array of app ids, lets MMC cleanly remove profile-created apps if the matching profile set changes.

## Scripted Apps

Mission makers can add custom apps to a specific computer object from local script, for example `initPlayerLocal.sqf`. Local registration is recommended because app content and action callbacks can be code.

The app body can be built from ordered UI blocks:

```sqf
[
    myLaptop,
    "generator",
    "Generator",
    [
        {
            private _enabled = missionNamespace getVariable ["TAG_generatorEnabled", true];
            [
                format [
                    "<t size='1.25'>Generator Control</t><br/><br/>Status: %1",
                    ["Offline", "Online"] select _enabled
                ]
            ] call MMC_fnc_addAppStructuredText;
        },
        {
            [
                "Disable generator",
                {missionNamespace setVariable ["TAG_generatorEnabled", false, true]},
                "Disable the connected generator."
            ] call MMC_fnc_addAppButton;
        },
        {
            ["accessCode", "Access Code", ""] call MMC_fnc_addAppEdit;
            [
                "Submit code",
                {
                    private _code = ["accessCode", ""] call MMC_fnc_getAppControlValue;
                    hint format ["Code entered: %1", _code];
                }
            ] call MMC_fnc_addAppButton;
        },
        {
            [
                "safety",
                "Safety Interlock",
                true,
                {
                    params ["_computer", "_user", "_app", "_display", "_control", "_checked"];
                    missionNamespace setVariable ["TAG_generatorSafety", _checked, true];
                }
            ] call MMC_fnc_addAppCheckbox;
        },
        {
            [
                "mode",
                "Generator Mode",
                [["eco", "Eco"], ["normal", "Normal"], ["boost", "Boost"]],
                "normal",
                {
                    params ["_computer", "_user", "_app", "_display", "_control", "_value"];
                    missionNamespace setVariable ["TAG_generatorMode", _value, true];
                }
            ] call MMC_fnc_addAppCombo;
        }
    ]
] call MMC_fnc_addApp;
```

Available app builder helpers:

```sqf
["Structured <t color='#88ccff'>text</t>"] call MMC_fnc_addAppStructuredText;
["Button", {hint "Clicked"}] call MMC_fnc_addAppButton;
["Toggle", {hint "On"}, {hint "Off"}] call MMC_fnc_addAppButton;
["stateButton", "Enabled"] call MMC_fnc_setAppControlText;
["fieldId", "Field Label", "Default text"] call MMC_fnc_addAppEdit;
["checkId", "Checkbox Label", true] call MMC_fnc_addAppCheckbox;
["comboId", "Combo Label", [["a", "Option A"], ["b", "Option B"]], "a"] call MMC_fnc_addAppCombo;
["progressId", "Signal Strength", 0.65] call MMC_fnc_addAppProgressBar;
["progressId", 0.8, "80% / nominal"] call MMC_fnc_setAppProgressBar;
["rawId", "RscPicture", 0.2, {_this#0 ctrlSetText "#(argb,8,8,3)color(0,0,0,1)"}] call MMC_fnc_addAppControl;
["helmetFeed", alpha_1, 0.38, "Alpha 1"] call MMC_fnc_addAppUnitFeed;
["feedId", uav_1, 0.38, "UAV Feed"] call MMC_fnc_addAppUavFeed;
["vehicleFeed", hunter_1, 0.38, "Hunter Turret", "gunner"] call MMC_fnc_addAppVehicleFeed;
["#88ccff", 0.003] call MMC_fnc_addAppLine;
[0.035] call MMC_fnc_addAppSpacer;
[
    [
        "Boxed content can contain any other builder calls."
    ],
    "#101820",
    "#88ccff",
    0.45,
    0.18
] call MMC_fnc_addAppBox;
["fieldId", "fallback"] call MMC_fnc_getAppControlValue;
```

Buttons can also use dynamic labels by passing code as the first argument. If you pass a value id as the sixth argument, `MMC_fnc_setAppControlText` can change that button later.

`MMC_fnc_addAppControl` is the escape hatch for mission-specific controls. It creates a raw UI control inside the app body and calls your setup code with `[control, display, group, computer, activeUser, app]`.

`MMC_fnc_addAppUnitFeed`, `MMC_fnc_addAppUavFeed`, and `MMC_fnc_addAppVehicleFeed` create local render-to-texture picture-in-picture feeds and clean them up when the app changes or the computer is closed. See [docs/examples/buildingBlocksTestApp.sqf](docs/examples/buildingBlocksTestApp.sqf) for a general building-block test app, [docs/examples/uavInfoApp.sqf](docs/examples/uavInfoApp.sqf) for a selectable UAV screen, or [docs/examples/tacticalFeedsApp.sqf](docs/examples/tacticalFeedsApp.sqf) for unit, UAV, and vehicle feeds in one app.

Feed helpers accept an optional options hash map. Useful keys are `widthRatio`, `width`, `align`, `renderSize`, `updateInterval`, `fov`, and `pipEffect`. Vehicle and UAV feeds can also take `turretPath`; for example `["turretPath", [0]]` follows the main gunner turret on most vanilla vehicles. If a specific vehicle uses unusual memory points, pass `positionMemory` and `directionMemory` as well. If the model's camera axis is rotated, use `directionYaw` to nudge it in degrees.

To find turret paths while testing, sit a unit in the relevant seat and run `systemChat str ((gunner myVehicle) call CBA_fnc_turretPath);` or `systemChat str ((commander myVehicle) call CBA_fnc_turretPath);`. For many vanilla vehicles the main gunner is `[0]`, but modded vehicles can differ.

For very simple apps, the content can still be a structured text string or a code block that returns structured text. Use `[_computer, "generator"] call MMC_fnc_removeApp;` to remove an app again. A final `true` parameter on add/remove publishes the app list as an object variable, but use that only for network-safe app configs without code callbacks.

Standard apps can be hidden from script as well:

```sqf
[myLaptop, ["mail", "notes"]] call MMC_fnc_removeStandardApp;
[myLaptop, "files", "operator"] call MMC_fnc_removeStandardApp;
[myLaptop, "files", "operator"] call MMC_fnc_restoreStandardApp;
```

The `MMC: Modify Desktop` module also has an optional `Desktop Script File` field. If filled, that script is called with the same builder context, so a mission file can build a modular desktop using the same `MMC_fnc_addApp...` helpers.

## Requirements

- Arma 3
- CBA
- ACE
- Zeus Enhanced
- Moony's Magnificent Base

## Building

This repository is structured as a HEMTT-based Arma 3 mod project.

Common commands:

```sh
hemtt check
hemtt build
hemtt release
```

Generated build output, releases, private keys, and packed PBO files are ignored by Git.

## License

See [LICENSE](LICENSE).
