extends CanvasLayer

@onready var overlay: ColorRect = $Overlay
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var new_scene_path : String 

func _ready() -> void:
	_toggle_canvas(false)

func change_to(scene_name: Utils.SCENE_NAME_TYPE) -> void:
	_load_scene_path(scene_name)
	_switch_scene()
	
	
func transition_to(scene_name: Utils.SCENE_NAME_TYPE, transition: Utils.SCENE_TRANSITION_TYPE) -> void:
	_toggle_canvas(true)
	_load_scene_path(scene_name)
	
	match transition:
		Utils.SCENE_TRANSITION_TYPE.FADE:
			animation_player.play(Utils.SCENE_TRANSITION_FADE)


func _load_scene_path(scene_name: Utils.SCENE_NAME_TYPE) -> void:
	match scene_name:
		Utils.SCENE_NAME_TYPE.DEBUG:
			new_scene_path = Utils.DEBUG_SCENE_PATH
		Utils.SCENE_NAME_TYPE.MAIN:
			new_scene_path = Utils.MAIN_SCENE_PATH


func _switch_scene() -> void:
	get_tree().call_deferred("change_scene_to_file", new_scene_path)
	
	
func _toggle_canvas(state: bool) -> void:
	if (state):
		overlay.mouse_filter = Control.MOUSE_FILTER_STOP
		show()
		layer = 999
	else:
		overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hide()
		layer = -1


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	_toggle_canvas(false)
