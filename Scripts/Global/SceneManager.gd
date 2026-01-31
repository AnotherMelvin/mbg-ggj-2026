extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var new_scene_path : String 

func _ready() -> void:
	_toggle_color_rect(false)

func change_to(scene_name: Utility.SCENE_NAME_TYPE) -> void:
	_load_scene_path(scene_name)
	_switch_scene()
	
	
func transition_to(scene_name: Utility.SCENE_NAME_TYPE, transition: Utility.SCENE_TRANSITION_TYPE) -> void:
	_toggle_color_rect(true)
	_load_scene_path(scene_name)
	
	match transition:
		Utility.SCENE_TRANSITION_TYPE.FADE:
			animation_player.play(Utility.SCENE_TRANSITION_FADE)


func _load_scene_path(scene_name: Utility.SCENE_NAME_TYPE) -> void:
	match scene_name:
		Utility.SCENE_NAME_TYPE.DEBUG:
			new_scene_path = Utility.DEBUG_SCENE_PATH
		Utility.SCENE_NAME_TYPE.MAIN:
			new_scene_path = Utility.MAIN_SCENE_PATH


func _switch_scene() -> void:
	get_tree().call_deferred("change_scene_to_file", new_scene_path)
	
	
func _toggle_color_rect(state: bool) -> void:
	color_rect.visible = state


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	_toggle_color_rect(false)
