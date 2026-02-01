extends Node

signal turn_on_ui(ui_type: Utils.UI_NAME_TYPE, is_using_animation: bool)
signal turn_off_ui(ui_type: Utils.UI_NAME_TYPE, is_using_animation: bool)

signal update_timer(minute: int, second: int)
signal update_official_task_meter(currentValue: float, maxValue: float)
signal update_spy_task_meter(currentValue: float, maxValue: float)
signal update_suspicion_meter(currentValue: float, maxValue: float)

signal on_completed()
signal on_game_over()
