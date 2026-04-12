extends Node

signal wave_started(wave: int)
signal enemy_reached_center

const ARENA_SIZE := Vector2(1280.0, 720.0)
const ENEMY_SCENE := preload("res://enemy.tscn")
const BASE_INTERVAL := 3.0
const BASE_COUNT := 5

var current_wave: int = 0
var _spawned_this_wave: int = 0
var _alive: int = 0

@onready var _timer: Timer = $SpawnTimer


func _ready() -> void:
	_timer.connect("timeout", _on_timer_timeout)
	_start_wave()


func _start_wave() -> void:
	current_wave += 1
	_spawned_this_wave = 0
	_alive = 0
	_timer.wait_time = max(0.8, BASE_INTERVAL - (current_wave - 1) * 0.3)
	_timer.one_shot = false
	_timer.start()
	wave_started.emit(current_wave)


func _wave_enemy_count() -> int:
	return BASE_COUNT + (current_wave - 1) * 2


func _on_timer_timeout() -> void:
	_spawn_enemy()
	_spawned_this_wave += 1
	if _spawned_this_wave >= _wave_enemy_count():
		_timer.stop()


func _spawn_enemy() -> void:
	var enemy: Node2D = ENEMY_SCENE.instantiate()
	enemy.word = WordBank.get_word(_difficulty())
	enemy.position = _random_edge()
	enemy.add_to_group("enemies")
	enemy.reached_center.connect(func(): enemy_reached_center.emit())
	enemy.died.connect(_on_enemy_died)
	get_parent().get_node("Enemies").add_child(enemy)
	_alive += 1


func _on_enemy_died() -> void:
	_alive -= 1
	_maybe_next_wave.call_deferred()


func _maybe_next_wave() -> void:
	if _timer.is_stopped() and _alive <= 0:
		await get_tree().create_timer(1.5).timeout
		_start_wave()


func _difficulty() -> int:
	if current_wave <= 2: return 0
	if current_wave <= 5: return 1
	return 2


func _random_edge() -> Vector2:
	match randi() % 4:
		0: return Vector2(randf_range(0.0, ARENA_SIZE.x), 0.0)
		1: return Vector2(randf_range(0.0, ARENA_SIZE.x), ARENA_SIZE.y)
		2: return Vector2(0.0, randf_range(0.0, ARENA_SIZE.y))
		3: return Vector2(ARENA_SIZE.x, randf_range(0.0, ARENA_SIZE.y))
	return Vector2.ZERO
