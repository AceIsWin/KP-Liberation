/*
    File: prelaunch_dialog.hpp
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2026-02-21
    Last Update: 2026-02-21
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Pre-launch mission configuration dialog (IDD 9100).
        Shown to the server admin before any preset or configuration is loaded.
        Allows selection of BLUFOR/OPFOR/Resistance/Civilian faction presets,
        arsenal preset, unit cap, and a custom save-slot name.

        IDC range: 9100-9131
        Controls inherit from StdBG, StdText, StdHeader, StdButton, StdCombo,
        StdEdit (all defined in ui/standard_controls.hpp via
        ui/liberation_interface.hpp).
*/

class KPPL_prelaunch_dialog {
    idd = 9100;
    movingEnable = false;
    onLoad = "[] call KPPL_fnc_dialogInit";
    onUnload = "";

    controls[] = {
        // ── Background panels ─────────────────────────────────────────────────
        "KPPL_BG_Outer",
        "KPPL_BG_Inner",
        "KPPL_BG_Frame",

        // ── Header ────────────────────────────────────────────────────────────
        "KPPL_Header",

        // ── Faction selection ─────────────────────────────────────────────────
        "KPPL_Lbl_Blufor",      "KPPL_Combo_Blufor",
        "KPPL_Lbl_Opfor",       "KPPL_Combo_Opfor",
        "KPPL_Lbl_Resistance",  "KPPL_Combo_Resistance",
        "KPPL_Lbl_Civilians",   "KPPL_Combo_Civilians",
        "KPPL_Lbl_Arsenal",     "KPPL_Combo_Arsenal",

        // ── Separator 1 ───────────────────────────────────────────────────────
        "KPPL_Separator1",

        // ── Mission parameters ────────────────────────────────────────────────
        "KPPL_Lbl_ParamsHeader",
        "KPPL_Lbl_Unitcap",     "KPPL_Combo_Unitcap",

        // ── Separator 2 ───────────────────────────────────────────────────────
        "KPPL_Separator2",

        // ── Save slot ─────────────────────────────────────────────────────────
        "KPPL_Lbl_SaveKey",
        "KPPL_Edit_SaveKey",
        "KPPL_Lbl_SaveKeyHint",

        // ── Separator 3 ───────────────────────────────────────────────────────
        "KPPL_Separator3",

        // ── Status and buttons ────────────────────────────────────────────────
        "KPPL_Lbl_Status",
        "KPPL_Btn_SaveConfig",
        "KPPL_Btn_ClearConfig",
        "KPPL_Btn_Launch",
        "KPPL_Btn_Cancel"
    };

    controlsBackground[] = {};
    objects[] = {};

    // ── Background panels ─────────────────────────────────────────────────────

    class KPPL_BG_Outer: StdBG {
        idc = 9101;
        colorBackground[] = COLOR_BROWN;
        x = (0.15 * safezoneW + safezoneX) - (2 * BORDERSIZE);
        y = (0.08 * safezoneH + safezoneY) - (2 * BORDERSIZE);
        w = (0.70 * safezoneW) + (4 * BORDERSIZE);
        h = (0.85 * safezoneH) + (4 * BORDERSIZE);
    };

    class KPPL_BG_Inner: StdBG {
        idc = 9102;
        colorBackground[] = COLOR_GREEN;
        x = (0.15 * safezoneW + safezoneX);
        y = (0.13 * safezoneH + safezoneY);
        w = (0.70 * safezoneW);
        h = (0.75 * safezoneH);
    };

    class KPPL_BG_Frame: KPPL_BG_Outer {
        idc = 9132;
        style = ST_FRAME;
        colorBackground[] = COLOR_NOALPHA;
        colorText[] = COLOR_LIGHTGRAY;
    };

    // ── Header ────────────────────────────────────────────────────────────────

    class KPPL_Header: StdHeader {
        idc = 9103;
        x = (0.15 * safezoneW + safezoneX);
        y = (0.08 * safezoneH + safezoneY);
        w = (0.70 * safezoneW);
        h = (0.05 * safezoneH);
        text = "KP LIBERATION  —  Pre-Launch Mission Configuration";
    };

    // ── Faction label/combo rows ──────────────────────────────────────────────
    // Each row: label on left (35% width), combo on right (65% width)
    // Row height: 0.055 safezoneH; first row starts at y=0.14

    class KPPL_Lbl_Blufor: StdText {
        idc = 9104;
        x = (0.16 * safezoneW + safezoneX);
        y = (0.14 * safezoneH + safezoneY);
        w = (0.22 * safezoneW);
        h = (0.025 * safezoneH);
        text = "BLUFOR Faction:";
    };

