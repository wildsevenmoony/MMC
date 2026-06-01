# Moony's Magnificent Computer

Moony's Magnificent Computer, or MMC, is planned as an Arma 3 framework for interactive in-mission computers. Mission makers will be able to attach a computer system to objects, define whether it starts powered on or off, and let players open a PC-style screen with apps, files, and mission intel.

## Planned Features

- Computer object setup:
  - Attach an MMC computer to laptops, PCs, or any object through Eden and Zeus tooling.
  - Configure default power state, background, available users, and starting files.
- PC screen dialog:
  - Desktop view with background, task bar, start button, clock, date, and power controls.
  - Startup and shutdown flow.
  - Placeholder textures until final art exists.
- Files and folders:
  - Mission-defined folder structure.
  - Text notes and intel files.
  - Picture files using predefined textures.
  - Audio playback from configured sounds.
  - Video support if it proves practical in Arma UI.
- Programs:
  - Mail between configured accounts.
  - Messenger-style conversations.
  - Text/notes editor.
  - Extra utility apps as the framework grows.
- Mission maker tools:
  - Eden and Zeus modules for creating computers and adding files, mail, messages, or notes.
  - CBA settings for player profile defaults such as login name, password, and background selection.

## Current State

This repository currently contains the initial HEMTT/Git scaffold and a minimal `main` addon. The first implementation pass should focus on the core data model and a simple openable desktop dialog before adding individual apps.

## Requirements

- Arma 3
- CBA
- ACE

## Building

This repository is structured as a HEMTT-based Arma 3 mod project.

Common commands:

```sh
hemtt check
hemtt build
hemtt release
```

Generated build output, releases, private keys, and packed PBO files are ignored by Git.

## Notes

Advanced Equipment's Unix-style computer system is useful prior art for feature ideas and mission workflows. MMC is set up as a fresh project so it can follow Moony's existing mod structure and grow toward a PC-style interface.

## License

See [LICENSE](LICENSE).
