extends Control

var _return_scene: String = "res://scenes/ui/main_menu.tscn"

@onready var _preset_easy: Button = $Panel/VBox/PresetRow/EasyBtn
@onready var _preset_normal: Button = $Panel/VBox/PresetRow/NormalBtn
@onready var _preset_hard: Button = $Panel/VBox/PresetRow/HardBtn
@onready var _bank_common: Button = $Panel/VBox/BankRow/CommonBtn
@onready var _bank_expanded: Button = $Panel/VBox/BankRow/ExpandedBtn
@onready var _bank_technical: Button = $Panel/VBox/BankRow/TechnicalBtn
@onready var _cap_check: CheckButton = $Panel/VBox/ModRow/CapCheck
@onready var _sentence_check: CheckButton = $Panel/VBox/ModRow/SentenceCheck


func _ready() -> void:
	_refresh_ui()


func set_return_scene(path: String) -> void:
	_return_scene = path


func _refresh_ui() -> void:
	_cap_check.button_pressed = GameConfig.use_capitalization
	_sentence_check.button_pressed = GameConfig.sentence_mode

	_preset_easy.button_pressed = GameConfig.difficulty_preset == "easy"
	_preset_normal.button_pressed = GameConfig.difficulty_preset == "normal"
	_preset_hard.button_pressed = GameConfig.difficulty_preset == "hard"

	_bank_common.button_pressed = GameConfig.word_bank == "common"
	_bank_expanded.button_pressed = GameConfig.word_bank == "expanded"
	_bank_technical.button_pressed = GameConfig.word_bank == "technical"


func _on_easy_pressed() -> void:
	GameConfig.apply_preset("easy")
	_refresh_ui()


func _on_normal_pressed() -> void:
	GameConfig.apply_preset("normal")
	_refresh_ui()


func _on_hard_pressed() -> void:
	GameConfig.apply_preset("hard")
	_refresh_ui()


func _on_common_pressed() -> void:
	GameConfig.word_bank = "common"
	GameConfig.save()
	_refresh_ui()


func _on_expanded_pressed() -> void:
	GameConfig.word_bank = "expanded"
	GameConfig.save()
	_refresh_ui()


func _on_technical_pressed() -> void:
	GameConfig.word_bank = "technical"
	GameConfig.save()
	_refresh_ui()


func _on_cap_toggled(toggled: bool) -> void:
	GameConfig.use_capitalization = toggled
	GameConfig.save()


func _on_sentence_toggled(toggled: bool) -> void:
	GameConfig.sentence_mode = toggled
	GameConfig.save()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(_return_scene)
