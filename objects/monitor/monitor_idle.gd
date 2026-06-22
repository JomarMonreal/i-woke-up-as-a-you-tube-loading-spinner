extends MonitorState

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	var monitor := entity as Monitor
	monitor.video.stop()
	monitor.video_overlay.visible = false
	monitor.loading.visible = false
	monitor.video_progress_bar.value = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	return MonitorState.State.Idle
