// Create
// Control Setup
window_set_cursor(cr_none);

// Audio Setup
audio_sound_set_track_position(snd_hover, 0);

// Cursor variables
hovering = false;
cursor_scale_x = 2;
cursor_scale_y = 2;

// Menu dimensions
width = 640;
height = 480;
op_border = 100;
op_space = 20;

// Menu state
pos = 0;
menu_locked = false;
menu_level = 0; // Keep only one menu level since settings is removed
op_length = 0;  // Will be set in Step Event

// Menu options setup - only main menu now
option[0, 0] = "New Game";
option[0, 1] = "Touch Some Grass"; // Now this is option 1 instead of 2