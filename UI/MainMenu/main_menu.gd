extends Control





func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("Level/MainLevel/main_level.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("UI/SettingsMenu/settings_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
