/// @description Initialize Camera

// Enable views in the room
view_enabled = true;
view_visible[0] = true;

// --- CAMERA PROPERTIES ---
var _cam_width = 352; // <-- CHANGED from 176
var _cam_height = 198;  // <-- CHANGED from 99

// Set the camera for view 0
camera = camera_create_view(0, 0, _cam_width, _cam_height);
view_set_camera(0, camera);

// --- VIEWPORT PROPERTIES ---
var _scale = 2; // <-- CHANGED from 4
var _port_width = _cam_width * _scale;   // 704
var _port_height = _cam_height * _scale;  // 396

// Set the viewport size in the window
view_set_wport(0, _port_width);
view_set_hport(0, _port_height);
// (The rest of the window setup code is the same)


// The object the camera will follow (your frog player)
target = obj_frog; 

// --- DEAD ZONE ---
// We can make the dead zone a bit bigger now since the view is larger
dead_zone_width = 176; // This can stay the same
dead_zone_height = 66;  // <-- CHANGED (optional, but gives more room before scroll)

// (The rest of the code is the same)
smooth_speed = 0.1;
draw_debug_box = true; 