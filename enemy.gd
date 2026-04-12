extends Node2D

const SPEED := 80.0
const CENTER := Vector2(640.0, 360.0)

signal reached_center
signal died

var word: String = ""
var _dead: bool = false


func _ready() -> void:
	$WordLabel.text = word
	$Visual.play("walk")


func _process(delta: float) -> void:
	if _dead:
		return
	var direction := (CENTER - global_position).normalized()
	position += direction * SPEED * delta
	$Visual.flip_h = direction.x < 0.0
	if global_position.distance_to(CENTER) < 8.0:
		reached_center.emit()
		die()


func update_display(progress: int) -> void:
	if progress == 0:
		$WordLabel.text = word
	else:
		$WordLabel.text = word.substr(progress)


func die() -> void:
	if _dead:
		return
	_dead = true
	died.emit()
	$Visual.play("dead")
	$WordLabel.visible = false
	await get_tree().create_timer(0.35).timeout
	queue_free()
