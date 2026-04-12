extends Node2D

const AVOID_RADIUS := 160.0
const SPEED := 100.0
const ARENA_MIN := Vector2(80.0, 60.0)
const ARENA_MAX := Vector2(1200.0, 660.0)

@onready var _visual: AnimatedSprite2D = $Visual
@onready var _gun: Sprite2D = $Gun

var _wander_dir: Vector2 = Vector2.RIGHT
var _wander_timer: float = 0.0


func _process(delta: float) -> void:
	_wander_timer -= delta
	if _wander_timer <= 0.0:
		_wander_dir = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		_wander_timer = randf_range(1.0, 2.5)

	var avoidance := Vector2.ZERO
	for node in get_tree().get_nodes_in_group("enemies"):
		var enemy := node as Node2D
		if enemy == null:
			continue
		var diff: Vector2 = global_position - enemy.global_position
		var dist: float = diff.length()
		if dist < AVOID_RADIUS and dist > 0.0:
			avoidance += diff.normalized() * (1.0 - dist / AVOID_RADIUS)

	var move := Vector2.ZERO
	if avoidance.length() > 0.05:
		move = avoidance.normalized() * SPEED
	else:
		move = _wander_dir * SPEED * 0.35

	position += move * delta
	position.x = clampf(position.x, ARENA_MIN.x, ARENA_MAX.x)
	position.y = clampf(position.y, ARENA_MIN.y, ARENA_MAX.y)

	if move.length() > 8.0:
		_visual.play("run")
		_visual.flip_h = move.x < 0.0
	else:
		_visual.play("idle")

	_aim_gun()


func _aim_gun() -> void:
	var typing_engine := get_parent().get_node("TypingEngine")
	var aim_target: Node2D = typing_engine.get_target()
	var target_pos := Vector2.ZERO

	if aim_target != null and is_instance_valid(aim_target):
		target_pos = aim_target.global_position
	else:
		var nearest_dist := INF
		for node in get_tree().get_nodes_in_group("enemies"):
			var enemy := node as Node2D
			if enemy == null:
				continue
			var d: float = global_position.distance_to(enemy.global_position)
			if d < nearest_dist:
				nearest_dist = d
				target_pos = enemy.global_position

	if target_pos != Vector2.ZERO:
		var angle := (target_pos - global_position).angle()
		_gun.rotation = angle
		_gun.flip_v = absf(angle) > PI * 0.5
