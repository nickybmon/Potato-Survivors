extends Node

signal word_completed(enemy: Node2D)
signal letter_typed(enemy: Node2D)
signal progress_updated(word: String, progress: int)

# Sentence mode signals
signal sentence_char_typed(pos: int)
signal sentence_mistype(pos: int)
signal sentence_backspace(pos: int)
signal sentence_completed(group: Node2D)

var _target: Node2D = null
var _progress: int = 0

# Sentence mode state
var _mode: String = "word"        # "word" | "sentence"
var _sentence: String = ""
var _sentence_progress: int = 0
var _sentence_group: Node2D = null
var _sentence_word_idx: int = 0    # which word in the sentence we're currently on
var _sentence_words: Array[String] = []
var _sentence_word_start: int = 0  # char offset in _sentence where current word starts


func set_mode(m: String) -> void:
	_mode = m
	_target = null
	_progress = 0
	_sentence = ""
	_sentence_progress = 0
	_sentence_group = null
	_sentence_word_idx = 0
	_sentence_words.clear()
	_sentence_word_start = 0
	progress_updated.emit("", 0)


func start_sentence(sentence: String, group: Node2D) -> void:
	_mode = "sentence"
	_sentence = sentence
	_sentence_progress = 0
	_sentence_group = group
	_sentence_word_idx = 0
	_sentence_words.clear()
	for w: String in sentence.split(" "):
		if not w.is_empty():
			_sentence_words.append(w)
	_sentence_word_start = 0
	_target = null
	_progress = 0


func _process(_delta: float) -> void:
	# If our target died or was freed externally, fully reset so the player
	# can start a new word from its first letter on the next keypress.
	if _target != null and not is_instance_valid(_target):
		_target = null
		_progress = 0
		progress_updated.emit("", 0)


func _unhandled_input(event: InputEvent) -> void:
	if get_tree().paused:
		return
	if not event is InputEventKey or not event.pressed:
		return
	var key_event := event as InputEventKey

	if _mode == "sentence":
		_handle_sentence_input(key_event)
		return

	# Word mode: accept a-z (case-insensitive)
	var unicode: int = key_event.unicode
	if unicode >= 65 and unicode <= 90:
		unicode += 32
	if unicode < 97 or unicode > 122:
		return
	_handle_char(char(unicode))


func _handle_sentence_input(key_event: InputEventKey) -> void:
	# Backspace
	if key_event.keycode == KEY_BACKSPACE:
		if _sentence_progress > 0:
			_sentence_progress -= 1
			sentence_backspace.emit(_sentence_progress)
		return

	var unicode: int = key_event.unicode
	if unicode == 0:
		return

	var ch := char(unicode)
	if _sentence_progress >= _sentence.length():
		return

	if ch == _sentence[_sentence_progress]:
		_sentence_progress += 1
		sentence_char_typed.emit(_sentence_progress - 1)
		StatsTracker.record_correct_key()

		# Fire a bullet toward the current word's enemy on every correct keystroke
		if is_instance_valid(_sentence_group):
			var current_enemy: Node2D = _sentence_group.get_enemy(_sentence_word_idx)
			if current_enemy != null and is_instance_valid(current_enemy):
				letter_typed.emit(current_enemy)

		# Check if we just finished a word (next char is space or end of sentence)
		var at_word_end := (
			_sentence_progress >= _sentence.length()
			or _sentence[_sentence_progress] == " "
		)
		if at_word_end and _sentence_word_idx < _sentence_words.size():
			# Kill the enemy corresponding to this word
			if is_instance_valid(_sentence_group):
				var enemy: Node2D = _sentence_group.get_enemy(_sentence_word_idx)
				if enemy != null and is_instance_valid(enemy):
					StatsTracker.record_word_complete(_sentence_words[_sentence_word_idx].length())
					word_completed.emit(enemy)
			_sentence_word_idx += 1
			# Skip the space character
			if _sentence_progress < _sentence.length() and _sentence[_sentence_progress] == " ":
				_sentence_progress += 1
				sentence_char_typed.emit(_sentence_progress - 1)

		if _sentence_progress >= _sentence.length():
			var grp := _sentence_group
			_sentence = ""
			_sentence_progress = 0
			_sentence_group = null
			_sentence_word_idx = 0
			_sentence_words.clear()
			_sentence_word_start = 0
			_mode = "word"
			sentence_completed.emit(grp)
	else:
		sentence_mistype.emit(_sentence_progress)
		StatsTracker.record_total_key()


func _handle_char(ch: String) -> void:
	if _target == null:
		_find_target(ch)
	else:
		_advance(ch)


func _find_target(ch: String) -> void:
	var enemies_node := get_parent().get_node("Enemies")
	var player := get_parent().get_node("Player") as Node2D
	var center := player.global_position if player != null else Vector2(640.0, 360.0)

	# Among all enemies whose word starts with ch, pick the one closest to center
	# (most dangerous). This prevents stun-lock when multiple enemies share a letter.
	var best: Node2D = null
	var best_dist := INF
	for enemy in enemies_node.get_children():
		if not is_instance_valid(enemy):
			continue
		if not enemy.has_method("update_display"):
			continue
		if enemy.word.begins_with(ch):
			var d: float = (enemy as Node2D).global_position.distance_to(center)
			if d < best_dist:
				best_dist = d
				best = enemy

	if best == null:
		return

	_target = best
	_progress = 1
	best.update_display(_progress)
	progress_updated.emit(best.word, _progress)
	StatsTracker.record_correct_key()
	if _progress >= best.word.length():
		_destroy_target()
	else:
		letter_typed.emit(_target)


func _advance(ch: String) -> void:
	var word: String = _target.word
	if ch == word[_progress]:
		_progress += 1
		_target.update_display(_progress)
		progress_updated.emit(word, _progress)
		StatsTracker.record_correct_key()
		if _progress >= word.length():
			StatsTracker.record_word_complete(word.length())
			_destroy_target()
		else:
			letter_typed.emit(_target)
	else:
		StatsTracker.record_total_key()
		_target.update_display(0)
		_target = null
		_progress = 0
		progress_updated.emit("", 0)


func get_target() -> Node2D:
	return _target


func _destroy_target() -> void:
	var enemy := _target
	_target = null
	_progress = 0
	progress_updated.emit("", 0)
	word_completed.emit(enemy)