    class KPPL_Combo_Blufor: StdCombo {
        idc = 9105;
        x = (0.38 * safezoneW + safezoneX);
        y = (0.14 * safezoneH + safezoneY);
        w = (0.45 * safezoneW);
        h = (0.025 * safezoneH);
        wholeHeight = 0.35;
        sizeEx = 0.018 * safezoneH;
    };

    class KPPL_Lbl_Opfor: StdText {
        idc = 9106;
        x = (0.16 * safezoneW + safezoneX);
        y = (0.175 * safezoneH + safezoneY);
        w = (0.22 * safezoneW);
        h = (0.025 * safezoneH);
        text = "OPFOR Faction:";
    };

    class KPPL_Combo_Opfor: StdCombo {
        idc = 9107;
        x = (0.38 * safezoneW + safezoneX);
        y = (0.175 * safezoneH + safezoneY);
        w = (0.45 * safezoneW);
        h = (0.025 * safezoneH);
        wholeHeight = 0.35;
        sizeEx = 0.018 * safezoneH;
    };

    class KPPL_Lbl_Resistance: StdText {
        idc = 9108;
        x = (0.16 * safezoneW + safezoneX);
        y = (0.21 * safezoneH + safezoneY);
        w = (0.22 * safezoneW);
        h = (0.025 * safezoneH);
        text = "Resistance Faction:";
    };

    class KPPL_Combo_Resistance: StdCombo {
        idc = 9109;
        x = (0.38 * safezoneW + safezoneX);
        y = (0.21 * safezoneH + safezoneY);
        w = (0.45 * safezoneW);
        h = (0.025 * safezoneH);
        wholeHeight = 0.35;
        sizeEx = 0.018 * safezoneH;
    };

    class KPPL_Lbl_Civilians: StdText {
        idc = 9110;
        x = (0.16 * safezoneW + safezoneX);
        y = (0.245 * safezoneH + safezoneY);
        w = (0.22 * safezoneW);
        h = (0.025 * safezoneH);
        text = "Civilian Faction:";
    };

    class KPPL_Combo_Civilians: StdCombo {
        idc = 9111;
        x = (0.38 * safezoneW + safezoneX);
        y = (0.245 * safezoneH + safezoneY);
        w = (0.45 * safezoneW);
        h = (0.025 * safezoneH);
        wholeHeight = 0.35;
        sizeEx = 0.018 * safezoneH;
    };

    class KPPL_Lbl_Arsenal: StdText {
        idc = 9112;
        x = (0.16 * safezoneW + safezoneX);
        y = (0.28 * safezoneH + safezoneY);
        w = (0.22 * safezoneW);
        h = (0.025 * safezoneH);
        text = "Arsenal Preset:";
    };

    class KPPL_Combo_Arsenal: StdCombo {
        idc = 9113;
        x = (0.38 * safezoneW + safezoneX);
        y = (0.28 * safezoneH + safezoneY);
        w = (0.45 * safezoneW);
        h = (0.025 * safezoneH);
        wholeHeight = 0.35;
        sizeEx = 0.018 * safezoneH;
    };

    // ── Separator 1 ───────────────────────────────────────────────────────────

    class KPPL_Separator1: StdBG {
        idc = 9114;
        colorBackground[] = COLOR_LIGHTGRAY_ALPHA;
        x = (0.16 * safezoneW + safezoneX);
        y = (0.318 * safezoneH + safezoneY);
        w = (0.67 * safezoneW);
        h = (0.002 * safezoneH);
    };

    // ── Mission parameters section ────────────────────────────────────────────

    class KPPL_Lbl_ParamsHeader: StdHeader {
        idc = 9115;
        x = (0.16 * safezoneW + safezoneX);
        y = (0.326 * safezoneH + safezoneY);
        w = (0.67 * safezoneW);
        h = (0.03 * safezoneH);
        text = "Mission Parameters";
        colorBackground[] = COLOR_LIGHTGRAY_ALPHA;
    };

    class KPPL_Lbl_Unitcap: StdText {
        idc = 9116;
        x = (0.16 * safezoneW + safezoneX);
        y = (0.362 * safezoneH + safezoneY);
        w = (0.22 * safezoneW);
        h = (0.025 * safezoneH);
        text = "Unit Capacity:";
    };

