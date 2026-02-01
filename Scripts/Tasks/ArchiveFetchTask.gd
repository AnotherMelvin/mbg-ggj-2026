class_name ArchiveFetchTask
extends BaseTask

func on_interact() -> void:
	GlobalSignal.on_archive_fetch_start.emit()

func on_finish() -> void:
	GlobalSignal.on_archive_fetch_end.emit()
