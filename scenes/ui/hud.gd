extends CanvasLayer

signal restart_requested

var _sentence: String = ""
var _sentence_char_state: Array[int] = []   # 0=pending, 1=correct, 2=wrong, 3=backspaced


func update_score(score: int) -> void:
	$ScoreLabel.text = "Score: %d" % score


func update_lives(lives: int) -> void:
	$LivesLabel.text = "Lives: %d" % lives


func update_wave(wave: int) -> void:
	$WaveLabel.text = "Wave %d" % wave


func update_typed(word: String, progress: int) -> void:
	if _sentence.is_empty():
		if word.is_empty() or progress == 0:
			$TypedDisplay.text = ""
		else:
			var typed := word.substr(0, progress)
			var remaining := word.substr(progress)
			$TypedDisplay.text = "[center][color=yellow]%s[/color]%s[/center]" % [typed, remaining]


func update_wpm(wpm: float, accuracy: float) -> void:
	$WPMLabel.text = "%d wpm  %.0f%%" % [int(wpm), accuracy]


func show_boss_announcement(wave: int) -> void:
	# Build a temporary label that fades in, holds, then fades out
	var lbl := Label.new()
	lbl.text = "⚠  BOSS WAVE %d  ⚠" % wave
	lbl.add_theme_font_size_override("font_size", 48)
	lbl.add_theme_color_override("font_color", Color(1.0, 0.2, 0.2, 1.0))
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	lbl.custom_minimum_size = Vector2(700, 80)
	lbl.offset_left = -350.0
	lbl.offset_top = -40.0
	lbl.offset_right = 350.0
	lbl.offset_bottom = 40.0
	lbl.modulate.a = 0.0
	lbl.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(lbl)

	var tween := create_tween()
	tween.tween_property(lbl, "modulate:a", 1.0, 0.3)
	tween.tween_interval(1.5)
	tween.tween_property(lbl, "modulate:a", 0.0, 0.4)
	tween.tween_callback(lbl.queue_free)


# --- Sentence bar ---

func start_sentence_bar(sentence: String) -> void:
	_sentence = sentence
	_sentence_char_state.clear()
	for _i: int in sentence.length():
		_sentence_char_state.append(0)
	$TypedDisplay.text = ""
	_rebuild_sentence_bar()


func clear_sentence_bar() -> void:
	_sentence = ""
	_sentence_char_state.clear()
	$SentenceBar.text = ""


func on_sentence_char_typed(pos: int) -> void:
	if pos < _sentence_char_state.size():
		_sentence_char_state[pos] = 1
	_rebuild_sentence_bar()


func on_sentence_mistype(pos: int) -> void:
	if pos < _sentence_char_state.size():
		_sentence_char_state[pos] = 2
	_rebuild_sentence_bar()


func on_sentence_backspace(pos: int) -> void:
	if pos < _sentence_char_state.size():
		_sentence_char_state[pos] = 0
	_rebuild_sentence_bar()


func _rebuild_sentence_bar() -> void:
	if _sentence.is_empty():
		return
	var text := "[center]"
	for i: int in _sentence.length():
		var ch: String = _sentence[i]
		match _sentence_char_state[i]:
			1: text += "[color=#f5c518]%s[/color]" % ch   # gold = correct
			2: text += "[color=#e05555]%s[/color]" % ch   # red = wrong
			_: text += "[color=#888888]%s[/color]" % ch   # gray = pending
	text += "[/center]"
	$SentenceBar.text = text


# --- Game over (legacy fallback, now replaced by results_screen) ---

func show_game_over(score: int) -> void:
	_build_game_over_panel(score)


func _build_game_over_panel(score: int) -> void:
	var overlay := ColorRect.new()
	overlay.color = Color(0.0, 0.0, 0.0, 0.55)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(overlay)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(420.0, 0.0)
	panel.position = Vector2(430.0, 130.0)
	panel.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	panel.add_child(vbox)

	var title := Label.new()
	title.text = "GAME OVER"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 52)
	vbox.add_child(title)

	var score_lbl := Label.new()
	score_lbl.text = "Score: %d" % score
	score_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_lbl.add_theme_font_size_override("font_size", 26)
	vbox.add_child(score_lbl)

	var hi := ScoreManager.get_high_score()
	var hi_lbl := Label.new()
	hi_lbl.text = "NEW BEST!" if score >= hi else "Best: %d" % hi
	hi_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hi_lbl.add_theme_font_size_override("font_size", 20)
	vbox.add_child(hi_lbl)

	vbox.add_child(HSeparator.new())

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

	var btn := Button.new()
	btn.text = "Play Again"
	btn.add_theme_font_size_override("font_size", 22)
	btn.focus_mode = Control.FOCUS_NONE
	btn.pressed.connect(_on_play_again)
	vbox.add_child(btn)


func _on_play_again() -> void:
	restart_requested.emit()
