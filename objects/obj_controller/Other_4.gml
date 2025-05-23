// Room Start Event
// Check if we're in the menu
if (room == rm_menu) {
    in_menu = true;
    
    // Stop game music if it's playing
    if (game_music_id != noone) {
        if (audio_is_playing(game_music_id)) {
            audio_stop_sound(game_music_id);
        }
        game_music_id = noone;
    }
} else {
    in_menu = false;
    
    // Start game music if not already playing
    if (game_music_id == noone) {
        game_music_id = audio_play_sound(game_music_sound, 5, true);
    }
}