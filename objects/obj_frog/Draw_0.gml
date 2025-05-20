// Calculate head offset based on state and current body sprite
var head_offset = -6; // Default for 7px height sprites (idle, hop)
if (state == "Charging" && current_body_sprite == spr_frog_prehop_body) {
    // Assuming spr_frog_prehop_body might be shorter (e.g., 5px as per original comment)
    // Adjust this value based on your actual sprite heights for prehop
    // If prehop body sprite height is different and makes head appear detached:
    // head_offset = -4; // Example for a 5px tall pre-hop body
} else if (current_body_sprite == spr_frog_idle_body || current_body_sprite == spr_frog_hop_body) {
    head_offset = -6; // For 7px height sprites
}
// Add more conditions if other sprites have different anchor points or heights.


// Draw frog body and head, flipping based on 'facing'
// Ensure sprites exist before drawing
if (sprite_exists(current_body_sprite)) {
    draw_sprite_ext(current_body_sprite, image_index, x, y, facing, 1, 0, c_white, 1);
}
if (sprite_exists(current_head_sprite)) {
    draw_sprite_ext(current_head_sprite, image_index, x, y + head_offset, facing, 1, 0, c_white, 1);
}

// Draw charge bar during Charging state
if (state == "Charging" && sprite_exists(spr_charge_bar)) {
    var charge_ratio = jump_charge / jump_charge_max; // Value between 0 and 1
    // Assuming spr_charge_bar has multiple frames (e.g., 4 frames for 0%, 33%, 66%, 100%)
    var number_of_charge_frames = sprite_get_number(spr_charge_bar);
    var frame_index = clamp(floor(charge_ratio * number_of_charge_frames), 0, number_of_charge_frames - 1);
    draw_sprite(spr_charge_bar, frame_index, x + 2, y - 16); // Position charge bar relative to frog & its direction
}