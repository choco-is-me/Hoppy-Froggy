// Draw GUI
// Draw the fade overlay if not completely transparent
if (alpha > 0) {
    // Store previous alpha and color settings
    var prev_alpha = draw_get_alpha();
    var prev_color = draw_get_color();
    
    // Draw black rectangle over the entire GUI layer (will appear on top of everything)
    draw_set_alpha(alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    
    // Restore previous settings
    draw_set_alpha(prev_alpha);
    draw_set_color(prev_color);
}