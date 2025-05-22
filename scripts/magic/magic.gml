// Function to handle taking damage
function take_damage(damage_amount) {
    if (state != "Damaged" && state != "Dead") { // Prevent taking damage during damage animation or when dead
        hp -= damage_amount;
        hp = max(0, hp); // Clamp HP to minimum 0
        
        // Start health transition animation
        health_transition_active = true;
        health_transition_progress = 0;
        
        // Set proper transition frames based on current health
        if (hp == 2) {
            health_transition_start_frame = 0;  // image_index 0 (3 hearts)
            health_transition_target_frame = 2;  // image_index 2 (2 hearts)
        } 
        else if (hp == 1) {
            health_transition_start_frame = 2;  // image_index 2 (2 hearts)
            health_transition_target_frame = 4;  // image_index 4 (1 heart)
        }
        else if (hp == 0) {
            health_transition_start_frame = 4;  // image_index 4 (1 heart)
            health_transition_target_frame = 6;  // image_index 6 (0 hearts)
        }
        
        // Enter damaged state
        state = "Damaged";
        damaged_timer = 0;
        damaged_frame = 0;
        
        // Remove knockback effect - just stop movement instead
        vsp = 0;
        hsp = 0;
    }
}

function music_and_sound_loaded() {
    return audio_group_is_loaded(UI);
}