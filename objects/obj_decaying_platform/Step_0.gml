if (place_meeting(x, y - 1, obj_frog)) {
    stand_timer += 1;
    if (stand_timer >= break_time) {
        breaking = true;
    }
} else {
    stand_timer = 0;
}

if (breaking) {
    instance_destroy();
}