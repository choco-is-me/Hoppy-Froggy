/// @description Initialize Camera
// Enable views in the room
view_enabled = true;
view_visible[0] = true;

// Set the camera for view 0
camera = camera_create_view(0, 0, 640, 480); // Adjust 640x480 to your desired camera size
view_set_camera(0, camera);

// The object the camera will follow (your frog player)
// Make sure you have an instance of obj_frog in the room!
target = obj_frog; 

// Dead zone box dimensions (the "imagination box")
dead_zone_width = 176;
dead_zone_height = 99;

// Smoothness of the camera movement (a value between 0 and 1)
// A smaller value means smoother/slower movement.
smooth_speed = 0.1;
draw_debug_box = true; 