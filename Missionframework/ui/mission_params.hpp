class Params {
    class KPPL_param_force_config {
        title       = "Pre-launch config screen";
        description = "Force the settings UI to open on this restart even if auto-load is enabled. Use when you need to change faction or settings without editing config files.";
        values[]    = {0, 1};
        texts[]     = {"Auto (respect saved preference)", "Force config screen this restart"};
        default     = 0;
    };
    class LoadSaveParams {
        title = $STR_PARAMS_LOADSAVEPARAMS;
        values[] = {0, 1, 2};
        texts[] = {$STR_PARAMS_LOADSAVEPARAMS_SAVE, $STR_PARAMS_LOADSAVEPARAMS_LOAD, $STR_PARAMS_LOADSAVEPARAMS_SELECTED};
        default = 1; // If you want to set mission parameters via server.cfg or this file, then set this value to 2
    };
    class WipeSave1 {
        title = $STR_WIPE_TITLE;
        values[] = {0, 1};
        texts[] =  {$STR_WIPE_NO, $STR_WIPE_YES};
        default = 0;
    };
    class WipeSave2 {
        title = $STR_WIPE_TITLE_2;
        values[] = {0, 1};
        texts[] = {$STR_WIPE_NO, $STR_WIPE_YES};
        default = 0;
    };
};
