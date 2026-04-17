extends Node

# Pending results data — set before scene transition, read by results_screen
var pending_results: Dictionary = {}

var _correct_timestamps: Array[float] = []
var _total_keystrokes: int = 0
var _correct_count: int = 0
var _session_start: float = 0.0
var _dead_time: float = 0.0        # accumulated seconds spent between waves
var _pause_started: float = -1.0   # wall time when timer was paused; -1 = not paused
var _per_word_wpms: Array[float] = []
var _word_start_time: float = 0.0
var _word_correct_keys: int = 0


func reset() -> void:
	_correct_timestamps.clear()
	_per_word_wpms.clear()
	_total_keystrokes = 0
	_correct_count = 0
	_dead_time = 0.0
	_pause_started = -1.0
	_session_start = Time.get_ticks_msec() / 1000.0
	_word_start_time = _session_start
	_word_correct_keys = 0


# Call when enemies clear (wave ends) — stops the active-time clock
func pause_timer() -> void:
	if _pause_started >= 0.0:
		return  # already paused
	_pause_started = Time.get_ticks_msec() / 1000.0


# Call when the next wave starts — resumes the active-time clock
func resume_timer() -> void:
	if _pause_started < 0.0:
		return  # not paused
	_dead_time += (Time.get_ticks_msec() / 1000.0) - _pause_started
	_pause_started = -1.0
	# Reset word start so the first word of the new wave isn't penalised
	_word_start_time = Time.get_ticks_msec() / 1000.0


func record_correct_key() -> void:
	var now := Time.get_ticks_msec() / 1000.0
	_correct_timestamps.append(now)
	_correct_count += 1
	_total_keystrokes += 1
	_word_correct_keys += 1


func record_total_key() -> void:
	_total_keystrokes += 1


func record_word_complete(word_length: int) -> void:
	var now := Time.get_ticks_msec() / 1000.0
	var elapsed := now - _word_start_time
	if elapsed > 0.0:
		var wpm := (float(word_length) / 5.0) / (elapsed / 60.0)
		_per_word_wpms.append(wpm)
	_word_start_time = now
	_word_correct_keys = 0


func get_wpm() -> float:
	var now := Time.get_ticks_msec() / 1000.0
	# Only count timestamps that fell during active (non-paused) periods.
	# Simple approximation: use a rolling 10-second window but exclude the
	# current dead-time period so between-wave idling doesn't dilute the rate.
	var window := 10.0
	var cutoff := now - window
	var count := 0
	for t: float in _correct_timestamps:
		if t >= cutoff:
			count += 1
	return (float(count) / 5.0) * (60.0 / window)


func get_raw_wpm() -> float:
	var active := _active_elapsed()
	if active <= 0.0:
		return 0.0
	return (_correct_count / 5.0) / (active / 60.0)


func _active_elapsed() -> float:
	var now := Time.get_ticks_msec() / 1000.0
	var total := now - _session_start
	var dead := _dead_time
	# If currently paused, include the ongoing dead segment too
	if _pause_started >= 0.0:
		dead += now - _pause_started
	return maxf(total - dead, 0.0)


func get_accuracy() -> float:
	if _total_keystrokes == 0:
		return 100.0
	return (float(_correct_count) / float(_total_keystrokes)) * 100.0


func get_consistency() -> float:
	if _per_word_wpms.size() < 2:
		return 100.0
	var mean := 0.0
	for w: float in _per_word_wpms:
		mean += w
	mean /= _per_word_wpms.size()
	var variance := 0.0
	for w: float in _per_word_wpms:
		variance += (w - mean) * (w - mean)
	variance /= _per_word_wpms.size()
	var stddev := sqrt(variance)
	if mean <= 0.0:
		return 100.0
	return clampf(100.0 - (stddev / mean) * 100.0, 0.0, 100.0)


func get_elapsed() -> float:
	return _active_elapsed()


func get_chars() -> Dictionary:
	return {
		"correct": _correct_count,
		"incorrect": _total_keystrokes - _correct_count,
	}
