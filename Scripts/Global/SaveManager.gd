extends Node

var _save := ResourceSave.new()

func _ready() -> void:
	_create_or_load_save()

func _create_or_load_save() -> void:
	if ResourceSave.save_exists():
		_save = ResourceSave.load_savegame()
	else:
		_save = ResourceSave.new()
		_save.write_savegame()

func save_game() -> void:
	_save.write_savegame()

func get_value() -> ResourceSave:
	return _save
