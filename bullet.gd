extends Node2D

const SPEED := 700.0

var _from: Vector2 = Vector2.ZERO
var _target: Node2D = null
var _kill_on_hit: bool = true


func setup(from: Vector2, target: Node2D, kill_on_hit: bool = true) -> void:
	_from = from
	_target = target
	_kill_on_hit = kill_on_hit


func _ready() -> void:
	global_position = _from
	if is_instance_valid(_target):
		rotation = (_target.global_position - _from).angle()
	$Sound.play()


func _process(delta: float) -> void:
	if not is_instance_valid(_target):
		queue_free()
		return
	var dir: Vector2 = (_target.global_position - global_position).normalized()
	rotation = dir.angle()
	position += dir * SPEED * delta
	if global_position.distance_to(_target.global_position) < 12.0:
		if _kill_on_hit:
			_target.die()
		queue_free()
