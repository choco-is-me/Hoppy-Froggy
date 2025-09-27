/// @description Update camera position
// Make sure the target exists before running the code
if (!instance_exists(target)) {
    exit;
}

// Get current camera and target positions
var _cam_x = camera_get_view_x(camera);
var _cam_y = camera_get_view_y(camera);
var _cam_w = camera_get_view_width(camera);
var _cam_h = camera_get_view_height(camera);

// Get the target's visual center, accounting for a bottom-center origin
var _target_x = target.x;
var _target_y = target.y - (target.sprite_height / 2);

// Calculate the center of the camera view
var _view_center_x = _cam_x + (_cam_w / 2);
var _view_center_y = _cam_y + (_cam_h / 2);

// Calculate the distance between the target and the view's center
var _dist_x = _target_x - _view_center_x;
var _dist_y = _target_y - _view_center_y;

// The new position the camera will move towards
var _new_cam_x = _cam_x;
var _new_cam_y = _cam_y;

// Check if the target is outside the horizontal dead zone
if (abs(_dist_x) > dead_zone_width / 2) {
    _new_cam_x += _dist_x - (sign(_dist_x) * (dead_zone_width / 2));
}

// Check if the target is outside the vertical dead zone
if (abs(_dist_y) > dead_zone_height / 2) {
    _new_cam_y += _dist_y - (sign(_dist_y) * (dead_zone_height / 2));
}

// --- ROOM BOUNDARIES ---
// Center the camera horizontally since it's wider than the room
_new_cam_x = (room_width / 2) - (_cam_w / 2);   // <-- THE FIX IS HERE!

// Prevent the camera from showing areas outside the room vertically
_new_cam_y = clamp(_new_cam_y, 0, room_height - _cam_h);

// Smoothly move the camera towards the new position using lerp
// Note: We don't need to lerp X since it's now locked.
var _lerp_y = lerp(_cam_y, _new_cam_y, smooth_speed);

// Update the camera's actual position
camera_set_view_pos(camera, _new_cam_x, _lerp_y); // <-- Use _new_cam_x directly