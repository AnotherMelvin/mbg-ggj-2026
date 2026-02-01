class_name ArchiveSaveTask
extends BaseTask

func on_interact() -> void:
	GlobalSignal.on_archive_save_start.emit()

func on_finish() -> void:
	GlobalAccess.progression.add_official_meter()
	GlobalSignal.on_archive_save_end.emit()
