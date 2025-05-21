// If inputs are locked, all values are forced to 0
if (global.input_locked) {
    global.key_left = 0;
    global.key_right = 0;
    global.key_space_pressed = 0;
    global.key_space_held = 0;
    global.key_space_released = 0;
    global.mouse_left_pressed = 0;
} else {
    // Otherwise, process inputs normally
    global.key_left = keyboard_check(ord("A"));
    global.key_right = keyboard_check(ord("D"));
    global.key_space_pressed = keyboard_check_pressed(vk_space);
    global.key_space_held = keyboard_check(vk_space);
    global.key_space_released = keyboard_check_released(vk_space);
    global.mouse_left_pressed = mouse_check_button_pressed(mb_left);
}