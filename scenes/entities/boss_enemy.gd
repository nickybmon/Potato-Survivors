extends Node2D

const SPEED := 55.0
const SCORE_BONUS := 500

signal reached_center
signal died

# Set by wave_manager before add_child
var word_count: int = 15

# Current displayed word — typing engine reads this
var word: String = ""
var _phrase_words: Array[String] = []
var _current_word_idx: int = 0
var _dead: bool = false


func _ready() -> void:
	$Visual.play("walk")
	_build_phrase()
	_show_word()


func _build_phrase() -> void:
	_phrase_words.clear()
	for _i: int in word_count:
		_phrase_words.append(WordBank.get_word(1))
	_current_word_idx = 0


# Called by wave_manager after the typing engine is wired up.
# Advances the displayed word whenever the engine completes a word on this boss.
func connect_typing_engine(typing_engine: Node) -> void:
	typing_engine.word_completed.connect(_on_word_completed_on_boss)


func get_phrase() -> String:
	return " ".join(_phrase_words)


func _process(delta: float) -> void:
	if _dead:
		return
	var target_pos := _get_player_pos()
	var direction := (target_pos - global_position).normalized()
	position += direction * SPEED * delta
	$Visual.flip_h = direction.x < 0.0
	if global_position.distance_to(target_pos) < 24.0:
		reached_center.emit()
		die()


func _get_player_pos() -> Vector2:
	var player := get_tree().get_first_node_in_group("player")
	if player != null:
		return (player as Node2D).global_position
	return Vector2(640.0, 360.0)


func _show_word() -> void:
	if _current_word_idx < _phrase_words.size():
		word = _phrase_words[_current_word_idx]
	$WordLabel.text = word


func _on_word_completed_on_boss(target: Node2D) -> void:
	if target != self:
		return
	_current_word_idx += 1
	_show_word()


# Called by typing engine sentence mode to get the "enemy" for bullet targeting.
# The boss itself is the target for every word.
func get_enemy(_idx: int) -> Node2D:
	return self


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
	if not is_inside_tree():
		queue_free()
		return
	$Visual.play("dead")
	$WordLabel.visible = false
	$DeathSound.play()
	_flash_screen()
	await get_tree().create_timer(0.5).timeout
	if is_inside_tree():
		queue_free()


func _flash_screen() -> void:
	var flash := ColorRect.new()
	flash.color = Color(1, 1, 1, 0.7)
	flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	flash.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child(flash)
	var tween := get_tree().create_tween()
	tween.tween_property(flash, "modulate:a", 0.0, 0.2)
	tween.tween_callback(flash.queue_free)
