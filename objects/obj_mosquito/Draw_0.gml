/// Draw Event
// Draw mosquito with facing direction and alpha for death fade
draw_sprite_ext(sprite_index, image_index, x, y, facing, 1, 0, c_white, death_alpha);

/// Receive Damage Function for obj_mosquito
function receive_damage(amount) {
    hp -= amount;
    state = "Damaged";
    damaged_timer = 0;
    damaged_frame = 0;
}