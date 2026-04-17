extends Node

const SAVE_PATH := "user://scores.json"
const MAX_SCORES := 10

var _scores: Array = []


func _ready() -> void:
	_load()


func add_score(score: int) -> void:
	_scores.append(score)
	_scores.sort()
	_scores.reverse()
	if _scores.size() > MAX_SCORES:
		_scores.resize(MAX_SCORES)
	_save()


func get_scores() -> Array:
	return _scores.duplicate()


func get_high_score() -> int:
	if _scores.is_empty():
		return 0
	return _scores[0]


func _save() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(_scores))


func _load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var result: Variant = JSON.parse_string(file.get_as_text())
	if result is Array:
		_scores.clear()
		for v: Variant in result:
			var s := int(v)
			if s > 0:
				_scores.append(s)
		_save()  # Re-save immediately to purge any stored zeros
