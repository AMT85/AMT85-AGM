// commy 2

_vehicle = _this select 0;
_item = _this select 1;

_loadedItems = _vehicle getVariable ["AGM_Logistics_loadedItems", []];

_count = count _loadedItems;

if (_count == 0) exitWith {};

[10, [_vehicle, _item], "AGM_Logistics_unloadBoxCallback", "Unloading ..."] call AGM_Core_fnc_progressBar;
