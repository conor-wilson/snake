extends Node2D

const INGAME_MUSIC_VOLUME     = 0   # dB
const PAUSE_MENU_MUSIC_VOLUME = -15 # dB

func play_start_game():
	$StartGame.play()

func play_music():
	if !$Music.playing:
		$Music.play()

func stop_music():
	$Music.stop()

func lower_music_volume():
	$Music.volume_db = PAUSE_MENU_MUSIC_VOLUME

func increase_music_volume():
	$Music.volume_db = INGAME_MUSIC_VOLUME

func play_turn():
	$Turn.play()

func play_apple_collect():
	$AppleCollect.play()

func play_pause():
	$Pause.play()

func play_resume():
	$Resume.play()

func play_game_over():
	$GameOver.play()
