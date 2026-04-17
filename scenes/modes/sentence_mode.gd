extends Node2D

# Sentence mode: type one sentence at a time, character by character.
# Backspace allowed. No time limit. Ends after all sentences are typed
# or press Esc to return to menu.

var _sentences: Array[String] = []
var _sentence_idx: int = 0
var _char_cursor: int = 0
var _started: bool = false
var _finished: bool = false

# Per-character state: 0=untyped, 1=correct, 2=wrong
var _char_state: Array[int] = []


func _ready() -> void:
	StatsTracker.reset()
	_load_sentences()
	call_deferred("_show_sentence")


func _load_sentences() -> void:
	_sentences.clear()
	# Pull all quotes and shuffle them
	var pool: Array[String] = WordBank._QUOTES.duplicate()
	pool.shuffle()
	_sentences = pool


func _current_sentence() -> String:
	if _sentence_idx >= _sentences.size():
		return ""
	return _sentences[_sentence_idx]


func _show_sentence() -> void:
	var s := _current_sentence()
	_char_cursor = 0
	_char_state.clear()
	for _i: int in s.length():
		_char_state.append(0)
	_rebuild_display()
	_update_progress_label()


func _rebuild_display() -> void:
	var s := _current_sentence()
	if s.is_empty():
		$Canvas/SentenceLabel.text = ""
		return

	# Build display string: typed chars shown, cursor marked with |, rest shown plainly
	# Use a simple approach: show the full sentence with a | caret at cursor position
	var before := s.substr(0, _char_cursor)
	var after := s.substr(_char_cursor)
	$Canvas/SentenceLabel.text = before + "|" + after

	# Show typed / remaining counts
	var wrong_count := 0
	for st: int in _char_state:
		if st == 2:
			wrong_count += 1
	$Canvas/MistakeLabel.text = "errors: %d" % wrong_count if wrong_count > 0 else ""


func _update_progress_label() -> void:
	$Canvas/ProgressLabel.text = "sentence %d / %d" % [_sentence_idx + 1, _sentences.size()]


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
		_handle_backspace()
		return

	var unicode: int = key_event.unicode
	if unicode == 0:
		return
	_handle_char(char(unicode))


func _handle_char(ch: String) -> void:
	var s := _current_sentence()
	if s.is_empty() or _char_cursor >= s.length():
		return

	if not _started:
		_started = true

	if ch == s[_char_cursor]:
		_char_state[_char_cursor] = 1
		StatsTracker.record_correct_key()
	else:
		_char_state[_char_cursor] = 2
		StatsTracker.record_total_key()

	_char_cursor += 1
	_rebuild_display()

	# Sentence complete when cursor reaches end
	if _char_cursor >= s.length():
		StatsTracker.record_word_complete(s.length())
		_advance_sentence()


func _handle_backspace() -> void:
	if _char_cursor > 0:
		_char_cursor -= 1
		_char_state[_char_cursor] = 0
		_rebuild_display()


func _advance_sentence() -> void:
	_sentence_idx += 1
	if _sentence_idx >= _sentences.size():
		_finish()
		return
	_show_sentence()
	_update_progress_label()


func _process(_delta: float) -> void:
	if _started and not _finished:
		$Canvas/WPMLabel.text = "WPM  %d" % int(StatsTracker.get_wpm())
		$Canvas/AccLabel.text = "Acc  %.0f%%" % StatsTracker.get_accuracy()


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
		"mode": "sentence",
		"wave": 0,
		"score": 0,
	}

	get_tree().change_scene_to_file("res://scenes/ui/results_screen.tscn")
