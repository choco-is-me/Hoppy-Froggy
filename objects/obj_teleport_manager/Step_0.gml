// Check if we're coming from a teleport to another room
if (global.teleport_active) {
    // Find the player and position them at the destination
    var player = instance_find(obj_frog, 0);
    if (player != noone) {
        player.x = global.teleport_dest_x;
        player.y = global.teleport_dest_y;
        
        // Create a teleport object to handle the fade-out transition
        var fade_out_teleport = instance_create_layer(0, 0, "Instances", obj_teleport);
        with (fade_out_teleport) {
            teleporting = true;
            fading_in = false;
            fading_out = false; // Start with delay, not fade-out
            fade_alpha = 1;
            player_to_teleport = player;
            fade_out_speed = 0.05;
            
            // Start the post-teleport delay
            post_teleport_counter = 0;
            post_teleport_delay = 20;
        }
        
        // Ensure inputs remain locked during room transition
        if (global.input_lock_active) {
            global.input_locked = true;
            global.input_lock_active = false; // Reset the flag
        }
        
        // Reset the teleport flag
        global.teleport_active = false;
    }
}