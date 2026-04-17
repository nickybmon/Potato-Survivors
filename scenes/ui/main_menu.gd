extends Control


func _ready() -> void:
	get_tree().paused = false


func _on_play_pressed() -> void:
	GameConfig.mode = "survival"
	GameConfig.save()
	get_tree().change_scene_to_file("res://scenes/arena/arena.tscn")


func _on_practice_pressed() -> void:
	GameConfig.mode = "practice"
	GameConfig.save()
	get_tree().change_scene_to_file("res://scenes/modes/practice.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/settings.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
