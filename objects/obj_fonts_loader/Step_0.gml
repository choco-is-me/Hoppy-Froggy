if (!audio_group_is_loaded(UI))
{
    audio_group_load(UI);
}

// Only try to go to the next room once when audio is loaded
if (music_and_sound_loaded()) {
    room_goto_next();
}