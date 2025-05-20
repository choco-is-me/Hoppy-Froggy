show_debug_message("State: " + state + ", HSP: " + string(hsp) + ", VSP: " + string(vsp) + ", Facing: " + string(facing));

// Input
var key_left = keyboard_check(ord("A"));
var key_right = keyboard_check(ord("D"));
var key_space_pressed = keyboard_check_pressed(vk_space);
var key_space_held = keyboard_check(vk_space);
var key_space_released = keyboard_check_released(vk_space);

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
                    // Since your animation has 2 frames (0 and 1), the last frame index is 1
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
            
            // Optional: Scale horizontal speed with charge as well
            // hsp = jump_h_direction * (jump_charge / jump_charge_max) * base_jump_power_horizontal;

            // Ensure facing is updated if jump direction was based on keys
            if (jump_h_direction != 0) {
                facing = jump_h_direction;
            }
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
        break;
}

// --- Physics and Movement (applied after state logic) ---

// Apply Gravity
// Only apply gravity if not on the ground OR if moving upwards (already in air)
// Or if in a state that should be affected by gravity (e.g. Jumping)
if (!place_meeting(x, y + 1, obj_platform) || vsp < 0 || state == "Jumping") {
    vsp += gravity_val;
}


// Vertical Collision and Movement
if (place_meeting(x, y + vsp, obj_platform)) { // Check collision at target position
    // Move pixel by pixel until just before collision
    while (!place_meeting(x, y + sign(vsp), obj_platform)) {
        y += sign(vsp);
    }
    // If landing from a jump
    if (vsp > 0 && state == "Jumping") {
        state = "Idle";
        image_index = 0;
        hsp = 0; // Stop horizontal movement on landing
    }
    vsp = 0; // Stop vertical movement
}
y += vsp; // Apply final vertical movement

// Horizontal Collision and Movement
if (hsp != 0) { // Only process if there's horizontal speed
    if (place_meeting(x + hsp, y, obj_platform)) {
        // Move pixel by pixel until just before collision
        while (!place_meeting(x + sign(hsp), y, obj_platform)) {
            x += sign(hsp);
        }
        hsp = -hsp * 0.5; // Reverse horizontal speed at 50% on collision (bounce-back)
    }
}
x += hsp; // Apply final horizontal movement
