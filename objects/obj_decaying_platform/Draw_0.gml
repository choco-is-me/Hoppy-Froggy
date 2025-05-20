// Draw with visual feedback
var color = c_white;
if (stand_timer > 0) {
    // Gradually change color to indicate breaking
    var break_progress = stand_timer / break_time;
    color = merge_color(c_white, c_red, break_progress);
}

draw_sprite_ext(sprite_index, image_index, x, y, 
                image_xscale, image_yscale, image_angle, 
                color, alpha);