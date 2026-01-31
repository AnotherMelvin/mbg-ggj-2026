extends Node

enum SOUND_EFFECT_TYPE {
	BASE
}

var rng = RandomNumberGenerator.new()
func get_rng(min_value: float, max_value: float) -> float:
	return rng.randf_range(min_value, max_value)
