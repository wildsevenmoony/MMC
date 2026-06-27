/*
 * Author: Moony
 * Registers MMC scripted functions by category.
 */

class CfgFunctions {
	class PREFIX {
		class ComputerCore {
			file = PATHTOF(fnc\core);
			class addActions {};
			class addZeusActions {};
			class canOpen {};
			class clearCustomControls {};
			class createAppBorder {};
			class createDefaultData {};
			class debugLog {};
			class ensureAutoLoginUser {};
			class formatMailDate {};
			class getActiveUser {};
			class getDisabledAppsFromConfig {};
			class getRegisteredComputers {};
			class getRegisteredUsers {};
			class handleDisplayUnload {};
			class initDisplay {};
			class isStandardAppEnabled {};
			class nextDynamicIdc {};
			class normalizeStandardAppIds {};
			class normalizeStructuredText {};
			class open {};
			class openFromZeus {};
			class refreshAppButtons {};
			class refreshStandardApps {};
			class removeApp {};
			class removeStandardApp {};
			class renderApp {};
			class restoreStandardApp {};
			class showNotificationLocal {};
			class setStandardAppHidden {};
			class updateClock {};
			class zeusComputerChildren {};
		};

		class ComputerPower {
			file = PATHTOF(fnc\power);
			class handleDestroyed {};
			class handleDestroyedLocal {};
			class hideLogin {};
			class login {};
			class logout {};
			class logoutCurrent {};
			class setPowerState {};
			class setScreenState {};
			class setSystemOverlay {};
			class showLogin {};
			class showNoUser {};
			class shutdown {};
			class startComputer {};
			class startup {};
			class togglePasswordVisibility {};
			class toggleStartMenu {};
			class updatePasswordInput {};
		};

		class ComputerLayout {
			file = PATHTOF(fnc\layout);
			class applyTheme {};
			class getBackgroundPath {};
			class getLayoutFromModule {};
			class getScreenDeviceConfig {};
			class getScreenTexture {};
			class getThemeConfig {};
			class setComputerLayout {};
		};

		class ComputerMobile {
			file = PATHTOF(fnc\mobile);
			class addDevicePickupActionLocal {};
			class addMobileActions {};
			class addMobileDeviceItemLocal {};
			class applyMobileDisplayLayout {};
			class applyMobileProfile {};
			class applyMobileProfileLocal {};
			class enrichMobileProfileFromModules {};
			class ensureUniqueMobileDevicesLocal {};
			class getMobileAccessItems {};
			class getMobileAliasesForPlayer {};
			class getMobileDeviceType {};
			class getMobileDeviceTypes {};
			class getMobileInventoryDevices {};
			class hasMobileDeviceItem {};
			class mobileDeviceChildren {};
			class openMobile {};
			class openMobileLocal {};
			class openMobileServer {};
			class pickUpDevice {};
			class pickUpDeviceServer {};
			class receivePickedDeviceLocal {};
			class receiveUniqueMobileDevicesLocal {};
			class refreshMobileProfilesFromModules {};
			class registerDeviceObject {};
			class registerMobileProfile {};
			class requestUniqueMobileDevices {};
			class selectMobileProfiles {};
			class setMobileOrientationServer {};
			class setMobileLockInput {};
			class showMobileLock {};
			class handleMobileLockKey {};
			class toggleMobileOrientation {};
			class unlockMobile {};
		};

		class ComputerModules {
			file = PATHTOF(fnc\modules);
			class addAudioModule {};
			class addMailModule {};
			class addPictureModule {};
			class addTextFileModule {};
			class addUser {};
			class addUserModule {};
			class assignMobileProfileModule {};
			class customLayoutModule {};
			class mobileProfileModule {};
			class modifyDesktop {};
			class modifyDesktopModule {};
			class registerComputerModule {};
			class registerObject {};
		};

