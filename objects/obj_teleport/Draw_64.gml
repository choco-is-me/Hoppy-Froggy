// Draw GUI
// Only draw the fade effect if teleporting
if (teleporting && fade_alpha > 0) {
    // Set blend mode for proper alpha blending
    draw_set_color(c_black);
    draw_set_alpha(fade_alpha);
    
    // Draw black rectangle covering the entire GUI/display area
    // This uses (0,0) as the starting point and covers the full screen dimensions
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    
    // Reset alpha for other drawing operations
    draw_set_alpha(1);
}