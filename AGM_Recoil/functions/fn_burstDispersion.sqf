// TMR: Small Arms - Recoil initialization and functions
// (C) 2013 Ryan Schultz. See LICENSE.
// Edited prefixes for compatability in AGM_Realism by KoffeinFlummi
// Edited by commy2

private ["_unit", "_weapon", "_projectile", "_ammo", "_lastFired", "_burst", "_startDisperse", "_vel", "_mag", "_vDir", "_elevAngle", "_travAngle", "_sightsBurst", "_maxBurst", "_x", "_y", "_z", "_upZ", "_k", "_upX", "_upY"];

_unit = _this select 0;
_weapon = _this select 1;
_ammo = _this select 4;
_projectile = _this select 5;

_lastFired = _unit getVariable ["AGM_Recoil_lastFired", -1];
_burst = _unit getVariable ["AGM_Recoil_Burst", 0];

if (time - _lastFired < 0.45) then {
    _burst = _burst + 1;
    _unit setVariable ["AGM_Recoil_Burst", _burst, false];

    _startDisperse = [1, 3] select (cameraView == "GUNNER");

    if (_burst > _startDisperse) then {
        _vel = velocity _projectile;
        _mag = _vel call BIS_fnc_magnitude;
        _vDir = vectorDir _projectile;

        // Convert bullet vector to angles (deg)
        _elevAngle = (_vDir select 0) atan2 (_vDir select 1);
        _travAngle = sqrt ((_vDir select 1) ^ 2 + (_vDir select 0) ^ 2 ) atan2 - (_vDir select 2);

        // Reset burst size for calcs
        _burst = _burst - _startDisperse;

        // Increase dispersion cap if player is not using sights
        _sightsBurst = [30, 0] select (cameraView == "GUNNER");

        // Increase initial dispersion and cap if player is moving
        if (speed player > 0.5) then {
            _sightsBurst = 25;
            _burst = _burst + 15;
        };

        // Maximum possible dispersion (without _sightsBurst mod)
        _maxBurst = 50;

        if (!(isNil "AGM_weaponRested") and {AGM_weaponRested}) then {_maxBurst = 25};
        if (!(isNil "AGM_bipodDeployed") and {AGM_bipodDeployed}) then {_maxBurst = 18};

        // Cap the dispersion
        _burst = (_burst min _maxBurst) + _sightsBurst;

        // Add random variance
        _elevAngle = _elevAngle + ((_burst / 300) - random (_burst / 300) * 2);
        _travAngle = _travAngle + ((_burst / 260) - random (_burst / 260) * 2);

        // Calculate new vectors (math based on ace_sys_sightadjustment)
        _vDir = [sin(_travAngle) * sin (_elevAngle), sin (_travAngle) * cos (_elevAngle), -cos (_travAngle)];
        _vel = [(_vDir select 0) * _mag, (_vDir select 1) * _mag, (_vDir select 2) * _mag];

        // Bullet to correct orientations (needed for tracers)
        _x = _dir select 0;
        _y = _dir select 1;
        _z = _dir select 2;
        _upZ = sqrt (_x ^ 2 + _y ^ 2);
        _k = -_z / _upZ;
        _upX = _k * _x;
        _upY = _k * _y;

        _projectile setVectorDirAndUp [_vDir, [_upX, _upY, _upZ]];
        _projectile setVelocity _vel;
    };
} else {

    // Long enough delay, reset burst
    _unit setVariable ["AGM_Recoil_Burst", 0, false];
};

_unit setVariable ["AGM_Recoil_lastFired", time];
