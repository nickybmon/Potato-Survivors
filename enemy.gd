extends Node2D

const SPEED := 80.0
const CENTER := Vector2(640.0, 360.0)
const COLOR_DEFAULT := Color(0.9, 0.2, 0.2, 1)
const COLOR_TARGETED := Color(1.0, 0.65, 0.0, 1)

signal reached_center
signal died

var word: String = ""
var _dead: bool = false


func _ready() -> void:
	$WordLabel.text = word


func _process(delta: float) -> void:
	var direction := (CENTER - global_position).normalized()
	position += direction * SPEED * delta
	if global_position.distance_to(CENTER) < 8.0:
		reached_center.emit()
		die()


func update_display(progress: int) -> void:
	if progress == 0:
		$Visual.color = COLOR_DEFAULT
		$WordLabel.text = word
	else:
		$Visual.color = COLOR_TARGETED
		$WordLabel.text = word.substr(progress)


func die() -> void:
	if _dead:
		return
	_dead = true
	died.emit()
	queue_free()
