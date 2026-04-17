extends Node

const SAVE_PATH := "user://config.json"

var mode: String = "survival"              # "survival" | "practice"
var practice_submode: String = "timed"     # "timed" | "word_count" | "quotes"
var timed_duration: int = 60               # 15 | 30 | 60 | 120
var word_count_target: int = 50            # 25 | 50 | 100

var word_bank: String = "common"           # "common" | "expanded" | "technical" | "quotes"

var use_capitalization: bool = false
var sentence_mode: bool = false   # survival modifier: waves include sentence clusters

var difficulty_preset: String = "normal"   # "easy" | "normal" | "hard"


func _ready() -> void:
	_load()


func apply_preset(preset: String) -> void:
	difficulty_preset = preset
	match preset:
		"easy":
			word_bank = "easy"        # short 2-4 letter words only
			use_capitalization = false
		"normal":
			word_bank = "common"
			use_capitalization = false
		"hard":
			word_bank = "expanded"
			use_capitalization = true
	save()


func save() -> void:
	var data := {
		"mode": mode,
		"practice_submode": practice_submode,
		"timed_duration": timed_duration,
		"word_count_target": word_count_target,
		"word_bank": word_bank,
		"use_capitalization": use_capitalization,
		"sentence_mode": sentence_mode,
		"difficulty_preset": difficulty_preset,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(data))


func _load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var result: Variant = JSON.parse_string(file.get_as_text())
	if not result is Dictionary:
		return
	var d := result as Dictionary
	if d.has("mode"):               mode = d["mode"]
	if d.has("practice_submode"):   practice_submode = d["practice_submode"]
	if d.has("timed_duration"):     timed_duration = int(d["timed_duration"])
	if d.has("word_count_target"):  word_count_target = int(d["word_count_target"])
	if d.has("word_bank"):          word_bank = d["word_bank"]
	if d.has("use_capitalization"): use_capitalization = bool(d["use_capitalization"])
	if d.has("sentence_mode"):      sentence_mode = bool(d["sentence_mode"])
	if d.has("difficulty_preset"):  difficulty_preset = d["difficulty_preset"]
