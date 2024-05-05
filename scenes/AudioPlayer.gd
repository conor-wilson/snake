extends Node2D

func play_start_game():
	$StartGame.play()

func play_music():
	if !$Music.playing:
		$Music.play()

func stop_music():
	$Music.stop()

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
