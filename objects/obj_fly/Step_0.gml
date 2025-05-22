/// Step
// Update animation based on state
switch (state) {
    case "Idle":
        sprite_index = spr_fly_flying;
        image_speed = 1;  // Loop the flying animation
        break;
        
    case "Attack":
        sprite_index = spr_fly_attack;
        // Animation handled explicitly in the attack state code
        break;
        
    case "Damaged":
        sprite_index = spr_fly_damaged;
        // Animation handled explicitly in the damaged state code
        break;
        
    case "Dead":
        sprite_index = spr_fly_dead;
        image_speed = 0;  // Single frame for dead
        break;
}

// Check for player in range (for attack state transition)
var player = instance_nearest(x, y, obj_frog);
var distance_to_player = 999999; // Large default value

if (player != noone) {
    distance_to_player = point_distance(x, y, player.x, player.y);
    
    // Face towards player
    if (player.x < x) {
        facing = -1;
    } else {
        facing = 1;
    }
}

// State machine
switch (state) {
    case "Idle":
        // Random movement
        move_timer++;
        if (move_timer >= move_interval) {
            move_timer = 0;
            move_direction = irandom(359); // Choose a new random direction
            
            // Adjust movement if too far from origin
            var dist_from_origin = point_distance(x, y, origin_x, origin_y);
            if (dist_from_origin > fly_range * 0.7) { // At 70% of range, start moving back
                // Calculate angle towards origin
                var angle_to_origin = point_direction(x, y, origin_x, origin_y);
                // Move towards origin
                move_direction = angle_to_origin;
            }
        }
        
        // Calculate movement based on direction
        hsp = lengthdir_x(fly_speed, move_direction);
        vsp = lengthdir_y(fly_speed, move_direction);
        
        // Move fly
        x += hsp;
        y += vsp;
        
        // Hard boundary check to prevent going too far
        var dist_from_origin = point_distance(x, y, origin_x, origin_y);
        if (dist_from_origin > fly_range) {
            // Force move back towards origin
            var angle_to_origin = point_direction(x, y, origin_x, origin_y);
            x = origin_x + lengthdir_x(fly_range, angle_to_origin);
            y = origin_y + lengthdir_y(fly_range, angle_to_origin);
        }
        
        // Detect player and switch to attack state
        if (player != noone && distance_to_player < attack_range && hp > 0) {
            state = "Attack";
            attack_cooldown = 0;
            image_index = 0; // Start with waiting frame
        }
        break;
        
    case "Attack":
        // Slow movement toward player (half speed)
        if (player != noone) {
            var angle_to_player = point_direction(x, y, player.x, player.y);
            
            // Move slowly toward player but keep distance
            var target_distance = attack_range * 0.7; // Target 70% of attack range
            if (distance_to_player > target_distance) {
                // Move closer if too far
                hsp = lengthdir_x(fly_speed * 0.5, angle_to_player);
                vsp = lengthdir_y(fly_speed * 0.5, angle_to_player);
            } else if (distance_to_player < target_distance * 0.8) {
                // Back away if too close
                hsp = lengthdir_x(-fly_speed * 0.5, angle_to_player);
                vsp = lengthdir_y(-fly_speed * 0.5, angle_to_player);
            } else {
                // Stay in place with minor movement
                hsp = lengthdir_x(fly_speed * 0.2, move_direction);
                vsp = lengthdir_y(fly_speed * 0.2, move_direction);
            }
            
            // Move fly
            x += hsp;
            y += vsp;
            
            // Hard boundary check
            var dist_from_origin = point_distance(x, y, origin_x, origin_y);
            if (dist_from_origin > fly_range * 1.2) { // Allow slightly larger range during attack
                var angle_to_origin = point_direction(x, y, origin_x, origin_y);
                x = origin_x + lengthdir_x(fly_range * 1.2, angle_to_origin);
                y = origin_y + lengthdir_y(fly_range * 1.2, angle_to_origin);
            }
            
            // Attack logic - shoot at player
            attack_cooldown++;
            
            // Set frame based on attack cooldown
            if (attack_cooldown > attack_cooldown_max - 10 && attack_cooldown <= attack_cooldown_max) {
                // Use shooting frame just before firing
                image_index = 1; // Shooting frame
            } else {
                image_index = 0; // Waiting frame
            }
            
            if (attack_cooldown >= attack_cooldown_max) {
                attack_cooldown = 0;
                
                // Create bullet
                var bullet = instance_create_layer(x, y, "Instances", obj_fly_bullet);
                bullet.speed = bullet_speed;
                bullet.direction = angle_to_player;
                bullet.image_angle = angle_to_player;
            }
            
            // Return to idle if player is out of range
            if (distance_to_player > attack_range * 1.2) { // Give some extra range before leaving attack mode
                state = "Idle";
            }
        } else {
            // No player found, go back to idle
            state = "Idle";
        }
        break;
        
    case "Damaged":
        // Reset movement
        hsp = 0;
        vsp = 0;
        
        // Handle damaged animation
        damaged_timer++;
        if (damaged_timer % damaged_frame_speed == 0) {
            damaged_frame = !damaged_frame; // Toggle between 0 and 1
        }
        
        image_index = damaged_frame;
        
        // Exit damaged state after animation completes
        if (damaged_timer >= damaged_duration) {
            damaged_timer = 0;
            
            // Return to appropriate state
            if (hp <= 0) {
                state = "Dead";
            } else if (player != noone && distance_to_player < attack_range) {
                state = "Attack";
            } else {
                state = "Idle";
            }
        }
        break;
        
    case "Dead":
        // Float upward and fade out
        y += death_y_speed; // Move upward
        death_alpha -= death_fade_speed;
        
        if (death_alpha <= 0) {
            // Destroy instance when fully transparent
            instance_destroy();
        }
        break;
}