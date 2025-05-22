if !instance_exists(obj_frog) exit;
    
var cam_width = camera_get_view_width(view_camera[0]);
var cam_height = camera_get_view_height(view_camera[0]);

var cam_x = obj_frog.x - cam_width / 2;
var cam_y = obj_frog.y - cam_height / 2;

cam_x = clamp(cam_x, 0, room_width - cam_width);
cam_y = clamp(cam_y, 0, room_height - cam_height);

final_cam_x += (cam_x - final_cam_x) * cam_trail_speed;
final_cam_y += (cam_y - final_cam_y) * cam_trail_speed;

camera_set_view_pos(view_camera[0], final_cam_x, final_cam_y);