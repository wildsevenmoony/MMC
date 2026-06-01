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
			class addActions {};
			class canOpen {};
			class createDefaultData {};
			class initDisplay {};
			class addMailModule {};
			class addTextFileModule {};
			class open {};
			class registerComputerModule {};
			class registerObject {};
			class renderApp {};
			class setPowerState {};
			class shutdown {};
			class startComputer {};
			class startup {};
			class toggleStartMenu {};
			class updateClock {};
		};

		class ZeusModules {
			file = PATHTOF(fnc\zenmodule);
			class zenInit {postInit = 1;};
			class addMailZeus {};
			class addTextFileZeus {};
			class powerOffZeus {};
			class powerOnZeus {};
			class registerComputerZeus {};
		};
	};
};
