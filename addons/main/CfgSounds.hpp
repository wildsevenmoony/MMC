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
};
