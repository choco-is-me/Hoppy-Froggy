function get_controls(){
    if (global.input_locked) {
        key_left = 0;
        key_right = 0;
        key_up = 0;
        key_down = 0;
        key_space_pressed = 0;
        key_space_held = 0;
        key_space_released = 0;
        mouse_left_pressed = 0;
        return;
    }
    
    key_left = InputCheck(INPUT_VERB.LEFT);
    key_right = InputCheck(INPUT_VERB.RIGHT);
    key_up = InputCheck(INPUT_VERB.UP);
    key_down = InputCheck(INPUT_VERB.DOWN);
    key_space_pressed = InputPressed(INPUT_VERB.JUMP_PRESSED);
    key_space_held = InputCheck(INPUT_VERB.JUMP_HELD);
    key_space_released = InputReleased(INPUT_VERB.JUMP_RELEASED);
    mouse_left_pressed = InputPressed(INPUT_VERB.MOUSE_LEFT);
}