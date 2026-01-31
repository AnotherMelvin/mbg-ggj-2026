extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.create_audio(Utility.SOUND_EFFECT_TYPE.BASE)


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
