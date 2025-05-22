// Step
get_controls();
//show_debug_message("State: " + state + ", HSP: " + string(hsp) + ", VSP: " + string(vsp) + ", Facing: " + string(facing) + ", HP: " + string(hp));

// Check if player is on ground (used for multiple state checks)
var on_ground = place_meeting(x, y + 1, obj_platform);

// Debug damage timer for testing
if (state != "Damaged" && state != "Dead") {
    debug_damage_timer++;
    if (debug_damage_timer >= debug_damage_interval) {
        debug_damage_timer = 0;
        // Take damage for testing
        take_damage(1);
    }
}

// Health bar transition animation handling
if (health_transition_active) {
    health_transition_progress += health_transition_speed;
    
    if (health_transition_progress >= 1) {
        // Transition completed
        health_transition_active = false;
        health_bar_frame = health_transition_target_frame;
    } else {
        // During transition, lerp between frames
        var intermediate_frame = lerp(health_transition_start_frame, health_transition_target_frame, health_transition_progress);
        health_bar_frame = floor(intermediate_frame);
    }
}

// Update arrow oscillation (will be active in most non-damaged states)
if (state != "Attack" && state != "Damaged" && state != "Dead") {
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

        if (key_space_pressed && on_ground) { // Only start charging if on ground
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
            // If arrow_angle > 90 (left half of semicircle), face left
            // If arrow_angle <= 90 (right half of semicircle), face right
            facing = (arrow_angle > 90) ? -1 : 1;
            
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

        // Check if player has fallen off platform while charging
        if (!on_ground) {
            state = "Jumping"; // Change to jumping state if no longer on ground
            image_index = 0;
            jump_charge = 0;   // Reset jump charge
            // Don't apply any jump velocity since they're already falling
        }
        else if (key_space_held) {
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
            if (on_ground) { // Only jump if still on ground when releasing
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
            } else {
                // If not on ground when releasing, just go to jumping state without adding velocity
                state = "Jumping";
                image_index = 0;
                // Keep current vsp and hsp (falling)
            }
        }
        break;

    case "Jumping":
        current_body_sprite = spr_frog_hop_body;
        current_head_sprite = spr_frog_hop_head;
        image_speed = 0; // Use a single frame for hop animation
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
                    if (on_ground) { // Use our on_ground variable here too
                        state = "Idle";
                    } else {
                        state = "Jumping";
                    }
                }
            }
        }
        break;
        
    case "Damaged":
        // Use damaged sprites
        current_body_sprite = spr_frog_damaged_body;
        current_head_sprite = spr_frog_damaged_head;
        
        // Control animation frame manually
        damaged_timer++;
        if (damaged_timer % damaged_frame_speed == 0) {
            damaged_frame = !damaged_frame; // Toggle between 0 and 1
        }
        
        image_index = damaged_frame;
        
        // Exit damaged state after animation completes
        if (damaged_timer >= damaged_duration) {
            damaged_timer = 0;
            
            // Explicitly reset any possible momentum before changing states
            hsp = 0;
            vsp = 0;
            
            // Return to appropriate state based on grounding
            if (hp <= 0) {
                state = "Dead"; // If no health left, transition to dead state
            } else if (on_ground) {
                state = "Idle";
            } else {
                state = "Jumping";
            }
        }
        
        // No player control during damaged state
        break;
        
    case "Dead":
        // Use dead sprites
        current_body_sprite = spr_frog_dead_body;
        current_head_sprite = spr_frog_dead_head;
        image_index = 0; // Single frame for dead sprites
        
        // Fade out effect
        death_alpha -= death_fade_speed;
        if (death_alpha <= 0) death_alpha = 0;
        
        // Create death particle at the center point between head and body
        if (!death_particle_created) {
            death_particle_created = true;
            // Create death particle effect at center of frog
            instance_create_layer(x, y - 9, "Instances", obj_death_particle);
        }
        
        // When fully faded, trigger game restart
        if (death_alpha <= 0) {
            // Create transition with restart_room action (will use death_delay)
            var trans = instance_create_layer(0, 0, "Instances", obj_transition);
            trans.target_action = "restart_room";
            // Don't destroy the instance here, let the transition handle it
        }
        break;
}

// --- Physics and Movement (applied after state logic) ---

// Only apply gravity and movement physics when not attacking, damaged, or dead
if (state != "Attack" && state != "Damaged" && state != "Dead") {
    // Apply Gravity
    if (!on_ground || vsp < 0 || state == "Jumping") {
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