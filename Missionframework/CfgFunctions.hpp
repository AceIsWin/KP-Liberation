class KPLIB {
    class functions {
        file = "functions";

        class addActionsFob             {};
        class addActionsPlayer          {};
        class addObjectInit             {};
        class addRopeAttachEh           {};
        class allowCrewInImmobile       {};
        class checkClass                {};
        class checkCrateValue           {};
        class checkGear                 {};
        class checkWeaponCargo          {};
        class cleanOpforVehicle         {};
        class clearCargo                {};
        class crAddAceAction            {};
        class crateFromStorage          {};
        class crateToStorage            {};
        class crawlAllItems             {};
        class createClearance           {};
        class createClearanceConfirm    {};
        class createCrate               {};
        class createManagedUnit         {};
        class crGetMulti                {};
        class crGlobalMsg               {};
        class doSave                    {};
        class fillStorage               {};
        class forceBluforCrew           {};
        class getAdaptiveVehicle        {};
        class getBluforRatio            {};
        class getCommander              {};
        class getCrateHeight            {};
        class getFobName                {};
        class getFobResources           {};
        class getGroupType              {};
        class getLessLoadedHC           {};
        class getLoadout                {};
        class getLocalCap               {};
        class getLocationName           {};
        class getMilitaryId             {};
        class getMobileRespawns         {};
        class getNearbyPlayers          {};
        class getNearestBluforObjective {};
        class getNearestFob             {};
        class getNearestSector          {};
        class getNearestTower           {};
        class getNearestViVTransport    {};
        class getOpforCap               {};
        class getOpforFactor            {};
        class getOpforSpawnPoint        {};
        class getPlayerCount            {};
        class getResistanceTier         {};
        class getSaveableParam          {};
        class getSaveData               {};
        class getSectorOwnership        {};
        class getSectorRange            {};
        class getSquadComp              {};
        class getStoragePositions       {};
        class getUnitPositionId         {};
        class getUnitsCount             {};
        class getWeaponComponents       {};
        class handlePlacedZeusObject    {};
        class hasPermission             {};
        class initSectors               {};
        class isBigtownActive           {};
        class isClassUAV                {};
        class isRadio                   {};
        class log                       {};
        class potatoScan                {};
        class protectObject             {};
        class secondsToTimer            {};
        class setDiscordState           {};
        class setFobMass                {};
        class setLoadableViV            {};
        class setLoadout                {};
        class setVehicleCaptured        {};
        class setVehicleSeized          {};
        class sortStorage               {};
        class spawnBuildingSquad        {};
        class spawnCivilians            {};
        class spawnGuerillaGroup        {};
        class spawnMilitaryPostSquad    {};
        class spawnMilitiaCrew          {};
        class spawnRegularSquad         {};
        class spawnVehicle              {};
        class swapInventory             {};

        // LAMBS Danger FSM integration
        class findClosestTarget         {};     // [unit, range] call KPLIB_fnc_findClosestTarget
        class findBuildings             {};     // [pos, range, minPositions] call KPLIB_fnc_findBuildings
        class doUgl                     {};     // [unit, targetPos] call KPLIB_fnc_doUgl
        class creep                     {};     // [grp, targetPos, range] call KPLIB_fnc_creep
        class hunt                      {};     // [grp, targetPos, range] call KPLIB_fnc_hunt
        class rush                      {};     // [grp, targetPos, range] call KPLIB_fnc_rush
        class garrison                  {};     // [grp, targetPos, range] call KPLIB_fnc_garrison
    };
    class functions_curator {
        file = "functions\curator";

        class initCuratorHandlers       {
            postInit = 1;
        };
        class requestZeus               {};
    };
    class functions_ui {
        file = "functions\ui";

        class overlayUpdateResources    {};
    };
    #include "scripts\client\CfgFunctions.hpp"
    #include "scripts\server\CfgFunctions.hpp"
};
