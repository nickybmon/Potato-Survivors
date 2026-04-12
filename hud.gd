extends CanvasLayer


func update_score(score: int) -> void:
	$ScoreLabel.text = "Score: %d" % score


func update_lives(lives: int) -> void:
	$LivesLabel.text = "Lives: %d" % lives


func update_wave(wave: int) -> void:
	$WaveLabel.text = "Wave %d" % wave


func update_typed(word: String, progress: int) -> void:
	if word.is_empty() or progress == 0:
		$TypedDisplay.text = ""
	else:
		var typed := word.substr(0, progress)
		var remaining := word.substr(progress)
		$TypedDisplay.text = "[center][color=yellow]%s[/color]%s[/center]" % [typed, remaining]


func show_game_over() -> void:
	$GameOverLabel.visible = true
