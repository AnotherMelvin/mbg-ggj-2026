@abstract
class_name BaseUI extends Control


@export var _ui_type: Utils.UI_NAME_TYPE
var is_animation_playing: bool

func _ready() -> void:
	GlobalSignal.turn_on_ui.connect(_turn_on)
	GlobalSignal.turn_off_ui.connect(_turn_off)

@abstract
func on_turn_on() -> void
func _turn_on(type: Utils.UI_NAME_TYPE, is_using_animation: bool) -> void:
	if !visible && !is_animation_playing && type != _ui_type:
		return
		
	toggle_visibility(true)
	toggle_anim_flag(is_using_animation)
	on_turn_on()


@abstract
func on_turn_off() -> void
func _turn_off(type: Utils.UI_NAME_TYPE, is_using_animation: bool) -> void:
	if visible && !is_animation_playing && type != _ui_type:
		return
	
	toggle_visibility(is_using_animation)
	toggle_anim_flag(is_using_animation)
	on_turn_off()


func toggle_visibility(state: bool) -> void:
	visible = state
	
	
func toggle_anim_flag(state: bool) -> void:
	is_animation_playing = state
