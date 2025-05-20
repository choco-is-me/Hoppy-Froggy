show_debug_message("State: " + state + ", HSP: " + string(hsp) + ", VSP: " + string(vsp) + ", Facing: " + string(facing));

// Input
var key_left = keyboard_check(ord("A"));
var key_right = keyboard_check(ord("D"));
var key_space_pressed = keyboard_check_pressed(vk_space);
var key_space_held = keyboard_check(vk_space);
var key_space_released = keyboard_check_released(vk_space);
var mouse_left_pressed = mouse_check_button_pressed(mb_left);

// Update arrow oscillation (will be active in most states)
if (state != "Attack") {
    arrow_angle += arrow_speed * arrow_direction;
    
    // Switch direction at boundaries
    if (arrow_angle >= arrow_max_angle) {
        arrow_angle = arrow_max_angle;
        arrow_direction = -1;
    } else if (arrow_angle <= arrow_min_angle) {
        arrow_angle = arrow_min_angle;
        arrow_direction = 1;
    }
}

// State Machine
switch (state) {
    case "Idle":
        current_body_sprite = spr_frog_idle_body;
        current_head_sprite = spr_frog_idle_head;
        image_speed = 1;

        // Determine facing direction
        if (key_left) {
            facing = -1;
        } else if (key_right) {
            facing = 1;
        }

        if (key_space_pressed) {
            state = "Charging";
            image_index = 0; // Start pre-hop animation
            jump_charge = 0;
        }
        
        // Check for attack
        if (mouse_left_pressed && can_attack) {
            state = "Attack";
            tongue_active = true;
            tongue_angle = arrow_angle;
            tongue_length = 0;
            tongue_retracting = false;
            // Calculate a normalized direction vector for the tongue
            var tongue_dir_x = lengthdir_x(1, tongue_angle);
            var tongue_dir_y = lengthdir_y(1, tongue_angle);
        }
        break;

    case "Charging":
        current_body_sprite = spr_frog_prehop_body;
        current_head_sprite = spr_frog_prehop_head;

        // Determine facing direction
        if (key_left) {
            facing = -1;
        } else if (key_right) {
            facing = 1;
        }

        if (key_space_held) {
            jump_charge += charge_rate;
            if (jump_charge >= jump_charge_max) {
                jump_charge = jump_charge_max;
                image_speed = 0; // Freeze animation on last frame
                if (sprite_exists(current_body_sprite)) {
                    image_index = 1; // Explicitly set to the last frame (frame 1)
                }
            } else {
                // For better control of the animation during charging:
                if (jump_charge < jump_charge_max * 0.5) {
                    image_index = 0; // Use first frame for first half of charging
                } else {
                    image_index = 1; // Use second frame for second half of charging
                }
                image_speed = 0; // Manually control animation instead of letting it play
            }
        }

        if (key_space_released) {
            state = "Jumping";
            image_index = 0; // Reset for jump sprite

            // Calculate vertical jump power
            vsp = -(jump_charge / jump_charge_max) * base_jump_power_vertical;

            // Determine horizontal jump direction and speed
            var jump_h_direction = 0;
            if (key_left) { // Prioritize currently held keys for jump direction
                jump_h_direction = -1;
            } else if (key_right) {
                jump_h_direction = 1;
            } else { // If no key held on release, use current facing direction
                jump_h_direction = facing;
            }
            hsp = jump_h_direction * base_jump_power_horizontal;
            
            // Ensure facing is updated if jump direction was based on keys
            if (jump_h_direction != 0) {
                facing = jump_h_direction;
            }
        }
        
        // Check for attack
        if (mouse_left_pressed && can_attack) {
            state = "Attack";
            tongue_active = true;
            tongue_angle = arrow_angle;
            tongue_length = 0;
            tongue_retracting = false;
        }
        break;

    case "Jumping":
        current_body_sprite = spr_frog_hop_body;
        current_head_sprite = spr_frog_hop_head;
        image_speed = 0; // Use a single frame for hop animation, or set to 1 if it's an animation
    
        // Air control
        var air_control_input = key_right - key_left; // -1 for left, 1 for right, 0 for none
        if (air_control_input != 0) {
            hsp += air_control_input * air_control_force;
            hsp = clamp(hsp, -max_hsp_air, max_hsp_air); // Clamp air-controlled speed
            facing = sign(hsp); // Update facing based on movement direction if hsp is not 0
        }
        
        // We've removed the attack check - can't attack while jumping anymore
        // The arrow will still oscillate, but clicking won't trigger an attack
        break;
        
    case "Attack":
        current_body_sprite = spr_frog_attack_body;
        current_head_sprite = spr_frog_attack_head;
        image_speed = 0; // We use a single frame for attack animation
        
        // Handle tongue extension and retraction
        if (tongue_active) {
            if (!tongue_retracting) {
                // Extending the tongue
                tongue_length += tongue_speed;
                
                // Check if tongue has reached maximum length
                if (tongue_length >= tongue_max_length) {
                    tongue_retracting = true;
                }
                
                // Here's where you'd check for enemy collision with tongue head
                // Will be implemented later when enemies are added
                /*
                var tongue_head_x = x + lengthdir_x(tongue_length, tongue_angle);
                var tongue_head_y = y + lengthdir_y(tongue_length, tongue_angle);
                var enemy = collision_point(tongue_head_x, tongue_head_y, obj_enemy, false, true);
                if (enemy != noone) {
                    // Deal damage to enemy
                    with (enemy) {
                        hp -= other.tongue_damage;
                    }
                    tongue_retracting = true; // Start retracting after hitting enemy
                }
                */
            } else {
                // Retracting the tongue
                tongue_length -= tongue_speed;
                
                // Check if tongue has fully retracted
                if (tongue_length <= 0) {
                    tongue_active = false;
                    // Return to previous state based on conditions
                    if (place_meeting(x, y + 1, obj_platform)) {
                        state = "Idle";
                    } else {
                        state = "Jumping";
                    }
                }
            }
        }
        break;
}

// --- Physics and Movement (applied after state logic) ---

// Only apply gravity and movement physics when not attacking
if (state != "Attack") {
    // Apply Gravity
    if (!place_meeting(x, y + 1, obj_platform) || vsp < 0 || state == "Jumping") {
        vsp += gravity_val;
    }

    // Vertical Collision and Movement
    if (place_meeting(x, y + vsp, obj_platform)) {
        while (!place_meeting(x, y + sign(vsp), obj_platform)) {
            y += sign(vsp);
        }
        if (vsp > 0 && state == "Jumping") {
            state = "Idle";
            image_index = 0;
            hsp = 0; // Stop horizontal movement on landing
        }
        vsp = 0; // Stop vertical movement
    }
    y += vsp; // Apply final vertical movement

    // Horizontal Collision and Movement
    if (hsp != 0) {
        if (place_meeting(x + hsp, y, obj_platform)) {
            while (!place_meeting(x + sign(hsp), y, obj_platform)) {
                x += sign(hsp);
            }
            hsp = -hsp * 0.5; // Reverse horizontal speed at 50% on collision (bounce-back)
        }
        x += hsp; // Apply final horizontal movement
    }
}