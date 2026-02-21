/*
    File: initPlayerLocal.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2026-02-21
    Last Update: 2026-02-21
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Standard Arma 3 per-player local init callback. Runs on each player's local
        machine in a separate scheduled environment from init.sqf. Used to trigger the
        pre-launch configuration dialog (for admin) or the wait screen (for other
        players) while init.sqf may be blocked waiting for the server to complete
        pre-launch configuration.

    Parameter(s):
        None

    Returns:
        Nothing
*/

// Only run on machines with a player interface (not HC, not dedicated server)
if (!hasInterface) exitWith {};

[] spawn {
    [] call compileFinal preprocessFileLineNumbers "scripts\prelaunch\prelaunch_client.sqf";
};
