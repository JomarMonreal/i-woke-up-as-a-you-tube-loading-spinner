extends MonitorState

var target_timestamp = 0

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	var monitor := entity as Monitor
	monitor.video.play()
	monitor.video_overlay.visible = false
	monitor.loading.visible = false
	monitor.loading.set_process(false)
	if len(monitor.video_timestamps) > 0:
		target_timestamp = monitor.video_timestamps[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	var monitor := entity as Monitor
	monitor.video_progress_bar.value += monitor.video_speed * delta
	if monitor.video_progress_bar.value > target_timestamp and len(monitor.video_timestamps) > 0:
		return MonitorState.State.Loading
	if monitor.video_progress_bar.value >= monitor.video_length:
		if monitor.is_endless:
			monitor.endless_iteration += 1
			monitor.reset()
			if len(monitor.video_timestamps) > 0:
				target_timestamp = monitor.video_timestamps[0]
			return MonitorState.State.Playing
		else:
			return MonitorState.State.Finished
	return MonitorState.State.Playing
