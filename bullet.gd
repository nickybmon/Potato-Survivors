extends Node2D

const SPEED := 700.0

var _direction: Vector2 = Vector2.ZERO
var _from: Vector2 = Vector2.ZERO
var _target_pos: Vector2 = Vector2.ZERO


func setup(from: Vector2, to: Vector2) -> void:
	_from = from
	_target_pos = to
	_direction = (to - from).normalized()


func _ready() -> void:
	global_position = _from
	rotation = _direction.angle()
	$Sound.play()


func _process(delta: float) -> void:
	position += _direction * SPEED * delta
	if global_position.distance_to(_target_pos) < 12.0:
		queue_free()
