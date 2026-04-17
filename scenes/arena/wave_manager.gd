extends Node

signal wave_started(wave: int)
signal enemy_reached_center
signal boss_incoming(wave: int)
signal boss_killed(bonus: int)

const ARENA_SIZE := Vector2(1280.0, 720.0)
const ENEMY_SCENE := preload("res://scenes/entities/enemy.tscn")
const BOSS_SCENE := preload("res://scenes/entities/boss_enemy.tscn")
const BASE_INTERVAL := 1.2   # seconds between spawns at normal difficulty
const BASE_COUNT := 8         # enemies per wave at normal difficulty

var current_wave: int = 0
var _spawned_this_wave: int = 0
var _sentence_groups_this_wave: int = 0
var _boss_pending: bool = false
var _sentence_group_active: bool = false
var _wave_clearing: bool = false   # true while waiting between waves to avoid re-entry

@onready var _timer: Timer = $SpawnTimer


func _ready() -> void:
	_timer.connect("timeout", _on_timer_timeout)
	_start_wave()


func _start_wave() -> void:
	current_wave += 1
	_spawned_this_wave = 0
	_sentence_groups_this_wave = 0
	_boss_pending = false
	_sentence_group_active = false
	_wave_clearing = false
	StatsTracker.resume_timer()
	var interval_base := _difficulty_interval()
	_timer.wait_time = max(0.5, interval_base - (current_wave - 1) * 0.04)
	_timer.one_shot = false
	_timer.start()
	wave_started.emit(current_wave)


func _difficulty_interval() -> float:
	match GameConfig.difficulty_preset:
		"easy":   return 2.2
		"hard":   return 0.9
		_:        return BASE_INTERVAL


func _wave_enemy_count() -> int:
	var base := BASE_COUNT
	match GameConfig.difficulty_preset:
		"easy": base = 4
		"hard": base = 10
	return base + (current_wave - 1) * 2


func _is_boss_wave() -> bool:
	return current_wave % 5 == 0   # every 5th wave, starting at wave 5


func _sentence_groups_target() -> int:
	if GameConfig.sentence_mode:
		return maxi(1, current_wave / 5)
	if current_wave >= 16:
		return 2
	if current_wave >= 11:
		return 1
	return 0


# Max words in a sentence group phrase — starts at 5, grows by 1 every 3 waves, caps at 12
func _sentence_max_words() -> int:
	return mini(5 + (current_wave - 1) / 3, 12)


func _on_timer_timeout() -> void:
	var wave_count := _wave_enemy_count()
	var need_sentences := _sentence_groups_this_wave < _sentence_groups_target()
	var sentence_wave_threshold := 1 if GameConfig.sentence_mode else 11

	# While a sentence group is active, pause regular spawning so the player
	# isn't overwhelmed trying to type a phrase while new enemies flood in.
	if _sentence_group_active:
		return

	# Kick off a sentence group when needed; only one at a time
	if need_sentences and current_wave >= sentence_wave_threshold:
		_spawn_sentence_group()
		_sentence_groups_this_wave += 1
	elif current_wave >= 6 and randi() % 5 == 0:
		_spawn_phrase_enemy()
		_spawned_this_wave += 1
	else:
		_spawn_enemy()
		_spawned_this_wave += 1

	if _spawned_this_wave >= wave_count and _sentence_groups_this_wave >= _sentence_groups_target():
		_timer.stop()
		_check_wave_clear.call_deferred()


func _active_first_letters() -> Array[String]:
	var letters: Array[String] = []
	for e: Node in _get_enemies_container().get_children():
		if not is_instance_valid(e):
			continue
		if not e.has_method("update_display"):
			continue
		var w: String = e.get("word")
		if not w.is_empty():
			letters.append(w[0].to_lower())
	return letters


func _spawn_enemy() -> void:
	var enemy: Node2D = ENEMY_SCENE.instantiate()
	enemy.word = WordBank.get_word_avoiding(_difficulty(), _active_first_letters())
	enemy.position = _random_edge()
	enemy.add_to_group("enemies")
	enemy.reached_center.connect(func(): enemy_reached_center.emit())
	enemy.died.connect(_check_wave_clear)
	_get_enemies_container().add_child(enemy)


func _spawn_phrase_enemy() -> void:
	var enemy: Node2D = ENEMY_SCENE.instantiate()
	enemy.word = WordBank.get_word_avoiding(1, _active_first_letters())
	enemy.position = _random_edge()
	enemy.add_to_group("enemies")
	enemy.reached_center.connect(func(): enemy_reached_center.emit())
	enemy.died.connect(_check_wave_clear)
	_get_enemies_container().add_child(enemy)