    class KPPL_Combo_Unitcap: StdCombo {
        idc = 9117;
        x = (0.38 * safezoneW + safezoneX);
        y = (0.362 * safezoneH + safezoneY);
        w = (0.45 * safezoneW);
        h = (0.025 * safezoneH);
        wholeHeight = 0.20;
        sizeEx = 0.018 * safezoneH;
    };

    // ── Separator 2 ───────────────────────────────────────────────────────────

    class KPPL_Separator2: KPPL_Separator1 {
        idc = 9122;
        y = (0.400 * safezoneH + safezoneY);
    };

    // ── Save slot section ─────────────────────────────────────────────────────

    class KPPL_Lbl_SaveKey: StdText {
        idc = 9123;
        x = (0.16 * safezoneW + safezoneX);
        y = (0.408 * safezoneH + safezoneY);
        w = (0.22 * safezoneW);
        h = (0.025 * safezoneH);
        text = "Save Slot Name:";
    };

    class KPPL_Edit_SaveKey: StdEdit {
        idc = 9124;
        style = ST_LEFT + ST_FRAME;
        x = (0.38 * safezoneW + safezoneX);
        y = (0.408 * safezoneH + safezoneY);
        w = (0.45 * safezoneW);
        h = (0.025 * safezoneH);
        onKeyUp = "[] call KPPL_fnc_updateSaveKeyHint";
    };

    class KPPL_Lbl_SaveKeyHint: StdText {
        idc = 9125;
        style = ST_LEFT;
        colorText[] = COLOR_LIGHTGRAY_ALPHA;
        x = (0.16 * safezoneW + safezoneX);
        y = (0.436 * safezoneH + safezoneY);
        w = (0.67 * safezoneW);
        h = (0.022 * safezoneH);
        text = "Save slot: KP_LIBERATION_<MAP>_SAVEGAME  (default)";
        sizeEx = 0.016 * safezoneH;
    };

    // ── Separator 3 ───────────────────────────────────────────────────────────

    class KPPL_Separator3: KPPL_Separator1 {
        idc = 9126;
        y = (0.466 * safezoneH + safezoneY);
    };

    // ── Status line ───────────────────────────────────────────────────────────

    class KPPL_Lbl_Status: StdText {
        idc = 9127;
        style = ST_CENTER;
        x = (0.16 * safezoneW + safezoneX);
        y = (0.474 * safezoneH + safezoneY);
        w = (0.67 * safezoneW);
        h = (0.025 * safezoneH);
        text = "Loading...";
        sizeEx = 0.017 * safezoneH;
    };

    // ── Buttons ───────────────────────────────────────────────────────────────

    class KPPL_Btn_SaveConfig: StdButton {
        idc = 9128;
        x = (0.16 * safezoneW + safezoneX);
        y = (0.51 * safezoneH + safezoneY);
        w = (0.155 * safezoneW);
        h = (0.04 * safezoneH);
        text = "Save Config";
        action = "[] call KPPL_fnc_onSaveConfigClicked";
    };

    class KPPL_Btn_ClearConfig: StdButton {
        idc = 9131;
        x = (0.325 * safezoneW + safezoneX);
        y = (0.51 * safezoneH + safezoneY);
        w = (0.155 * safezoneW);
        h = (0.04 * safezoneH);
        text = "Clear Saved Config";
        action = "[] call KPPL_fnc_onClearConfigClicked";
    };

    class KPPL_Btn_Launch: StdButton {
        idc = 9129;
        x = (0.16 * safezoneW + safezoneX);
        y = (0.57 * safezoneH + safezoneY);
        w = (0.320 * safezoneW);
        h = (0.055 * safezoneH);
        text = "LAUNCH MISSION";
        colorBackground[] = {0.1, 0.5, 0.1, 0.9};
        colorBackgroundActive[] = {0.2, 0.8, 0.2, 1};
        colorText[] = COLOR_WHITE;
        action = "[] call KPPL_fnc_onLaunchClicked";
        sizeEx = 0.025 * safezoneH;
    };

    class KPPL_Btn_Cancel: StdButton {
        idc = 9130;
        x = (0.495 * safezoneW + safezoneX);
        y = (0.57 * safezoneH + safezoneY);
        w = (0.155 * safezoneW);
        h = (0.055 * safezoneH);
        text = "Cancel / End Mission";
        colorBackground[] = {0.5, 0.1, 0.1, 0.9};
        colorBackgroundActive[] = {0.8, 0.2, 0.2, 1};
        colorText[] = COLOR_WHITE;
        action = "[] call KPPL_fnc_onCancelClicked";
    };
};
