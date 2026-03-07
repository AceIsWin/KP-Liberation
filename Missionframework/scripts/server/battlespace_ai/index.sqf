/*
    File: index.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2024-01-01
    Last Update: 2024-01-01
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Battlespace AI System - main compilation entry point.
        Loads all battlespace AI subsystems. Must run on all machines
        (server and clients) so Zeus visualization compiles everywhere.

        Replaces: manage_patrols.sqf, civilian_patrols.sqf, readiness_increase.sqf

        Requires: LAMBS Danger (lambs_danger), CBA A3

    Parameter(s):
        None

    Returns:
        Nothing
*/

[] call compileFinal preprocessFileLineNumbers "scripts\server\battlespace_ai\config.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\server\battlespace_ai\networked_sectors\index.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\server\battlespace_ai\sams\index.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\server\battlespace_ai\defenders\index.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\server\battlespace_ai\artillery\index.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\server\battlespace_ai\task_forces\index.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\server\battlespace_ai\logistics\index.sqf";

// Module that evaluates battlespace conditions and determines to
// Send resupply of manpower / resources / whatever to a sector
// Send battlegroups
// Send patrols
// Initialize defending / reinforcing a town with static defenses
// Create and spawn SAM sites when it detects blufor presence

// Each sector has a pool of resources
// Manpower = infantry
// Specific SAM launchers
// Specific SAM radars
// Specific SAM missile
// Classes of vehicles (i.e. MBT, scout car, IFV, APC)
// Upon activating a sector normally, the defenders would be spawned by pulling from a pool of resources

// Once a sector falls below a certain threshold, the AI requests a resupply to head towards the sector, with a respawn timer in case its been intercepted before to prevent spam.
// If a sector is a frontline sector
// if it reaches above a certain threshold, it rolls to determine if it should consume resources to send out a battlegroup to try and capture the BLUFOR sector it is linked to
// if it reaches above a certain threshold, it rolls to determine if it should send out a patrol towards the BLUFOR sector and neighboring area

// If a sector is a backline sector
// If it reaches above a certain threshold and a frontline sector it is linked to comes under attack, it rolls to determine if it should consume resources to send reinforcements.
// If it reaches above a certain threshold, it rolls to determine if it should consume resources to send out resupply / reinforcement convoys on its own




// Every half hr, re-evaluate the conditions of sectors and adjust accordingly
// This general tick is usually for sending emergency resupplies, or transferring supplies, or battlegroups / patrols.
// Reinforcements are independently handled as an event when a sector goes live and begins to take casualties as part of the "Sector Defender" AI decision.
// Rearming of SAM or Artillery groups will pull from the nearest sector's resource pool to replenish their ammunition expenditure.
// If ammo is all expended, usually a request for resupply will be sent, and other sectors may decide to send a portion of their own stocks to resupply.

// Calculate every 30 minutes for macro scale logistics and offensive actions
