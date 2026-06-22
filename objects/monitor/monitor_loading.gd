extends MonitorState

@export var speed_up: float = 20

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	var monitor := entity as Monitor
	monitor.video.pause()
	monitor.video_overlay.visible = true
	monitor.loading.visible = true
	monitor.loading.spwan_anomaly_at_border()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	var monitor := entity as Monitor	
	if monitor.loading.anomalies_dictionary.size() == 0:
		monitor.video_timestamps.pop_front()
		monitor.loading.increase_speed(20)
		return MonitorState.State.Playing
	
	return MonitorState.State.Loading
