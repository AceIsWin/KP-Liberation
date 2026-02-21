/*
    File: prelaunch_factions.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2026-02-21
    Last Update: 2026-02-21
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Faction definitions for the pre-launch configuration dialog.
        Each entry format: [displayName, presetIndex, detectionClass, modLabel]
        - presetIndex: matches switch/case in presets/init_presets.sqf exactly
        - detectionClass: classname checked via isClass in CfgVehicles/CfgWeapons/CfgPatches
          Use "" for vanilla/DLC entries (always available)
        - modLabel: human-readable mod name shown in "not loaded" tooltip

    Parameter(s):
        None (populates global arrays)

    Returns:
        Nothing
*/

// BLUFOR presets — indices 0-30, matching presets/init_presets.sqf switch/case
KPPL_factions_blufor = [
    ["Custom (Vanilla NATO)",           0,  "",                                 "Vanilla"],
    ["Apex Protocol (Tanoa)",           1,  "",                                 "Apex DLC"],
    ["3CB BAF (MTP)",                   2,  "UK3CB_BAF_O_Men_Core",             "3CB BAF"],
    ["3CB BAF (Desert)",                3,  "UK3CB_BAF_O_Men_Core",             "3CB BAF"],
    ["BWMod Bundeswehr (Flecktarn)",    4,  "BWA3_Men_Fleck",                   "BWMod"],
    ["BWMod Bundeswehr (Tropentarn)",   5,  "BWA3_Men_Fleck",                   "BWMod"],
    ["RHS USAF (Woodland)",             6,  "rhsusf_usmc_machinegunner",        "RHS USAF"],
    ["RHS USAF (Desert)",               7,  "rhsusf_usmc_machinegunner",        "RHS USAF"],
    ["RHS AFRF (VDV/MSV)",             8,  "rhs_soldier_vdv",                  "RHS AFRF"],
    ["Global Mob. Germany-W",           9,  "gm_ge_army_rifleman_70_fg",        "Global Mobilization DLC"],
    ["Global Mob. Germany-W Winter",    10, "gm_ge_army_rifleman_70_fg",        "Global Mobilization DLC"],
    ["Global Mob. Germany-E",           11, "gm_ge_army_rifleman_70_fg",        "Global Mobilization DLC"],
    ["Global Mob. Germany-E Winter",    12, "gm_ge_army_rifleman_70_fg",        "Global Mobilization DLC"],
    ["CSAT (Brown)",                    13, "",                                 "Vanilla"],
    ["CSAT (Green)",                    14, "",                                 "Vanilla"],
    ["Unsung US Forces",                15, "uns_r_soldier_M",                  "Unsung"],
    ["CUP BAF (Desert)",                16, "CUP_B_BAF_Soldier_SAS_D",          "CUP Units"],
    ["CUP BAF (Woodland)",              17, "CUP_B_BAF_Soldier_SAS_D",          "CUP Units"],
    ["CUP USMC (Desert)",               18, "CUP_B_USMC_Soldier",               "CUP Units"],
    ["CUP USMC (Woodland)",             19, "CUP_B_USMC_Soldier",               "CUP Units"],
    ["CUP US Army (Desert)",            20, "CUP_B_US_Soldier_AT",              "CUP Units"],
    ["CUP US Army (Woodland)",          21, "CUP_B_US_Soldier_AT",              "CUP Units"],
    ["CUP CDF",                         22, "CUP_O_CDF_Soldier_Militia",        "CUP Units"],
    ["CUP ACR (Desert)",                23, "CUP_B_ACR_Soldier",                "CUP Units"],
    ["CUP ACR (Woodland)",              24, "CUP_B_ACR_Soldier",                "CUP Units"],
    ["CUP ChDKZ",                       25, "CUP_O_ChDKZ_Soldier",              "CUP Units"],
    ["CUP SLA",                         26, "CUP_O_SLA_Soldier_Rifleman",       "CUP Units"],
    ["CUP Takistani Army",              27, "CUP_O_TKA_Soldier_Rifleman",       "CUP Units"],
    ["SFP (Woodland)",                  28, "SFP_SweArmyRifleman",              "SFP"],
    ["SFP (Desert)",                    29, "SFP_SweArmyRifleman",              "SFP"],
    ["LDF (Contact DLC)",               30, "I_C_Soldier_Bandit_5_F",           "Contact DLC"]
];

