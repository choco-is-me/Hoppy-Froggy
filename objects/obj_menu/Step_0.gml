// Load Controls
get_controls();

// Mouse input checks
var _mouse_x_pos = device_mouse_x(0);
var _mouse_y_pos = device_mouse_y(0);

// Update options length for current menu level
op_length = array_length(option[menu_level]);

// Keyboard navigation
var _new_pos = pos;
if (key_down) _new_pos++;
if (key_up) _new_pos--;

// Handle wrap-around navigation
if(_new_pos >= op_length){
    _new_pos = 0;
}
if(_new_pos < 0){
    _new_pos = op_length - 1;
}

// Mouse hover detection
var _mouse_over_option = -1;
hovering = false; // Reset hover state

for (var _i = 0; _i < op_length; _i++) {
    var _option_x = x + op_border;
    var _option_y = y + op_border + op_space * _i;
    var _display_text = option[menu_level, _i];
    var _option_w = string_width(_display_text) * 0.5; // Scale by 0.5 as in draw
    var _option_h = font_get_size(fnt_main_outline_shade) * 0.5;

    // Check if mouse is within the bounding box of this option
    if (_mouse_x_pos >= _option_x && 
        _mouse_x_pos <= _option_x + _option_w && 
        _mouse_y_pos >= _option_y && 
        _mouse_y_pos <= _option_y + _option_h) {
        _mouse_over_option = _i;
        hovering = true;
        break;
    }
}

// Update pos based on latest action
var _old_pos = pos;

if (_mouse_over_option != -1 && !menu_locked) {
    pos = _mouse_over_option;
} else if ((key_up || key_down) && !menu_locked) {
    pos = _new_pos;
}

// Play hover sound if position changed
if (pos != _old_pos && !menu_locked) {
    audio_play_sound(snd_hover, 0, false);
}

// Interaction detection (keyboard or mouse)
var _interaction_detected = (key_space_pressed) || (mouse_left_pressed && hovering);

if (_interaction_detected && !menu_locked) {    
    // Handle menu selections - simplified now that we only have main menu
    switch (pos) {
        case 0: // New Game
            menu_locked = true;
            room_goto_next();
            break;
        case 1: // Exit (Touch Some Grass)
            game_end(); 
            break;
    }
}