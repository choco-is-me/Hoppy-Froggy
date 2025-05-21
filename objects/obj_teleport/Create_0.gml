// Default teleport settings (will be overwritten by creation code)
room_dest = -1;        // Default: no room change (-1 means stay in current room)
target_x = x;          // Default target is the object's own position
target_y = y;
fade_in_speed = 0.05;  // Default fade speeds
fade_out_speed = 0.05;

// Teleport state variables
teleporting = false;   // Whether teleport sequence is active
fading_in = false;     // Fading to black
fading_out = false;    // Fading from black
fade_alpha = 0;        // Current fade transparency (0 = transparent, 1 = black)

// Delay between fade in completion and teleportation (pre-teleport delay)
post_fade_delay = 15;  // Wait 15 frames when fully black before teleporting
delay_counter = 0;     // Counter for the delay

// NEW: Delay between teleportation and fade-out start (post-teleport delay)
post_teleport_delay = 20;  // Wait 20 frames with black screen after teleporting
post_teleport_counter = 0;  // Counter for post-teleport delay

// Store the player's object reference
player_to_teleport = noone;