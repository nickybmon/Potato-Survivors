extends Node2D

const SPEED := 150.0

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
	var target_pos := _get_player_pos()
	var direction := (target_pos - global_position).normalized()
	position += direction * SPEED * delta
	$Visual.flip_h = direction.x < 0.0
	if global_position.distance_to(target_pos) < 16.0:
		reached_center.emit()
		die()


func _get_player_pos() -> Vector2:
	var player := get_tree().get_first_node_in_group("player")
	if player != null:
		return (player as Node2D).global_position
	return Vector2(640.0, 360.0)


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
	$DeathSound.play()
	await get_tree().create_timer(0.35).timeout
	queue_free()
