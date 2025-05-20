inactive_timer += 1;

// Calculate alpha based on respawn progress
if (inactive_timer > reactivate_time * 0.67) {
    // Start fading in during the last third of the timer
    alpha = 0.2 + ((inactive_timer - (reactivate_time * 0.67)) / (reactivate_time * 0.33)) * 0.8;
}

if (inactive_timer >= reactivate_time) {
    // Create the solid version at the same position
    var new_platform = instance_create_layer(x, y, layer, obj_decaying_platform);
    // Transfer the sprite and other properties if needed
    new_platform.sprite_index = sprite_index;
    new_platform.image_index = image_index;
    new_platform.image_xscale = image_xscale;
    new_platform.image_yscale = image_yscale;
    new_platform.image_angle = image_angle;
    
    // Destroy this instance
    instance_destroy();
}