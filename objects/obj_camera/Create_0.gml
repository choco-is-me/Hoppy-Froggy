/// @description Initialize Camera & Window

// Enable views in the room
view_enabled = true;
view_visible[0] = true;

// --- CAMERA PROPERTIES ---
// The size of the "camera lens" (what the game sees)
var _cam_width = 352;
var _cam_height = 198;

// Set the camera for view 0
camera = camera_create_view(0, 0, _cam_width, _cam_height);
view_set_camera(0, camera);

// --- VIEWPORT PROPERTIES ---
// The size of the "window" on your monitor
var _scale = 2;
var _port_width = _cam_width * _scale;   // 704
var _port_height = _cam_height * _scale; // 396

// Set the viewport size in the game settings
view_set_wport(0, _port_width);
view_set_hport(0, _port_height);

// --- WINDOW & SURFACE SETUP ---
// 1. Physically resize the game window
window_set_size(_port_width, _port_height);

// 2. Resize the drawing canvas to prevent pixel distortion
surface_resize(application_surface, _port_width, _port_height);

// 3. Center the window on the user's monitor
var _display_width = display_get_width();
var _display_height = display_get_height();
var _win_x = (_display_width - _port_width) / 2;
var _win_y = (_display_height - _port_height) / 2;

// Apply the position immediately
window_set_position(_win_x, _win_y);
display_set_gui_size(_port_width, _port_height);

// --- GAME LOGIC SETUP ---
// The object the camera will follow
target = obj_frog;

// --- DEAD ZONE ---
// The area in the center where the player can move without the camera following
dead_zone_width = 176;
dead_zone_height = 66;

// How fast the camera catches up (0 = never, 1 = instant)
smooth_speed = 0.1;

// Toggle this to false to hide the green box
draw_debug_box = true;