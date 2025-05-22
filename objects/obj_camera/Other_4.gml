// Room Start
if !instance_exists(obj_frog) exit;
    
var cam_width = camera_get_view_width(view_camera[0]);
var cam_height = camera_get_view_height(view_camera[0]);

final_cam_x = obj_frog.x - cam_width / 2;
final_cam_y = obj_frog.y - cam_height / 2;