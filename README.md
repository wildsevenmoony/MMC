# Moony's Magnificent Computers

Moony's Magnificent Computers, or MMC, is an Arma 3 framework for interactive in-mission computer systems. Mission makers can register laptops, PCs, or other objects as computers and use them for files, pictures, e-mail, user accounts, and mission intel.

## Features

- Register objects as computers through Eden modules, Zeus modules, or script.
- Open registered computers through ACE interaction.
- Zeus operators get an ACE Zeus action that lists all registered computers and can open or start them remotely.
- Power states with startup, shutdown, login, desktop, and powered-off flows.
- PC-style screen with desktop background, taskbar, clock/date, start menu, and app buttons.
- User accounts with username, password, e-mail address, theme, and closed-system support.
- Client CBA settings for default dark/light theme preference and logging out when the computer dialog is closed.
- Theme layouts for Default, NATO, CSAT, and AAF styles, plus an Eden layout module for mission-specific colors and desktop pictures.
- File browser with folders for text files, pictures, and audio files.
- Text files and desktop text support structured text, image tags, and `\n` or `<br/>` line breaks.
- Picture files support a texture path and description shown below the image.
- Mail app with inbox, outbox, unread/read state, reply, forward, CC, picture attachment support, and mission-time timestamps.
- Standard apps can be hidden per computer or per user.
- Scripted custom apps that mission makers can add to individual computers, including structured text, buttons, fields, checkboxes, combo boxes, progress bars, raw controls, and live camera feeds.
- Zeus modules for adding users, text files, pictures, mail, registering computers, changing power state, and modifying desktop text.
- Eden modules for registering computers, adding users, layouts, adding text files, adding pictures, adding mail, and modifying desktop text.

## Current State

MMC is playable as a mission-maker tool, but it is still under active development. The current focus is the computer shell, user system, files, pictures, and mail workflow.

Messenger, notes, richer media handling, and more polished computer-screen object textures are still future work. Video support was investigated and intentionally left out for now because Arma UI playback behavior is not reliable enough for the intended workflow.

## Mission-Maker Notes

- The `Register Computer` module turns synced objects into MMC computers.
- Zeus operators can use `ACE Zeus Actions > Computer` to list every registered computer, including computers created during the mission. The action opens powered computers and starts powered-off computers before opening them.
- The `Add User` module can be synced to specific registered computers. If it is not synced to a computer, the user is treated as globally available to registered computers unless a computer is marked as a closed system.
- Text, picture, and mail modules can be synced to an `Add User` module for user content, a registered computer object for one computer, or a `Register Computer` module for every computer registered by that module.
- Desktop modules can target users or computers depending on their sync setup.
- `Modify Desktop` should normally be synced to a `Register Computer` module for computer defaults, or to an `Add User` module for user-specific desktop text. Direct object sync still works as a fallback.
- Startup and login screens use a direct user layout first. If no user is added directly to that computer, they use a synced `Layout` module on the `Register Computer` module or computer object, then fall back to the client default.
- The `Layout` module syncs to `Register Computer` modules or registered computers and can set preset colors/backgrounds or custom mission-specific colors and a desktop picture.
- Uncheck standard app boxes on `Register Computer` to hide apps for the whole computer, or on `Add User` to hide apps only while that user is logged in.
- In-world screen textures are applied automatically only for supported 1x1 and 2x1 laptop/PC/TV objects. Add more supported device classes in `fn_getScreenDeviceConfig.sqf`.
- The `Layout` module can disable in-world screen texture application, or override the `setObjectTexture` selections with a comma-separated list such as `0` or `0,1`.
- Picture texture paths should point to valid `.paa` textures from the mission or a mod.
- The file path fields are paths inside the computer's file browser, not necessarily real filesystem paths.
- Audio playback currently relies on configured mod sounds. Mission-file audio is not treated as a reliable general-purpose file format yet.

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

`MMC_fnc_addAppUnitFeed`, `MMC_fnc_addAppUavFeed`, and `MMC_fnc_addAppVehicleFeed` create local render-to-texture picture-in-picture feeds and clean them up when the app changes or the computer is closed. See [docs/examples/uavInfoApp.sqf](docs/examples/uavInfoApp.sqf) for a selectable UAV screen, or [docs/examples/tacticalFeedsApp.sqf](docs/examples/tacticalFeedsApp.sqf) for unit, UAV, and vehicle feeds in one app.

Feed helpers accept an optional options hash map. Useful keys are `widthRatio`, `width`, `align`, `renderSize`, `updateInterval`, `fov`, and `pipEffect`. Vehicle and UAV feeds can also take `turretPath`; for example `["turretPath", [0]]` follows the main gunner turret on most vanilla vehicles. If a specific vehicle uses unusual memory points, pass `positionMemory` and `directionMemory` as well. If the model's camera axis is rotated, use `directionYaw` to nudge it in degrees.

To find turret paths while testing, sit a unit in the relevant seat and run `systemChat str ((gunner myVehicle) call CBA_fnc_turretPath);` or `systemChat str ((commander myVehicle) call CBA_fnc_turretPath);`. For many vanilla vehicles the main gunner is `[0]`, but modded vehicles can differ.

For very simple apps, the content can still be a structured text string or a code block that returns structured text. Use `[_computer, "generator"] call MMC_fnc_removeApp;` to remove an app again. A final `true` parameter on add/remove publishes the app list as an object variable, but use that only for network-safe app configs without code callbacks.

Standard apps can be hidden from script as well:

```sqf
[myLaptop, ["mail", "notes"]] call MMC_fnc_removeStandardApp;
[myLaptop, "files", "operator"] call MMC_fnc_removeStandardApp;
[myLaptop, "files", "operator"] call MMC_fnc_restoreStandardApp;
```

The `Modify Desktop` module also has an optional `Desktop Script File` field. If filled, that script is called with the same builder context, so a mission file can build a modular desktop using the same `MMC_fnc_addApp...` helpers.

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
