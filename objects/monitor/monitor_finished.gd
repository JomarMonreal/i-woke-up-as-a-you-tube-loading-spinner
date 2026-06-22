extends MonitorState

signal video_finished

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	var monitor := entity as Monitor
	monitor.video.stop()
	monitor.video_overlay.visible = false
	monitor.loading.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	video_finished.emit()
	return MonitorState.State.Finished
