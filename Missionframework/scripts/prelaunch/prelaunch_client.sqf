/*
    File: prelaunch_client.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2026-02-21
    Last Update: 2026-02-21
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Client-side pre-launch handler. Spawned from initPlayerLocal.sqf on every
        interface machine. Waits to find out whether a dialog is needed (KPPL_waitingForAdmin)
        or whether init has already finished (KPLIB_initServer is set, which means the
        autoload path ran and we can exit immediately).

        If a dialog is required, non-admin players see a waiting hint. The admin machine
        opens the KPPL_prelaunch_dialog after polling until playerIsAdmin becomes true.

    Parameter(s):
        None

    Returns:
        Nothing
*/

// Compile KPPL functions on this client so dialog callbacks are available
[] call compileFinal preprocessFileLineNumbers "scripts\prelaunch\prelaunch_functions.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\prelaunch\prelaunch_factions.sqf";

// Wait until we know whether the gate is active or init already completed
waitUntil {
    sleep 0.5;
    !isNil "KPPL_waitingForAdmin" || !isNil "KPLIB_initServer"
};

// If the server already broadcast KPLIB_initServer, the autoload path ran —
// nothing left to do here.
if (!isNil "KPLIB_initServer") exitWith {};

// If no dialog is needed (shouldn't happen, but guard anyway), exit.
if (!KPPL_waitingForAdmin) exitWith {};

// Show a waiting hint for all players while admin configures
hint "KP Liberation\n\nWaiting for server administrator\nto configure the mission...";

// ── Admin detection ───────────────────────────────────────────────────────────
// Poll until either this client becomes admin or KPPL_prelaunch_done is set
// (meaning the dialog was completed or the autoload finished on another machine).
private _timeout = diag_tickTime + 300; // 5-minute poll limit
waitUntil {
    sleep 1;
    playerIsAdmin
    || (!isNil "KPPL_prelaunch_done" && KPPL_prelaunch_done)
    || (!isNil "KPPL_prelaunch_cancelled" && KPPL_prelaunch_cancelled)
    || diag_tickTime > _timeout
};

// If the mission was already released (another admin, or autoload), just clear hint
if (!isNil "KPLIB_initServer"
    || (!isNil "KPPL_prelaunch_done" && KPPL_prelaunch_done)
    || (!isNil "KPPL_prelaunch_cancelled" && KPPL_prelaunch_cancelled)) exitWith {
    hint "";
};

// Timed out and not admin — show a static waiting hint and wait for release
if (!playerIsAdmin) exitWith {
    waitUntil {
        sleep 1;
        (!isNil "KPPL_prelaunch_done" && KPPL_prelaunch_done)
        || (!isNil "KPPL_prelaunch_cancelled" && KPPL_prelaunch_cancelled)
        || !isNil "KPLIB_initServer"
    };
    hint "";
};

// ── Admin path: open the dialog ───────────────────────────────────────────────
hint "";
diag_log "[KPPL] Admin detected — opening pre-launch configuration dialog.";

// Record the admin's machine ID so hooks can detect admin disconnect
private _myId = owner player;
[_myId] remoteExec ["KPPL_fnc_registerAdminMachine", 2];

// Open the dialog
createDialog "KPPL_prelaunch_dialog";

// Wait for dialog to close (either Launch or Cancel was clicked)
waitUntil {
    sleep 0.5;
    (!isNil "KPPL_prelaunch_done" && KPPL_prelaunch_done)
    || (!isNil "KPPL_prelaunch_cancelled" && KPPL_prelaunch_cancelled)
};
