extends Node2D

const STARTING_LIVES := 3
const BulletScene := preload("res://scenes/entities/bullet.tscn")

enum State { PLAYING, PAUSED, GAME_OVER }

var _score: int = 0
var _lives: int = STARTING_LIVES
var _state: State = State.PLAYING


func _ready() -> void:
	StatsTracker.reset()

	$TypingEngine.word_completed.connect(_on_word_completed)
	$TypingEngine.letter_typed.connect(_on_letter_typed)
	$TypingEngine.progress_updated.connect($HUD.update_typed)
	$TypingEngine.sentence_char_typed.connect($HUD.on_sentence_char_typed)
	$TypingEngine.sentence_mistype.connect($HUD.on_sentence_mistype)
	$TypingEngine.sentence_backspace.connect($HUD.on_sentence_backspace)
	$TypingEngine.sentence_completed.connect(_on_sentence_completed)

	$WaveManager.wave_started.connect($HUD.update_wave)
	$WaveManager.enemy_reached_center.connect(_on_enemy_reached_center)
	$WaveManager.boss_killed.connect(_on_boss_killed)
	$WaveManager.boss_incoming.connect($HUD.show_boss_announcement)

	$HUD.update_score(_score)
	$HUD.update_lives(_lives)

	$WPMTimer.timeout.connect(_update_wpm)

	$PauseMenu.resume_requested.connect(_on_resume)
	$PauseMenu.settings_requested.connect(_on_settings)
	$PauseMenu.main_menu_requested.connect(_go_main_menu)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if _state == State.PLAYING:
			_pause()
			get_viewport().set_input_as_handled()
		elif _state == State.PAUSED:
			_on_resume()
			get_viewport().set_input_as_handled()


func _pause() -> void:
	_state = State.PAUSED
	$PauseMenu.show_pause()


func _on_resume() -> void:
	_state = State.PLAYING
	$PauseMenu.hide_pause()


func _on_settings() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/settings.tscn")


func _go_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_letter_typed(enemy: Node2D) -> void:
	var bullet: Node2D = BulletScene.instantiate()
	bullet.setup($Player.global_position, enemy, false)
	add_child(bullet)


func _on_word_completed(enemy: Node2D) -> void:
	_score += 10
	$HUD.update_score(_score)
	var bullet: Node2D = BulletScene.instantiate()
	# Boss words fire non-killing bullets — the sentence_completed signal kills the boss
	var kill := not enemy.is_in_group("boss")
	bullet.setup($Player.global_position, enemy, kill)
	add_child(bullet)


func _on_sentence_completed(_group: Node2D) -> void:
	_score += 50
	$HUD.update_score(_score)
	$HUD.clear_sentence_bar()


func _on_boss_killed(bonus: int) -> void:
	_score += bonus
	$HUD.update_score(_score)


func _on_enemy_reached_center() -> void:
	if _state == State.GAME_OVER:
		return
	_lives -= 1
	$HUD.update_lives(_lives)
	if _lives <= 0:
		_game_over()


func _game_over() -> void:
	if _state == State.GAME_OVER:
		return
	_state = State.GAME_OVER

	if _score > 0:
		ScoreManager.add_score(_score)

	StatsTracker.pending_results = {
		"wpm": StatsTracker.get_wpm(),
		"raw_wpm": StatsTracker.get_raw_wpm(),
		"accuracy": StatsTracker.get_accuracy(),
		"consistency": StatsTracker.get_consistency(),
		"elapsed": StatsTracker.get_elapsed(),
		"chars": StatsTracker.get_chars(),
		"mode": "survival",
		"wave": $WaveManager.current_wave,
		"score": _score,
	}

	get_tree().change_scene_to_file("res://scenes/ui/results_screen.tscn")


func _update_wpm() -> void:
	$HUD.update_wpm(StatsTracker.get_wpm(), StatsTracker.get_accuracy())


