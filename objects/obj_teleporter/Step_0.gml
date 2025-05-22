// Step 
switch(state) {
    case "inactive":
        // Wait for activation
        if (activated) {
            state = "fading_in";
            activated = false; // Reset for potential future use
        }
        break;
        
    case "fading_in":
        // Fade screen to black
        alpha += fade_in_speed;
        if (alpha >= 1) {
            alpha = 1;
            state = "teleporting";
        }
        break;
        
    case "teleporting":
        // Perform the actual teleportation
        with (obj_frog) {
            // Save current room if teleporting to same room
            var current_room = room;
            
            // Move to target room if different
            if (room != other.target_room) {
                room_goto(other.target_room);
            }
            
            // Position player
            x = other.target_x;
            y = other.target_y;
            
            // Set facing direction
            facing = other.target_facing;
            
            // Reset movement
            vsp = 0;
            hsp = 0;
        }
        
        // Now move to the delay state
        state = "delay";
        delay_timer = delay;
        break;
        
    case "delay":
        // Wait while screen is black AFTER teleporting
        delay_timer--;
        if (delay_timer <= 0) {
            state = "fading_out";
        }
        break;
        
    case "fading_out":
        // Fade screen back in
        alpha -= fade_out_speed;
        if (alpha <= 0) {
            alpha = 0;
            state = "inactive";
            // Once we're done, we can destroy this instance if it was created temporarily
            if (target_room != room) {
                instance_destroy();
            }
        }
        break;
}

// Automatic activation on collision (if enabled)
if (automatic && state == "inactive" && place_meeting(x, y, obj_frog)) {
    activated = true;
}