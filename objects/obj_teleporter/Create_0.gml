// Create
// Teleport target variables
target_x = 0;          // X position to teleport to
target_y = 0;          // Y position to teleport to
target_room = room;    // Room to teleport to (default: current room)
target_facing = 1;     // Direction player will face after teleport (1=right, -1=left)

// Transition variables
fade_in_speed = 0.05;  // How fast screen fades to black (default)
fade_out_speed = 0.05; // How fast screen fades from black (default)
delay = 30;            // Frames to wait after fade completes before teleporting

// Fade state management
alpha = 0;             // Current fade alpha (0 = clear, 1 = black)
state = "inactive";    // Teleporter states: inactive, fading_in, delay, teleporting, fading_out
delay_timer = 0;       // Timer for delay state

// Trigger settings
activated = false;     // Whether teleporter has been triggered
automatic = false;     // Whether it activates automatically on collision