extends Node3D


func _on_open_button_pressed() -> void:
	UIManager.turn_on(Utils.UI_NAME_TYPE.DEFAULT, false)


func _on_close_button_pressed() -> void:
	UIManager.turn_off(Utils.UI_NAME_TYPE.DEFAULT, false)
