function __InputConfigVerbs()
{
    enum INPUT_VERB
    {
        // Need to keep UP and DOWN for cluster definition
        UP,
        DOWN,
        LEFT,
        RIGHT,
        JUMP_PRESSED,
        JUMP_HELD,
        JUMP_RELEASED,
        MOUSE_LEFT,
        PAUSE
    }
    
    enum INPUT_CLUSTER
    {
        // Keep the original NAVIGATION name as it's referenced internally
        NAVIGATION,
    }
    
    // Define UP and DOWN with undefined inputs since we don't need them
    InputDefineVerb(INPUT_VERB.UP,           "up",           undefined,          undefined);
    InputDefineVerb(INPUT_VERB.DOWN,         "down",         undefined,          undefined);
    
    // Define the inputs you actually use
    InputDefineVerb(INPUT_VERB.LEFT,         "left",         ["A", vk_left],     [-gp_axislh, gp_padl]);
    InputDefineVerb(INPUT_VERB.RIGHT,        "right",        ["D", vk_right],    [gp_axislh, gp_padr]);
    
    // Jump actions with different states
    InputDefineVerb(INPUT_VERB.JUMP_PRESSED, "jump_pressed", vk_space,           gp_face1);  // X on DualSense
    InputDefineVerb(INPUT_VERB.JUMP_HELD,    "jump_held",    vk_space,           gp_face1);  // X on DualSense
    InputDefineVerb(INPUT_VERB.JUMP_RELEASED,"jump_released",vk_space,           gp_face1);  // X on DualSense
    
    // Mouse left click mapped to Square on DualSense (gp_face4)
    InputDefineVerb(INPUT_VERB.MOUSE_LEFT,   "mouse_left",   mb_left,            gp_face4);  // Square on DualSense
    
    // Pause functionality
    InputDefineVerb(INPUT_VERB.PAUSE,        "pause",        vk_escape,          gp_start);
    
    // Define the NAVIGATION cluster that's referenced internally
    InputDefineCluster(INPUT_CLUSTER.NAVIGATION, INPUT_VERB.UP, INPUT_VERB.RIGHT, INPUT_VERB.DOWN, INPUT_VERB.LEFT);
}