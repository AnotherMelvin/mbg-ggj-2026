class_name ArchiveShredTask
extends BaseTask

func on_interact() -> void:
	GlobalSignal.on_archive_shred_start.emit()

func on_finish() -> void:
	GlobalAccess.progression.add_spy_meter()
	GlobalSignal.on_archive_shred_end.emit()
