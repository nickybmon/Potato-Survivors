extends Node2D

const STARTING_LIVES := 3

var _score: int = 0
var _lives: int = STARTING_LIVES


func _ready() -> void:
	$TypingEngine.enemy_destroyed.connect(_on_enemy_destroyed)
	$TypingEngine.progress_updated.connect($HUD.update_typed)
	$WaveManager.wave_started.connect($HUD.update_wave)
	$WaveManager.enemy_reached_center.connect(_on_enemy_reached_center)
	$HUD.update_score(_score)
	$HUD.update_lives(_lives)


func _on_enemy_destroyed() -> void:
	_score += 10
	$HUD.update_score(_score)


func _on_enemy_reached_center() -> void:
	_lives -= 1
	$HUD.update_lives(_lives)
	if _lives <= 0:
		_game_over()


func _game_over() -> void:
	get_tree().paused = true
	$HUD.show_game_over()
