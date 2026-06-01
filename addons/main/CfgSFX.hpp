/*
 * Author: Moony
 * Registers looping sound effects used by MMC media playback.
 */

class CfgSFX {
	class GVAR(testaudio) {
		sounds[] = {"sound0"};
		sound0[] = {PATHTOF(snd\testaudio.ogg), 1, 1, 40, 1, 0, 0, 0};
		empty[] = {"", 0, 0, 0, 0, 0, 0, 0};
	};
};
