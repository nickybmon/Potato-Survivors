extends Node2D

# Spawns sentence word-enemies spread clockwise around the arena edge,
# starting from bottom-left. Each enemy converges on the player independently.

const ENEMY_SCENE := preload("res://scenes/entities/enemy.tscn")
const ARENA_W := 1280.0
const ARENA_H := 720.0
# Total perimeter length used to place enemies; slightly inset so labels are visible
const EDGE_INSET := 8.0
const SPAWN_STAGGER := 0.45   # seconds between each word appearing
const SENTENCE_SPEED := 60.0  # slower than normal enemies (normal = 150)

signal all_died

var sentence: String = ""
var _words: Array[String] = []
var _enemies: Array[Node2D] = []
var _alive_count: int = 0


func setup(sent: String, _origin: Vector2) -> void:
	sentence = sent
	_words = []
	for w: String in sent.split(" "):
		if not w.is_empty():
			_words.append(w)


func start_spawning(enemies_container: Node) -> void:
	var positions := _clockwise_positions(_words.size())
	var timer := get_tree().create_timer(0.0)
	for i: int in _words.size():
		await timer.timeout
		_spawn_word(i, positions[i], enemies_container)
		timer = get_tree().create_timer(SPAWN_STAGGER)


# Returns n positions evenly spaced clockwise around the arena edge,
# starting at the bottom-left corner.
func _clockwise_positions(n: int) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	if n == 0:
		return positions

	# Perimeter segments (clockwise from bottom-left):
	#   bottom-left corner → bottom-right  (bottom edge, left→right)
	#   bottom-right corner → top-right    (right edge, bottom→top)
	#   top-right corner → top-left        (top edge, right→left)
	#   top-left corner → bottom-left      (left edge, top→bottom)
	var i_w := ARENA_W - EDGE_INSET * 2
	var i_h := ARENA_H - EDGE_INSET * 2
	var perimeter := 2.0 * (i_w + i_h)
	var step := perimeter / float(n)

	for idx: int in n:
		var d := step * idx   # distance along perimeter from start point
		var pos := Vector2.ZERO
		if d < i_w:
			# Bottom edge: left → right
			pos = Vector2(EDGE_INSET + d, ARENA_H - EDGE_INSET)
		elif d < i_w + i_h:
			# Right edge: bottom → top
			pos = Vector2(ARENA_W - EDGE_INSET, ARENA_H - EDGE_INSET - (d - i_w))
		elif d < 2.0 * i_w + i_h:
			# Top edge: right → left
			pos = Vector2(ARENA_W - EDGE_INSET - (d - i_w - i_h), EDGE_INSET)
		else:
			# Left edge: top → bottom
			pos = Vector2(EDGE_INSET, EDGE_INSET + (d - 2.0 * i_w - i_h))
		positions.append(pos)

	return positions


func _spawn_word(idx: int, spawn_pos: Vector2, container: Node) -> void:
	var enemy: Node2D = ENEMY_SCENE.instantiate()
	enemy.word = _words[idx]
	enemy.speed_override = SENTENCE_SPEED
	enemy.position = spawn_pos
	enemy.add_to_group("enemies")
	enemy.add_to_group("sentence_enemy")
	enemy.set_meta("sentence_group", self)
	enemy.died.connect(_on_enemy_died)
	container.add_child(enemy)
	_enemies.append(enemy)
	_alive_count += 1


func get_enemy(idx: int) -> Node2D:
	if idx >= 0 and idx < _enemies.size():
		return _enemies[idx]
	return null


func kill_all() -> void:
	for e: Node2D in _enemies:
		if is_instance_valid(e) and not (e as Node).get("_dead"):
			e.die()


func get_sentence() -> String:
	return sentence


func _on_enemy_died() -> void:
	_alive_count -= 1
	if _alive_count <= 0:
		all_died.emit()
		queue_free()
