/// @description Draw debug bounding box in the room
if (!draw_debug_box || !instance_exists(target)) {
    exit;
}
var _cam_x = camera_get_view_x(camera);
var _cam_y = camera_get_view_y(camera);
var _cam_w = camera_get_view_width(camera);
var _cam_h = camera_get_view_height(camera);
var _view_center_x = _cam_x + (_cam_w / 2);
var _view_center_y = _cam_y + (_cam_h / 2);
var _box_left = _view_center_x - (dead_zone_width / 2);
var _box_top = _view_center_y - (dead_zone_height / 2);
var _box_right = _view_center_x + (dead_zone_width / 2);
var _box_bottom = _view_center_y + (dead_zone_height / 2);
draw_set_color(c_lime);
draw_set_alpha(0.5);
draw_rectangle(_box_left, _box_top, _box_right, _box_bottom, true);
draw_set_alpha(1.0);
draw_set_color(c_white);
