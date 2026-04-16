extends Node2D

const STARTING_LIVES := 3
const BulletScene := preload("res://bullet.tscn")

var _score: int = 0
var _lives: int = STARTING_LIVES


func _ready() -> void:
	$TypingEngine.word_completed.connect(_on_word_completed)
	$TypingEngine.letter_typed.connect(_on_letter_typed)
	$TypingEngine.progress_updated.connect($HUD.update_typed)
	$WaveManager.wave_started.connect($HUD.update_wave)
	$WaveManager.enemy_reached_center.connect(_on_enemy_reached_center)
	$HUD.restart_requested.connect(_on_restart)
	$HUD.update_score(_score)
	$HUD.update_lives(_lives)
	_start_music()


func _start_music() -> void:
	var stream := load("res://Assets/topdown_shooter_assets/Mecha_Future_Looped.mp3")
	if stream is AudioStreamMP3:
		stream.loop = true
		$Music.stream = stream
		$Music.play()


func _on_letter_typed(enemy: Node2D) -> void:
	var bullet: Node2D = BulletScene.instantiate()
	bullet.setup($Player.global_position, enemy, false)
	add_child(bullet)


func _on_word_completed(enemy: Node2D) -> void:
	_score += 10
	$HUD.update_score(_score)
	var bullet: Node2D = BulletScene.instantiate()
	bullet.setup($Player.global_position, enemy, true)
	add_child(bullet)


func _on_enemy_reached_center() -> void:
	_lives -= 1
	$HUD.update_lives(_lives)
	if _lives <= 0:
		_game_over()


func _game_over() -> void:
	get_tree().paused = true
	ScoreManager.add_score(_score)
	$HUD.show_game_over(_score)


func _on_restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
