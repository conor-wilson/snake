extends Node2D

const INGAME_MUSIC_VOLUME     = 0   # dB
const PAUSE_MENU_MUSIC_VOLUME = -15 # dB


func play_music():
	if !$Music.playing && !Global.mute :
		$Music.play()

func stop_music_if_muted():	
	if Global.mute:
		stop_music()

func stop_music():
	$Music.stop()

func lower_music_volume():
	$Music.volume_db = PAUSE_MENU_MUSIC_VOLUME

func increase_music_volume():
	$Music.volume_db = INGAME_MUSIC_VOLUME

func play_turn():
	if !$Turn.playing && !Global.mute:
		$Turn.play()

func play_apple_collect():
	if !Global.mute:
		$AppleCollect.play()

func play_game_over():
	if !Global.mute:
		$GameOver.play()