func _spawn_sentence_group() -> void:
	var SentenceGroupScript := load("res://scenes/arena/sentence_group.gd") as GDScript
	var group_node: Node2D = Node2D.new()
	group_node.set_script(SentenceGroupScript)
	var sentence: String = WordBank.get_quote_capped(_sentence_max_words())
	var origin: Vector2 = _random_edge()
	group_node.setup(sentence, origin)
	get_parent().add_child(group_node)
	_sentence_group_active = true

	group_node.all_died.connect(_on_sentence_group_cleared)

	var typing_engine := get_parent().get_node("TypingEngine")
	typing_engine.start_sentence(sentence, group_node)

	var hud := get_parent().get_node("HUD")
	if hud.has_method("start_sentence_bar"):
		hud.start_sentence_bar(sentence)

	typing_engine.sentence_completed.connect(
		func(_grp: Node2D):
			group_node.kill_all()
			if hud.has_method("clear_sentence_bar"):
				hud.clear_sentence_bar()
	, CONNECT_ONE_SHOT)

	await get_tree().process_frame
	if not is_inside_tree():
		return
	group_node.start_spawning(_get_enemies_container())


# Boss encounter index: 1 for wave 5, 2 for wave 10, etc.
func _boss_encounter_number() -> int:
	return current_wave / 5


func _boss_word_count() -> int:
	# 15 words for first boss, +5 per subsequent boss
	return 15 + (_boss_encounter_number() - 1) * 5


func _spawn_boss() -> void:
	var boss: Node2D = BOSS_SCENE.instantiate()
	boss.word_count = _boss_word_count()
	boss.position = _random_edge()
	boss.add_to_group("enemies")
	boss.add_to_group("boss")
	boss.reached_center.connect(func(): enemy_reached_center.emit())
	boss.died.connect(_on_boss_died)
	# Add to scene first so _ready() runs and builds the phrase
	get_parent().add_child(boss)

	# Wire through sentence mode so the typing engine handles word-by-word progression
	var phrase: String = boss.get_phrase()
	var typing_engine := get_parent().get_node("TypingEngine")
	typing_engine.start_sentence(phrase, boss)

	var hud := get_parent().get_node("HUD")
	if hud.has_method("start_sentence_bar"):
		hud.start_sentence_bar(phrase)

	# When all words typed, kill the boss and clear the bar
	typing_engine.sentence_completed.connect(
		func(_grp: Node2D):
			if is_instance_valid(boss):
				boss.die()
			if hud.has_method("clear_sentence_bar"):
				hud.clear_sentence_bar()
	, CONNECT_ONE_SHOT)

	# Let boss track word advances to update its label
	boss.connect_typing_engine(typing_engine)


func _on_sentence_group_cleared() -> void:
	_sentence_group_active = false
	_check_wave_clear()


func _on_boss_died() -> void:
	boss_killed.emit(500)
	_wave_clearing = true
	StatsTracker.pause_timer()
	await get_tree().create_timer(1.5).timeout
	if not is_inside_tree():
		return
	_start_wave()


# Called whenever any enemy dies — checks scene tree directly so stale signals
# from freed enemies can't corrupt a counter.
func _check_wave_clear() -> void:
	if _wave_clearing:
		return
	if _boss_pending:
		return
	# Still spawning or sentence group still active — not done yet
	if not _timer.is_stopped():
		return
	if _sentence_group_active:
		return
	# Count live enemies in the container
	var container := _get_enemies_container()
	for child in container.get_children():
		if is_instance_valid(child) and not child.get("_dead"):
			return   # still alive
	# All clear
	_wave_clearing = true
	StatsTracker.pause_timer()
	if _is_boss_wave():
		_boss_pending = true
		_wave_clearing = false
		await get_tree().create_timer(0.8).timeout
		if not is_inside_tree():
			return
		boss_incoming.emit(current_wave)
		await get_tree().create_timer(1.2).timeout
		if not is_inside_tree():
			return
		_spawn_boss()
	else:
		await get_tree().create_timer(0.5).timeout
		if not is_inside_tree():
			return
		_start_wave()


func _difficulty() -> int:
	if GameConfig.difficulty_preset == "easy":
		# Easy stays on easy words longer
		if current_wave <= 8:  return 0
		if current_wave <= 15: return 1
		return 2
	# Normal / hard
	if current_wave <= 5:  return 0
	if current_wave <= 10: return 1
	return 2



func _get_enemies_container() -> Node:
	return get_parent().get_node("Enemies")


func _random_edge() -> Vector2:
	match randi() % 4:
		0: return Vector2(randf_range(0.0, ARENA_SIZE.x), 0.0)
		1: return Vector2(randf_range(0.0, ARENA_SIZE.x), ARENA_SIZE.y)
		2: return Vector2(0.0, randf_range(0.0, ARENA_SIZE.y))
		3: return Vector2(ARENA_SIZE.x, randf_range(0.0, ARENA_SIZE.y))
	return Vector2.ZERO