// OPFOR presets — indices 0-20, matching presets/init_presets.sqf switch/case
KPPL_factions_opfor = [
    ["Custom (Vanilla CSAT)",           0,  "",                                 "Vanilla"],
    ["Apex Protocol (Tanoa)",           1,  "",                                 "Apex DLC"],
    ["RHS AFRF (EMR/MSV)",             2,  "rhs_soldier_vdv",                  "RHS AFRF"],
    ["Project OPFOR (Takistan)",        3,  "CUP_O_TKA_Soldier_Rifleman",       "Project OPFOR + CUP Units"],
    ["Project OPFOR (Islamic State)",   4,  "CUP_O_TKA_Soldier_Rifleman",       "Project OPFOR + CUP Units"],
    ["Project OPFOR (Sahrani)",         5,  "CUP_O_SLA_Soldier_Rifleman",       "Project OPFOR + CUP Units"],
    ["AAF",                             6,  "",                                 "Vanilla"],
    ["NATO",                            7,  "",                                 "Vanilla"],
    ["Global Mob. Germany-W",           8,  "gm_ge_army_rifleman_70_fg",        "Global Mobilization DLC"],
    ["Global Mob. Germany-W Winter",    9,  "gm_ge_army_rifleman_70_fg",        "Global Mobilization DLC"],
    ["Global Mob. Germany-E",           10, "gm_ge_army_rifleman_70_fg",        "Global Mobilization DLC"],
    ["Global Mob. Germany-E Winter",    11, "gm_ge_army_rifleman_70_fg",        "Global Mobilization DLC"],
    ["Unsung NVA",                      12, "uns_vietcong1",                    "Unsung"],
    ["CUP SLA",                         13, "CUP_O_SLA_Soldier_Rifleman",       "CUP Units"],
    ["CUP Takistani Army",              14, "CUP_O_TKA_Soldier_Rifleman",       "CUP Units"],
    ["CUP ChDKZ",                       15, "CUP_O_ChDKZ_Soldier",              "CUP Units"],
    ["CUP AFRF (EMR)",                  16, "CUP_O_RU_Soldier",                 "CUP Units"],
    ["CUP AFRF (Modern MSV)",           17, "CUP_O_RU_Soldier",                 "CUP Units"],
    ["CUP CDF",                         18, "CUP_O_CDF_Soldier_Militia",        "CUP Units"],
    ["CUP BAF (Desert)",                19, "CUP_B_BAF_Soldier_SAS_D",          "CUP Units"],
    ["CUP BAF (Woodland)",              20, "CUP_B_BAF_Soldier_SAS_D",          "CUP Units"]
];

// Resistance presets — indices 0-8, matching presets/init_presets.sqf switch/case
KPPL_factions_resistance = [
    ["Custom (Vanilla FIA)",            0,  "",                                 "Vanilla"],
    ["Apex Protocol (Tanoa)",           1,  "",                                 "Apex DLC"],
    ["RHS GREF",                        2,  "rhs_faction_mercs",                "RHS GREF"],
    ["Project OPFOR (Middle Eastern)",  3,  "CUP_O_TKA_Soldier_Rifleman",       "Project OPFOR + CUP Units"],
    ["Project OPFOR (Sahrani)",         4,  "CUP_O_SLA_Soldier_Rifleman",       "Project OPFOR + CUP Units"],
    ["Global Mob. Germany",             5,  "gm_ge_army_rifleman_70_fg",        "Global Mobilization DLC"],
    ["Unsung",                          6,  "uns_vietcong1",                    "Unsung"],
    ["CUP Takistani Locals",            7,  "CUP_O_TKA_Soldier_Rifleman",       "CUP Units"],
    ["CUP NPC Chernarus",               8,  "CUP_O_ChDKZ_Soldier",              "CUP Units"]
];

// Civilian presets — indices 0-7, matching presets/init_presets.sqf switch/case
KPPL_factions_civilian = [
    ["Custom (Vanilla)",                0,  "",                                 "Vanilla"],
    ["Apex Protocol (Tanoa)",           1,  "",                                 "Apex DLC"],
    ["Project OPFOR (Middle Eastern)",  2,  "CUP_O_TKA_Soldier_Rifleman",       "Project OPFOR + CUP Units"],
    ["RDS Civilians",                   3,  "RDS_Civilian_Villager1",           "RDS Civilian Pack"],
    ["Global Mob. Germany",             4,  "gm_ge_army_rifleman_70_fg",        "Global Mobilization DLC"],
    ["Unsung",                          5,  "uns_vietcong1",                    "Unsung"],
    ["CUP Takistani Civilians",         6,  "CUP_C_Man_Takistan_01",            "CUP Units"],
    ["CUP Chernarussian Civilians",     7,  "CUP_C_Man_Chernarus_01",           "CUP Units"]
];

// Arsenal presets — indices 0-16, matching init_client.sqf switch/case
KPPL_factions_arsenal = [
    ["Default (Vanilla Blacklist)",     0,  "",                                 "Vanilla"],
    ["Custom Arsenal",                  1,  "",                                 "Vanilla"],
    ["RHS USAF",                        2,  "rhsusf_usmc_machinegunner",        "RHS USAF"],
    ["3CB BAF",                         3,  "UK3CB_BAF_O_Men_Core",             "3CB BAF"],
    ["Global Mob. West Germany",        4,  "gm_ge_army_rifleman_70_fg",        "Global Mobilization DLC"],
    ["Global Mob. East Germany",        5,  "gm_ge_army_rifleman_70_fg",        "Global Mobilization DLC"],
    ["CSAT",                            6,  "",                                 "Vanilla"],
    ["Unsung",                          7,  "uns_r_soldier_M",                  "Unsung"],
    ["SFP",                             8,  "SFP_SweArmyRifleman",              "SFP"],
    ["BWMod",                           9,  "BWA3_Men_Fleck",                   "BWMod"],
    ["Vanilla NATO (MTP)",              10, "",                                 "Vanilla"],
    ["Vanilla NATO (Tropic)",           11, "",                                 "Vanilla"],
    ["Vanilla NATO (Woodland)",         12, "",                                 "Vanilla"],
    ["Vanilla CSAT (Hex)",              13, "",                                 "Vanilla"],
    ["Vanilla CSAT (Green Hex)",        14, "",                                 "Vanilla"],
    ["Vanilla AAF",                     15, "",                                 "Vanilla"],
    ["Vanilla LDF (Contact DLC)",       16, "I_C_Soldier_Bandit_5_F",           "Contact DLC"]
];
