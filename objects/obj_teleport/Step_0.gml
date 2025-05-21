// Only proceed if not already teleporting
if (!teleporting) {
    // Check if frog is standing on teleport
    var player = instance_place(x, y, obj_frog);
    if (player != noone) {
        // Start teleport sequence
        teleporting = true;
        fading_in = true;
        fading_out = false;
        player_to_teleport = player;
        
        // Reset all counters
        delay_counter = 0;
        post_teleport_counter = 0;
        
        // Lock player inputs
        global.input_locked = true;
    }
} else {
    // Teleport sequence is active
    
    // PHASE 1: Fading to black
    if (fading_in) {
        fade_alpha += fade_in_speed;
        
        // Check if fade in is complete
        if (fade_alpha >= 1) {
            fade_alpha = 1;
            fading_in = false;
            delay_counter = 0;
        }
    }
    // PHASE 2: Delay after fade in (pre-teleport delay)
    else if (delay_counter < post_fade_delay) {
        delay_counter++;
        
        // When delay is complete, perform the teleportation
        if (delay_counter >= post_fade_delay) {
            // TELEPORT THE PLAYER
            if (instance_exists(player_to_teleport)) {
                // Change room if specified
                if (room_dest != -1) {
                    // Store destination coordinates for persistent use
                    global.teleport_dest_x = target_x;
                    global.teleport_dest_y = target_y;
                    global.teleport_active = true;
                    
                    // Keep inputs locked (important to maintain between rooms)
                    global.input_lock_active = true;
                    
                    // Go to destination room
                    room_goto(room_dest);
                } else {
                    // Otherwise teleport within current room
                    player_to_teleport.x = target_x;
                    player_to_teleport.y = target_y;
                    
                    // Reset post-teleport delay counter
                    post_teleport_counter = 0;
                }
            } else {
                // Player no longer exists, reset teleport sequence
                teleporting = false;
                fade_alpha = 0;
                global.input_locked = false; // Re-enable inputs
            }
        }
    }
    // NEW PHASE: Post-teleport delay (only for same-room teleports)
    else if (room_dest == -1 && post_teleport_counter < post_teleport_delay) {
        post_teleport_counter++;
        
        // When post-teleport delay is complete, start fade out
        if (post_teleport_counter >= post_teleport_delay) {
            fading_out = true;
        }
    }
    // PHASE 3: Fading from black back to game
    else if (fading_out) {
        fade_alpha -= fade_out_speed;
        
        // Check if fade out is complete
        if (fade_alpha <= 0) {
            fade_alpha = 0;
            fading_out = false;
            teleporting = false;
            
            // Re-enable player inputs when fade out is complete
            global.input_locked = false;
            
            player_to_teleport = noone;
        }
    }
}