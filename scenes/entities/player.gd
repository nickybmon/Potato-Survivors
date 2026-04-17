extends Node2D

const AVOID_RADIUS := 200.0
const SPEED := 120.0
const ARENA_MIN := Vector2(80.0, 60.0)
const ARENA_MAX := Vector2(1200.0, 660.0)
const CENTER := Vector2(640.0, 360.0)
const GUN_ORBIT_RADIUS := 20.0

@onready var _visual: AnimatedSprite2D = $Visual
@onready var _gun: Sprite2D = $Gun


func _ready() -> void:
	add_to_group("player")


func _process(delta: float) -> void:
	var flee := Vector2.ZERO
	for node in get_tree().get_nodes_in_group("enemies"):
		var enemy := node as Node2D
		if enemy == null:
			continue
		var diff: Vector2 = global_position - enemy.global_position
		var dist: float = diff.length()
		if dist < AVOID_RADIUS and dist > 0.0:
			flee += diff.normalized() * (1.0 - dist / AVOID_RADIUS)

	var move := Vector2.ZERO
	if flee.length() > 0.01:
		move = flee.normalized() * SPEED
	else:
		var to_center: Vector2 = CENTER - global_position
		if to_center.length() > 30.0:
			move = to_center.normalized() * SPEED * 0.25

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
		var angle: float = (target_pos - global_position).angle()
		_gun.position = Vector2(cos(angle), sin(angle)) * GUN_ORBIT_RADIUS
		_gun.rotation = angle
