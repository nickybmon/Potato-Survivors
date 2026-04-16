extends CanvasLayer

signal restart_requested


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


func show_game_over(score: int) -> void:
	_build_game_over_panel(score)


func _build_game_over_panel(score: int) -> void:
	# Dim overlay
	var overlay := ColorRect.new()
	overlay.color = Color(0.0, 0.0, 0.0, 0.55)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(overlay)

	# Centered panel
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(420.0, 0.0)
	panel.position = Vector2(430.0, 130.0)
	panel.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	panel.add_child(vbox)

	# Title
	var title := Label.new()
	title.text = "GAME OVER"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 52)
	vbox.add_child(title)

	# Final score
	var score_lbl := Label.new()
	score_lbl.text = "Score: %d" % score
	score_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_lbl.add_theme_font_size_override("font_size", 26)
	vbox.add_child(score_lbl)

	# High score
	var hi := ScoreManager.get_high_score()
	var hi_lbl := Label.new()
	if score >= hi:
		hi_lbl.text = "NEW BEST!"
	else:
		hi_lbl.text = "Best: %d" % hi
	hi_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hi_lbl.add_theme_font_size_override("font_size", 20)
	vbox.add_child(hi_lbl)

	vbox.add_child(HSeparator.new())

	# Leaderboard header
	var board_title := Label.new()
	board_title.text = "Top 10 Scores"
	board_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	board_title.add_theme_font_size_override("font_size", 18)
	vbox.add_child(board_title)

	var scores: Array = ScoreManager.get_scores()
	for i: int in scores.size():
		var entry := Label.new()
		var marker := " <" if scores[i] == score else ""
		entry.text = "%2d.  %d%s" % [i + 1, scores[i], marker]
		entry.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		entry.add_theme_font_size_override("font_size", 16)
		vbox.add_child(entry)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0.0, 8.0)
	vbox.add_child(spacer)

	# Play Again button
	var btn := Button.new()
	btn.text = "Play Again"
	btn.add_theme_font_size_override("font_size", 22)
	btn.focus_mode = Control.FOCUS_NONE
	btn.pressed.connect(_on_play_again)
	vbox.add_child(btn)


func _on_play_again() -> void:
	restart_requested.emit()
