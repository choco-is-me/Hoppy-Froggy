/// @description Draw UI Elements

// 1. Get the dynamic size of the GUI layer
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// --- DRAW HEALTH BAR (Top Left) ---
// We use draw_sprite_ext to allow for scaling (resizing)
// Args: sprite, subimg, x, y, xscale, yscale, rot, color, alpha

if (variable_instance_exists(id, "health_bar_frame")) {
    draw_sprite_ext(spr_health_bar, health_bar_frame, ui_hp_x, ui_hp_y, ui_hp_scale, ui_hp_scale, 0, c_white, 1);
} else {
    draw_sprite_ext(spr_health_bar, 0, ui_hp_x, ui_hp_y, ui_hp_scale, ui_hp_scale, 0, c_white, 1);
}


// --- DRAW CHARGE BAR (Bottom Left) ---

// 1. Calculate the Frame
var _charge_frame = 0; // Default to empty

// FIX: Only calculate the charge frame if we are actively in the "Charging" state
if (state == "Charging" && jump_charge > 0) {
    // Math: (Current / Max) * MaxFrameIndex
    // Frame 0 = Empty, Frame 4 = Full (4 blocks)
    _charge_frame = round((jump_charge / jump_charge_max) * 4);
    
    // Safety clamp
    _charge_frame = clamp(_charge_frame, 0, 4);
}

// 2. Calculate Position (Bottom Left)
// Since the origin is Top-Left, we need to subtract the sprite's height from the bottom of the screen
var _sprite_h = sprite_get_height(spr_charge_bar) * ui_charge_scale;
var _draw_y = _gui_h - _sprite_h - ui_charge_y;

// 3. Draw the Sprite
draw_sprite_ext(spr_charge_bar, _charge_frame, ui_charge_x, _draw_y, ui_charge_scale, ui_charge_scale, 0, c_white, 1);