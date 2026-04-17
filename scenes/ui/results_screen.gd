extends Control


func _ready() -> void:
	var data: Dictionary = StatsTracker.pending_results
	if data.is_empty():
		# Fallback if navigated here directly
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
		return
	_populate(data)


func _populate(data: Dictionary) -> void:
	var wpm: float = data.get("wpm", 0.0)
	var raw_wpm: float = data.get("raw_wpm", 0.0)
	var accuracy: float = data.get("accuracy", 100.0)
	var consistency: float = data.get("consistency", 100.0)
	var elapsed: float = data.get("elapsed", 0.0)
	var mode: String = data.get("mode", "survival")
	var wave: int = data.get("wave", 0)
	var score: int = data.get("score", 0)
	var chars: Dictionary = data.get("chars", {})

	$Center/VBox/WPMLabel.text = "%d" % int(wpm)
	$Center/VBox/StatsRow/RawLabel.text = "Raw\n%d" % int(raw_wpm)
	$Center/VBox/StatsRow/AccLabel.text = "Acc\n%.0f%%" % accuracy
	$Center/VBox/StatsRow/ConsLabel.text = "Con\n%.0f%%" % consistency

	var correct: int = chars.get("correct", 0)
	var incorrect: int = chars.get("incorrect", 0)
	$Center/VBox/CharsLabel.text = "correct %d   incorrect %d" % [correct, incorrect]

	var mins := int(elapsed) / 60
	var secs := int(elapsed) % 60
	$Center/VBox/TimeLabel.text = "Time  %d:%02d" % [mins, secs]

	if mode == "survival":
		$Center/VBox/TagLabel.text = "survival · wave %d · score %d" % [wave, score]
		_build_leaderboard()
		$Center/VBox/LeaderboardSection.visible = ScoreManager.get_scores().size() > 0
	else:
		$Center/VBox/TagLabel.text = mode
		$Center/VBox/LeaderboardSection.visible = false


func _build_leaderboard() -> void:
	var container := $Center/VBox/LeaderboardSection/ScoreList
	for child in container.get_children():
		child.queue_free()

	var scores: Array = ScoreManager.get_scores()
	for i: int in scores.size():
		var lbl := Label.new()
		lbl.text = "%2d.  %d" % [i + 1, scores[i]]
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.add_theme_font_size_override("font_size", 16)
		container.add_child(lbl)


func _on_retry_pressed() -> void:
	var mode: String = StatsTracker.pending_results.get("mode", "survival")
	StatsTracker.pending_results = {}
	if mode == "practice":
		get_tree().change_scene_to_file("res://scenes/modes/practice.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/arena/arena.tscn")


func _on_settings_pressed() -> void:
	StatsTracker.pending_results = {}
	get_tree().change_scene_to_file("res://scenes/ui/settings.tscn")


func _on_main_menu_pressed() -> void:
	StatsTracker.pending_results = {}
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
