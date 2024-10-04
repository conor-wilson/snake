extends Node2D

const INGAME_MUSIC_VOLUME     = 0   # The volume of the game music in dB when the player is in-game. 
const PAUSE_MENU_MUSIC_VOLUME = -15 # The volume of the game music in dB when the game is paused.

# play_music plays the game music.
func play_music():
	if !$Music.playing && !Global.mute :
		$Music.play()

# play_music stops the game music if the game is muted. This is useful for haulting the
# music the moment that the player mutes the game.
func stop_music_if_muted():
	if Global.mute:
		stop_music()

# stop_music stops the game music.
func stop_music():
	$Music.stop()

# increase_music_volume increases the music's volume to INGAME_MUSIC_VOLUME.
func increase_music_volume():
	$Music.volume_db = INGAME_MUSIC_VOLUME

# lower_music_volume lowers the music's volume to PAUSE_MENU_MUSIC_VOLUME.
func lower_music_volume():
	$Music.volume_db = PAUSE_MENU_MUSIC_VOLUME

# play_turn plays the turn sound-effect.
func play_turn():
	if !$Turn.playing && !Global.mute:
		$Turn.play()

# play_turn plays the apple collection sound-effect. If special_sound is true, it plays a
# special sound (used when a new high-score has been reached and when WORM MODE is
# unlocked).
func play_apple_collect(special_sound:bool):
	if !Global.mute:
		if !special_sound:
			$AppleCollect.play()
		else:
			$StartGame.play()

# play_game_over plays the game-over sound-effect.
func play_game_over():
	if !Global.mute:
		$GameOver.play()

# play_game_over plays the start-game sound-effect.
func play_start_game():
	if !Global.mute:
		$StartGame.play()

# play_game_over plays the cancel sound-effect.
func play_cancel():
	if !Global.mute:
		$Cancel.play()
