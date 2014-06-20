/*
 * Author: commy2
 *
 * Revert a key code to a readible text.
 * 
 * Argument:
 * 0: Key code (Number)
 * 
 * Return value:
 * What input will result in the given key code? (String)
 */

private ["_keyCode", "_key", "_alt", "_ctrl", "_shft"];

_keyCode = _this select 0;

_key = toString ((toArray keyName floor _keyCode) - [34]);

_keyCode = round ((_keyCode % 1) * 10);

_alt = _keyCode >= 4;
_ctrl = _keyCode >= [2, 6] select _alt;
_shift = _keyCode % 2 == 1;

format ["%1%2%3%4",
	["", format ["%1 + ", localize "STR_AGM_Core_Alt"]] select _alt,
	["", format ["%1 + ", localize "STR_AGM_Core_Ctrl"]] select _ctrl,
	["", format ["%1 + ", localize "STR_AGM_Core_Shift"]] select _shift,
	_key
]
