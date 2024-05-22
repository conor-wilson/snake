extends Node2D

@export var muted:bool

const INGAME_MUSIC_VOLUME     = 0   # dB
const PAUSE_MENU_MUSIC_VOLUME = -15 # dB

func _ready():
	muted = false

func mute():
	muted = true
	stop_music()

func unmute():
	muted = false

func play_start_game():
	if !muted:
		$StartGame.play()

func play_music():
	if !$Music.playing && !muted :
		$Music.play()

func stop_music():
	$Music.stop()

func lower_music_volume():
	$Music.volume_db = PAUSE_MENU_MUSIC_VOLUME

func increase_music_volume():
	$Music.volume_db = INGAME_MUSIC_VOLUME

func play_turn():
	if !muted:
		$Turn.play()

func play_apple_collect():
	if !muted:
		$AppleCollect.play()

func play_pause():
	if !muted:
		$Pause.play()

func play_resume():
	if !muted:
		$Resume.play()

func play_game_over():
	if !muted:
		$GameOver.play()
