extends GameplayState

@export var default_zoom := Vector2(-5, -5)
@export var default_camera_position := Vector2(500,100)
@export var loading_zoom := Vector2(0.5, 0.5)
@export var loading_camera_position := Vector2(300.0, -100.0)
@export var playing_zoom := Vector2(0.3, 0.3)
@export var playing_camera_position := Vector2(0.0, 0.0)
@export var zoom_duration := 0.5

@export var default_girl_position := Vector2(304.889, 171.5)
@export var loading_girl_position := Vector2(804.889, 171.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	var gameplay := entity as Gameplay
	var monitor = gameplay.monitor
	var current = monitor.states.current_state
	var camera = gameplay.camera
	var watching_girl = gameplay.watching_girl
	
	if 	monitor.video_progress_bar.value >= 100:
		return GameplayState.State.Success
	
	
	if current == gameplay._previous_monitor_state:
		return GameplayState.State.Playing
	gameplay._previous_monitor_state = current

	if not camera:
		return GameplayState.State.Playing

	if current == monitor.states.states[MonitorState.State.Loading]:
		camera.zoom_to(loading_zoom, loading_camera_position, zoom_duration)
		watching_girl.pause()
		create_tween().tween_property(watching_girl, "position", loading_girl_position, zoom_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	elif current == monitor.states.states[MonitorState.State.Playing]:
		camera.zoom_to(playing_zoom, playing_camera_position, zoom_duration)
		watching_girl.play()
		create_tween().tween_property(watching_girl, "position", default_girl_position, zoom_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	elif current == monitor.states.states[MonitorState.State.Finished]:
		camera.zoom_to(playing_zoom, playing_camera_position, zoom_duration)
		watching_girl.pause()
		gameplay.video_finished.emit()
	elif current == monitor.states.states[MonitorState.State.Destroyed]:
		camera.zoom_to(default_zoom, default_camera_position, zoom_duration)
		
	return GameplayState.State.Playing
