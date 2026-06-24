extends MonitorState

signal video_destroyed

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	var monitor := entity as Monitor
	monitor.video.stop()
	monitor.video_overlay.visible = false
	monitor.loading.visible = false
	monitor.video.visible = false
	monitor.screen.visible = false
	monitor.destroyed.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	video_destroyed.emit()
	return MonitorState.State.Destroyed
