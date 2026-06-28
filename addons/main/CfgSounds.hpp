/*
 * Author: Moony
 * Declares local UI notification sounds used by MMC apps.
 */

class CfgSounds {
	class GVAR(phoneVibrate) {
		name = QGVAR(phoneVibrate);
		sound[] = {PATHTOF(snd\phone_vibrate.ogg), 1, 1, 30};
		titles[] = {};
	};

	class GVAR(mailNotification) {
		name = QGVAR(mailNotification);
		sound[] = {PATHTOF(snd\mail_notification.ogg), 1, 1, 30};
		titles[] = {};
	};

#define MMC_SOUND_CLASS(var1,file1) class GVAR(var1) { \
	name = QGVAR(var1); \
	sound[] = {PATHTOF(snd\file1), 1, 1, 35}; \
	titles[] = {}; \
}

	MMC_SOUND_CLASS(hack1,hack_01.ogg);
	MMC_SOUND_CLASS(hack2,hack_02.ogg);
	MMC_SOUND_CLASS(hack3,hack_03.ogg);
	MMC_SOUND_CLASS(hack4,hack_04.ogg);
	MMC_SOUND_CLASS(hack5,hack_05.ogg);
	MMC_SOUND_CLASS(hack6,hack_06.ogg);
	MMC_SOUND_CLASS(hack7,hack_07.ogg);

#undef MMC_SOUND_CLASS
};
