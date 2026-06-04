/*
 * Author: Moony
 * Registers MMC scripted functions by category.
 */

class CfgFunctions {
	class PREFIX {
		class Computer {
			file = PATHTOF(fnc\computer);
			class addFile {};
			class addFileToUser {};
			class addMail {};
			class addMailToUser {};
			class addMessage {};
			class addNote {};
			class addUser {};
			class addUserModule {};
			class addActions {};
			class canOpen {};
			class createDefaultData {};
			class customLayoutModule {};
			class findUserByEmail {};
			class formatMailDate {};
			class getActiveUser {};
			class getAudioFiles {};
			class getLayoutFromModule {};
			class getRegisteredUsers {};
			class getScreenDeviceConfig {};
			class getScreenTexture {};
			class getThemeConfig {};
			class initDisplay {};
			class handleDestroyed {};
			class handleDestroyedLocal {};
			class handleDisplayUnload {};
			class addMailModule {};
			class addPictureModule {};
			class addTextFileModule {};
			class modifyDesktop {};
			class modifyDesktopModule {};
			class normalizeStructuredText {};
			class applyTheme {};
			class getBackgroundPath {};
			class hideLogin {};
			class login {};
			class logoutCurrent {};
			class logout {};
			class mailCompose {};
			class mailSelect {};
			class mailSendFromComposer {};
			class markMailRead {};
			class makeUniqueEmail {};
			class mediaNavigate {};
			class mediaPlaySelected {};
			class mediaStop {};
			class open {};
			class playAudio {};
			class playAudioLocal {};
			class registerComputerModule {};
			class registerObject {};
			class renderApp {};
			class renderMail {};
			class resizeMailBody {};
			class sendMail {};
			class seedMail {};
			class setScreenState {};
			class setComputerLayout {};
			class setPowerState {};
			class setSystemOverlay {};
			class showLogin {};
			class shutdown {};
			class startComputer {};
			class stopAudio {};
			class stopAudioLocal {};
			class startup {};
			class toggleStartMenu {};
			class togglePasswordVisibility {};
			class setButtonHover {};
			class updatePasswordInput {};
			class updateClock {};
		};

		class ZeusModules {
			file = PATHTOF(fnc\zenmodule);
			class zenInit {postInit = 1;};
			class addMailZeus {};
			class addPictureZeus {};
			class addTextFileZeus {};
			class addUserZeus {};
			class modifyDesktopZeus {};
			class confirmAddMailDialog {};
			class confirmAddPictureDialog {};
			class confirmModifyDesktopDialog {};
			class confirmAddTextFileDialog {};
			class guiAddMailDialog {};
			class guiAddPictureDialog {};
			class guiModifyDesktopDialog {};
			class guiAddTextFileDialog {};
			class powerOffZeus {};
			class powerOnZeus {};
			class registerComputerZeus {};
		};
	};
};
