extends CanvasLayer

signal resume_requested
signal settings_requested
signal main_menu_requested


func _ready() -> void:
	visible = false


func show_pause() -> void:
	visible = true
	get_tree().paused = true


func hide_pause() -> void:
	visible = false
	get_tree().paused = false
	# Release button focus so key events reach the typing engine's _unhandled_input
	var focused := get_viewport().gui_get_focus_owner()
	if focused != null:
		focused.release_focus()


func _on_resume_pressed() -> void:
	hide_pause()
	resume_requested.emit()


func _on_settings_pressed() -> void:
	settings_requested.emit()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	main_menu_requested.emit()
