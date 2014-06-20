// BWA3 Realism - Core
// (C) 2013 KoffeinFlummi. See LICENSE.

"AGM_Core_remoteFnc" addPublicVariableEventHandler {
	(_this select 1) call AGM_Core_fnc_execRemoteFnc;
};

if (isDedicated) exitWith {};

AGM_Core_keyInput  = compile preprocessFileLineNumbers "\AGM_core\scripts\keyInput.sqf";
AGM_Core_editKey   = compile preprocessFileLineNumbers "\AGM_core\scripts\editKey.sqf";
AGM_Core_openMenu  = compile preprocessFileLineNumbers "\AGM_core\scripts\openMenu.sqf";
AGM_Core_closeMenu = compile preprocessFileLineNumbers "\AGM_core\scripts\closeMenu.sqf";

call AGM_Core_fnc_setKeyDefault;

call compile preprocessFileLineNumbers "\AGM_core\scripts\KeyInput\initKeys.sqf";

0 spawn {
	while {true} do {
		waitUntil {!isNull (findDisplay 46)}; sleep 1;
		(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call AGM_Core_onKeyDown"];
		(findDisplay 46) displayAddEventHandler ["KeyUp", "_this call AGM_Core_onKeyUp"];
		waitUntil {isNull (findDisplay 46)};
	};
};

0 spawn {
	sleep 1;
	player setVariable ["AGM_Name", name player, true];
};
