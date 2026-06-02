# Moony's Magnificent Computers

Moony's Magnificent Computers, or MMC, is an Arma 3 framework for interactive in-mission computer systems. Mission makers can register laptops, PCs, or other objects as computers and use them for files, pictures, e-mail, user accounts, and mission intel.

## Features

- Register objects as computers through Eden modules, Zeus modules, or script.
- Open registered computers through ACE interaction.
- Power states with startup, shutdown, login, desktop, and powered-off flows.
- PC-style screen with desktop background, taskbar, clock/date, start menu, and app buttons.
- User accounts with username, password, e-mail address, background, optional forced layout, and closed-system support.
- Client CBA settings for theme, preferred background, and logging out when the computer dialog is closed.
- Theme layouts for dark, light, profile color, BLUFOR, OPFOR, Independent, and Civilian styles.
- File browser with folders for text files, pictures, and audio files.
- Text files and desktop text support structured text, image tags, and `\n` or `<br/>` line breaks.
- Picture files support a texture path and description shown below the image.
- Mail app with inbox, outbox, unread/read state, reply, forward, CC, picture attachment support, and mission-time timestamps.
- Zeus modules for adding users, text files, pictures, mail, registering computers, changing power state, and modifying desktop text.
- Eden modules for registering computers, adding users, adding text files, adding pictures, adding mail, and modifying desktop text.

## Current State

MMC is playable as a mission-maker tool, but it is still under active development. The current focus is the computer shell, user system, files, pictures, and mail workflow.

Messenger, notes, richer media handling, and more polished computer-screen object textures are still future work. Video support was investigated and intentionally left out for now because Arma UI playback behavior is not reliable enough for the intended workflow.

## Mission-Maker Notes

- The `Register Computer` module turns synced objects into MMC computers.
- The `Add User` module can be synced to specific registered computers. If it is not synced to a computer, the user is treated as globally available to registered computers unless a computer is marked as a closed system.
- Text, picture, mail, and desktop modules can target users or computers depending on their sync setup.
- Picture texture paths should point to valid `.paa` textures from the mission or a mod.
- The file path fields are paths inside the computer's file browser, not necessarily real filesystem paths.
- Audio playback currently relies on configured mod sounds. Mission-file audio is not treated as a reliable general-purpose file format yet.

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
