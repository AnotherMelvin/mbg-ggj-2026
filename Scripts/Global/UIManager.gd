extends Node

func turn_on(ui_type: Utils.UI_NAME_TYPE, is_using_animation: bool, text: String) -> void:
	GlobalSignal.turn_on_ui.emit(ui_type, is_using_animation)
	
func turn_off(ui_type: Utils.UI_NAME_TYPE, is_using_animation: bool) -> void:
	GlobalSignal.turn_off_ui.emit(ui_type, is_using_animation)
