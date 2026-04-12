extends Node

signal enemy_destroyed(enemy_pos: Vector2)
signal progress_updated(word: String, progress: int)

var _target: Node2D = null
var _progress: int = 0


func _process(_delta: float) -> void:
	if _target != null and not is_instance_valid(_target):
		_target = null
		_progress = 0
		progress_updated.emit("", 0)


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed:
		return
	var key_event := event as InputEventKey
	var unicode: int = key_event.unicode
	if unicode >= 65 and unicode <= 90:
		unicode += 32
	if unicode < 97 or unicode > 122:
		return
	_handle_char(char(unicode))


func _handle_char(ch: String) -> void:
	if _target == null:
		_find_target(ch)
	else:
		_advance(ch)


func _find_target(ch: String) -> void:
	var enemies_node := get_parent().get_node("Enemies")
	for enemy in enemies_node.get_children():
		if enemy.word.begins_with(ch):
			_target = enemy
			_progress = 1
			enemy.update_display(_progress)
			progress_updated.emit(enemy.word, _progress)
			return


func _advance(ch: String) -> void:
	var word: String = _target.word
	if ch == word[_progress]:
		_progress += 1
		_target.update_display(_progress)
		progress_updated.emit(word, _progress)
		if _progress >= word.length():
			_destroy_target()
	else:
		_target.update_display(0)
		_target = null
		_progress = 0
		progress_updated.emit("", 0)


func get_target() -> Node2D:
	return _target


func _destroy_target() -> void:
	var enemy := _target
	var enemy_pos := enemy.global_position
	_target = null
	_progress = 0
	progress_updated.emit("", 0)
	enemy_destroyed.emit(enemy_pos)
	enemy.die()
