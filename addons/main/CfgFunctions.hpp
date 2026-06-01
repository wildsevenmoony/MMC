/*
 * Author: Moony
 * Registers MMC scripted functions by category.
 */

class CfgFunctions {
	class PREFIX {
		class Computer {
			file = PATHTOF(fnc\computer);
			class addFile {};
			class addMail {};
			class addMessage {};
			class addNote {};
			class addUser {};
			class addUserModule {};
			class addActions {};
			class canOpen {};
			class createDefaultData {};
			class createProfileUser {};
			class getActiveUser {};
			class initDisplay {};
			class handleDisplayUnload {};
			class addMailModule {};
			class addTextFileModule {};
			class applyTheme {};
			class getBackgroundPath {};
			class hideLogin {};
			class login {};
			class logoutCurrent {};
			class logout {};
			class open {};
			class registerComputerModule {};
			class registerObject {};
			class renderApp {};
			class setPowerState {};
			class setSystemOverlay {};
			class showLogin {};
			class shutdown {};
			class startComputer {};
			class startup {};
			class toggleStartMenu {};
			class togglePasswordVisibility {};
			class setButtonHover {};
			class updateClock {};
		};

		class ZeusModules {
			file = PATHTOF(fnc\zenmodule);
			class zenInit {postInit = 1;};
			class addMailZeus {};
			class addTextFileZeus {};
			class addUserZeus {};
			class powerOffZeus {};
			class powerOnZeus {};
			class registerComputerZeus {};
		};
	};
};
