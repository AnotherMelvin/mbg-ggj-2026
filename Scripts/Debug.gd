extends Node3D

@onready var game_title: RichTextLabel = $CanvasLayer/GameTitle
@onready var amount: RichTextLabel = $CanvasLayer/Amount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RemoteConfig.config_updated.connect(_on_config_updated)
	#SceneManager.transition_to(Utility.SCENE_NAME_TYPE.MAIN, Utility.SCENE_TRANSITION_TYPE.FADE)
	AudioManager.create_audio(Utility.SOUND_EFFECT_TYPE.BASE)

func _on_config_updated() -> void:
	game_title.text = RemoteConfig.get_value("title")
	amount.text = str(RemoteConfig.get_value("amount"))
	

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
