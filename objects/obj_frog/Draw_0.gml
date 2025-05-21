// Draw
// Calculate head offset based on state and current body sprite
var head_offset = -6; // Default for 7px height sprites (idle, hop)
if (state == "Charging" && current_body_sprite == spr_frog_prehop_body) {
    head_offset = -4; // For prehop with shorter sprite
} else if (current_body_sprite == spr_frog_idle_body || current_body_sprite == spr_frog_hop_body) {
    head_offset = -6; // For 7px height sprites
} else if (state == "Attack") {
    head_offset = -6; // For attack sprites - adjust as needed based on your sprites
}

// Draw frog body and head, flipping based on 'facing'
if (sprite_exists(current_body_sprite)) {
    draw_sprite_ext(current_body_sprite, image_index, x, y, facing, 1, 0, c_white, 1);
}
if (sprite_exists(current_head_sprite)) {
    draw_sprite_ext(current_head_sprite, image_index, x, y + head_offset, facing, 1, 0, c_white, 1);
}

// Draw oscillating arrow
if (state != "Attack") {
    var arrow_x = x + lengthdir_x(arrow_distance, arrow_angle);
    var arrow_y = y + lengthdir_y(arrow_distance, arrow_angle);
    
    // Arrow sprite points bottom-right by default (315° in GameMaker's angle system)
    // To make it point in the direction of arrow_angle, add 315°
    draw_sprite_ext(spr_arrow, 0, arrow_x, arrow_y, 1, 1, arrow_angle + 55, c_white, 1);
}

// Draw tongue if active
if (tongue_active && state == "Attack") {
    // Calculate tongue origin position at the frog's mouth
    // Adjusting both for the head's position and horizontal offset for the mouth
    var tongue_origin_x = x + facing + 0.5; // Move origin horizontally based on facing direction (adjust value as needed)
    var tongue_origin_y = y + head_offset - 3.5; // Vertical position based on head offset + adjustment for mouth position
    
    // Calculate tongue body direction and length
    var tongue_dir_x = lengthdir_x(1, tongue_angle);
    var tongue_dir_y = lengthdir_y(1, tongue_angle);
    
    // Draw tongue body (repeated 1px sprite stretched along the path)
    for (var i = 0; i < tongue_length; i++) {
        var segment_x = tongue_origin_x + tongue_dir_x * i;
        var segment_y = tongue_origin_y + tongue_dir_y * i;
        
        // Stretch along the direction of the tongue
        draw_sprite_ext(
            spr_frog_tongue_body, 0,
            segment_x, segment_y,
            1, 1, // Scale factors
            tongue_angle, // Rotation angle
            c_white, 1
        );
    }
    
    // Draw tongue head at the end of the tongue body
    var tongue_head_x = tongue_origin_x + tongue_dir_x * tongue_length;
    var tongue_head_y = tongue_origin_y + tongue_dir_y * tongue_length;
    
    // Draw the tongue head (rotated to match the angle)
    draw_sprite_ext(
        spr_frog_tongue_head, 0,
        tongue_head_x, tongue_head_y,
        1, 1, // Scale factors
        tongue_angle, // Rotation angle
        c_white, 1
    );
}

// Draw charge bar during Charging state
if (state == "Charging" && sprite_exists(spr_charge_bar)) {
    var charge_ratio = jump_charge / jump_charge_max; // Value between 0 and 1
    // Assuming spr_charge_bar has multiple frames for different charge levels
    var number_of_charge_frames = sprite_get_number(spr_charge_bar);
    var frame_index = clamp(floor(charge_ratio * number_of_charge_frames), 0, number_of_charge_frames - 1);
    draw_sprite(spr_charge_bar, frame_index, x + 2, y - 16); // Position charge bar relative to frog
}