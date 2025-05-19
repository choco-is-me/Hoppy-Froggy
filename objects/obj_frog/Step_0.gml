if (!place_meeting(x, y + 1, obj_platform)) {
    y += 1; // Fall 1px per step if no platform below
}