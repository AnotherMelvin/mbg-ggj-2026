extends Control

@onready var has_close: RichTextLabel = $Panel/HasClose

func _ready() -> void:
	has_close.text = "hasClose = " + str(SaveManager.get_value().has_finished_ftue)


func _on_open_button_pressed() -> void:
	UIManager.turn_on(Utils.UI_NAME_TYPE.DEFAULT, false)
	has_close.text = "hasClose = " + str(SaveManager.get_value().has_finished_ftue)


func _on_close_button_pressed() -> void:
	UIManager.turn_off(Utils.UI_NAME_TYPE.DEFAULT, false)
	SaveManager.get_value().has_finished_ftue = true
	SaveManager.save_game()
