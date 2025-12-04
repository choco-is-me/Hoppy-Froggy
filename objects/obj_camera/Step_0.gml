/// @description Update camera & Debug

// --- 1. VIEW CONNECTION FIX (Crucial for Room Restart) ---
// If the room restarted, View 0 might have lost its reference to our camera.
// We force it to reconnect here.
if (view_get_camera(0) != camera) {
    show_debug_message("CAMERA DEBUG: Reconnecting camera to View 0...");
    view_enabled = true;
    view_visible[0] = true;
    view_set_camera(0, camera);
}

// --- 2. TARGET SEARCH (Fix for missing player) ---
// If we lost the player, try to find them again immediately
if (!instance_exists(target)) {
    if (instance_exists(obj_frog)) {
        show_debug_message("CAMERA DEBUG: Lost target, but found obj_frog. Re-acquiring...");
        target = obj_frog;
    } else {
        // Debug logging to see why we are stuck
        show_debug_message("CAMERA DEBUG: No target and no obj_frog found! Exiting.");
        exit;
    }
}

// --- 3. STANDARD CAMERA LOGIC ---

// Get current camera properties
var _cam_x = camera_get_view_x(camera);
var _cam_y = camera_get_view_y(camera);
var _cam_w = camera_get_view_width(camera);
var _cam_h = camera_get_view_height(camera);

// Get target position
var _target_x = target.x;
var _target_y = target.y - (target.sprite_height / 2);

// Calculate centers
var _view_center_x = _cam_x + (_cam_w / 2);
var _view_center_y = _cam_y + (_cam_h / 2);

// Calculate distance
var _dist_x = _target_x - _view_center_x;
var _dist_y = _target_y - _view_center_y;

// Prepare new coordinates
var _new_cam_x = _cam_x;
var _new_cam_y = _cam_y;

// Dead Zone Logic
if (abs(_dist_x) > dead_zone_width / 2) {
    _new_cam_x += _dist_x - (sign(_dist_x) * (dead_zone_width / 2));
}
if (abs(_dist_y) > dead_zone_height / 2) {
    _new_cam_y += _dist_y - (sign(_dist_y) * (dead_zone_height / 2));
}

// --- 4. ROOM BOUNDARIES ---

// Horizontal: Logic for your specific room setup
if (room_width < _cam_w) {
    // Center if room is small
    _new_cam_x = (room_width / 2) - (_cam_w / 2);
} else {
    // Clamp if room is wide
    _new_cam_x = clamp(_new_cam_x, 0, room_width - _cam_w);
}

// Vertical: Clamp or Center
if (room_height > _cam_h) {
    _new_cam_y = clamp(_new_cam_y, 0, room_height - _cam_h);
} else {
    _new_cam_y = (room_height - _cam_h) / 2;
}

// --- 5. APPLY MOVEMENT ---
// Apply lerp for smooth y movement (X is snapped or locked in small rooms)
var _final_cam_x = _new_cam_x; // Usually we want instant X if locked, or smooth if scrolling
if (room_width > _cam_w) _final_cam_x = lerp(_cam_x, _new_cam_x, smooth_speed);

var _final_cam_y = lerp(_cam_y, _new_cam_y, smooth_speed);

camera_set_view_pos(camera, _final_cam_x, _final_cam_y);

// --- DEBUG OUTPUT (Optional: Disable this later) ---
 show_debug_message("CamPos: " + string(_final_cam_x) + "," + string(_final_cam_y) + " | Target: " + string(_target_x) + "," + string(_target_y));