extends MonitorState

@export var speed_up: float = 20

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	var monitor := entity as Monitor
	monitor.video.pause()
	monitor.video_overlay.visible = true
	monitor.loading.visible = true
	monitor.loading.set_process(true)
	monitor.loading._accumulated_rotation = 0.0
	var config = monitor.spawn_configs_queue[0] if monitor.spawn_configs_queue.size() > 0 else null
	monitor.loading.spwan_anomaly_at_border(config)

func process(_delta: float) -> int:
	var monitor := entity as Monitor
	if monitor.loading.anomalies_dictionary.size() == 0:
		monitor.video_timestamps.pop_front()
		if monitor.spawn_configs_queue.size() > 0:
			monitor.spawn_configs_queue.pop_front()
		monitor.loading.increase_speed(2 if monitor.is_endless else 10)
		return MonitorState.State.Playing

	return MonitorState.State.Loading
