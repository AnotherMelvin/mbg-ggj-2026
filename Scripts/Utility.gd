extends Node

enum SOUND_EFFECT_TYPE {
	BASE
}

enum SCENE_NAME_TYPE
{
	DEBUG,
	MAIN
}

enum SCENE_TRANSITION_TYPE
{
	FADE
}

const SCENE_TRANSITION_FADE = "Fade"

const DEBUG_SCENE_PATH = "res://Scenes/Debug.tscn"
const MAIN_SCENE_PATH = "res://Scenes/Main.tscn"

var rng = RandomNumberGenerator.new()
func get_rng(min_value: float, max_value: float) -> float:
	return rng.randf_range(min_value, max_value)