		class ComputerAppBuilder {
			file = PATHTOF(fnc\appbuilder);
			class addApp {};
			class addAppBox {};
			class addAppButton {};
			class addAppCheckbox {};
			class addAppCleanup {};
			class addAppCombo {};
			class addAppControl {};
			class addAppEdit {};
			class addAppLine {};
			class addAppProgressBar {};
			class addAppSpacer {};
			class addAppStructuredText {};
			class addAppUnitFeed {};
			class addAppUavFeed {};
			class addAppVehicleFeed {};
			class customAppAction {};
			class getAppControlValue {};
			class parseAppColor {};
			class renderCustomApp {};
			class runAppBuilderContent {};
			class setAppControlText {};
			class setAppProgressBar {};
			class setButtonHover {};
		};

		class ComputerFiles {
			file = PATHTOF(fnc\apps_files);
			class addFile {};
			class addFileToUser {};
			class fileSelectButton {};
			class getAudioFiles {};
			class getFileDisplayName {};
			class mediaNavigate {};
			class mediaPlaySelected {};
			class normalizeAudioClass {};
			class mediaStop {};
			class playAudio {};
			class playAudioLocal {};
			class stopAudio {};
			class stopAudioLocal {};
		};

		class ComputerMail {
			file = PATHTOF(fnc\apps_mail);
			class addAddressBookEntry {};
			class addMail {};
			class addMailToUser {};
			class findUserByEmail {};
			class getAddressBookEntries {};
			class mailAddressBookDelete {};
			class mailAddressBookSave {};
			class mailAddressBookSaveSelectedMail {};
			class mailAddressBookSelect {};
			class mailAddressBookUpdateSaveState {};
			class mailAddressBookUse {};
			class mailAttachmentPickerSelect {};
			class mailCompose {};
			class mailGetVisibleFiles {};
			class mailNormalizeAttachments {};
			class mailSelect {};
			class mailSendFromComposer {};
			class mailSendResult {};
			class makeUniqueEmail {};
			class markMailRead {};
			class normalizeAddressBook {};
			class renderMail {};
			class resizeMailBody {};
			class scrollMailTable {};
			class seedMail {};
			class sendMail {};
			class sendMailRequest {};
			class setMobileEmailAliases {};
			class setUserEmailAliases {};
		};

		class ComputerMessenger {
			file = PATHTOF(fnc\apps_messenger);
			class addMessage {};
			class getMessengerDevices {};
			class getMessengerIdentity {};
			class getMessengerIdentityForUser {};
			class getMessengerSideFromTheme {};
			class renderMessenger {};
			class sendMessengerFromInput {};
			class sendMessengerMessage {};
			class syncMessengerMessagesLocal {};
		};

		class ComputerNotes {
			file = PATHTOF(fnc\apps_notes);
			class addNote {};
			class notesAutosave {};
			class notesDelete {};
			class notesMail {};
			class notesNew {};
			class notesSave {};
			class renderNotes {};
		};

		class ZeusModules {
			file = PATHTOF(fnc\zenmodule);
			class zenInit {postInit = 1;};
			class addAddressBookZeus {};
			class addAudioZeus {};
			class addMailZeus {};
			class addPictureZeus {};
			class addTextFileZeus {};
			class addUserZeus {};
			class modifyDesktopZeus {};
			class confirmAddAudioDialog {};
			class confirmAddMailDialog {};
			class confirmAddNoteDialog {};
			class confirmAddPictureDialog {};
			class confirmModifyDesktopDialog {};
			class confirmAddTextFileDialog {};
			class guiAddAudioDialog {};
			class guiAddMailDialog {};
			class guiAddNoteDialog {};
			class guiAddPictureDialog {};
			class guiModifyDesktopDialog {};
			class guiAddTextFileDialog {};
			class addNoteZeus {};
			class assignMobileProfileZeus {};
			class powerOffZeus {};
			class powerOnZeus {};
			class registerComputerZeus {};
		};
	};
};
