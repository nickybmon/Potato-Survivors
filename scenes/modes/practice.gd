extends Node2D

var _submode: String = "timed"
var _duration: int = 60
var _word_target: int = 50

var _words: Array[String] = []
var _cursor: int = 0
var _char_cursor: int = 0
var _time_left: float = 0.0
var _words_typed: int = 0
var _started: bool = false
var _finished: bool = false


func _ready() -> void:
	_submode = GameConfig.practice_submode
	_duration = GameConfig.timed_duration
	_word_target = GameConfig.word_count_target
	_time_left = float(_duration)
	StatsTracker.reset()
	_fill_words()
	call_deferred("_rebuild_display")
	call_deferred("_update_status")
	call_deferred("_update_timer_label")


func _fill_words() -> void:
	_words.clear()
	_cursor = 0
	_char_cursor = 0

	if _submode == "quotes":
		var quote: String = WordBank.get_quote()
		for w: String in quote.split(" "):
			if not w.is_empty():
				_words.append(w)
	else:
		var count: int = max(_word_target * 2, 100)
		var pool: Array[String] = WordBank._COMMON.duplicate()
		pool.shuffle()
		while _words.size() < count:
			if pool.is_empty():
				pool = WordBank._COMMON.duplicate()
				pool.shuffle()
			_words.append(pool.pop_back())


func _rebuild_display() -> void:
	var lbl: Label = $Canvas/WordDisplay
	if _words.is_empty():
		lbl.text = ""
		return

	var parts: Array[String] = []
	for i: int in range(maxi(0, _cursor - 3), _cursor):
		parts.append(_words[i])
	if _cursor < _words.size():
		var word: String = _words[_cursor]
		parts.append(word.substr(0, _char_cursor) + "|" + word.substr(_char_cursor))
	for i: int in range(_cursor + 1, mini(_words.size(), _cursor + 26)):
		parts.append(_words[i])
	lbl.text = " ".join(parts)


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed:
		return
	var key_event := event as InputEventKey

	if key_event.keycode == KEY_ESCAPE:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
		return

	if _finished:
		return

	if key_event.keycode == KEY_BACKSPACE:
		if _char_cursor > 0:
			_char_cursor -= 1
			_rebuild_display()
		return

	var unicode: int = key_event.unicode
	if unicode == 0:
		return
	_handle_char(char(unicode))


func _handle_char(ch: String) -> void:
	if _cursor >= _words.size():
		return

	if not _started:
		_started = true

	var word: String = _words[_cursor]

	if ch == " " and _char_cursor >= word.length():
		StatsTracker.record_word_complete(word.length())
		_words_typed += 1
		_cursor += 1
		_char_cursor = 0
		if _submode == "word_count" and _words_typed >= _word_target:
			_finish()
			return
		_rebuild_display()
		_update_status()
		return

	if _char_cursor >= word.length():
		return

	if ch == word[_char_cursor]:
		StatsTracker.record_correct_key()
	else:
		StatsTracker.record_total_key()

	_char_cursor += 1
	_rebuild_display()


func _process(delta: float) -> void:
	if _submode == "timed" and _started and not _finished:
		_time_left -= delta
		_update_timer_label()
		if _time_left <= 0.0:
			_finish()

	if _started and not _finished:
		$Canvas/WPMLabel.text = "WPM  %d" % int(StatsTracker.get_wpm())
		$Canvas/AccLabel.text = "Acc  %.0f%%" % StatsTracker.get_accuracy()


func _update_timer_label() -> void:
	if _submode == "timed":
		$Canvas/TimerLabel.text = "%d" % ceili(_time_left)
	else:
		$Canvas/TimerLabel.text = ""


func _update_status() -> void:
	match _submode:
		"word_count":
			$Canvas/StatusLabel.text = "%d / %d words" % [_words_typed, _word_target]
		"quotes":
			$Canvas/StatusLabel.text = "word %d of %d" % [_cursor + 1, _words.size()]
		_:
			$Canvas/StatusLabel.text = ""


func _finish() -> void:
	if _finished:
		return
	_finished = true

	StatsTracker.pending_results = {
		"wpm": StatsTracker.get_wpm(),
		"raw_wpm": StatsTracker.get_raw_wpm(),
		"accuracy": StatsTracker.get_accuracy(),
		"consistency": StatsTracker.get_consistency(),
		"elapsed": StatsTracker.get_elapsed(),
		"chars": StatsTracker.get_chars(),
		"mode": "practice",
		"wave": 0,
		"score": 0,
	}

	get_tree().change_scene_to_file("res://scenes/ui/results_screen.tscn")
