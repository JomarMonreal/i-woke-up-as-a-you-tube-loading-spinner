extends Node2D
class_name  Gameplay

enum AnomalyColor {
	Null,
	Red,
	Blue,
	Green
}

enum Timing {
	Early,
	Good,
	Perfect,
	Late
}

@onready var main_ui: MainUI = $MainUI
@onready var monitor: Monitor = $Monitor
@onready var camera: Camera2D = get_tree().get_first_node_in_group("camera")
@onready var watching_girl: AnimatedSprite2D = $WatchingGirl
@onready var monitor_destruction_delay_timer: Timer = $MonitorDesctructionDelayTimer
@onready var destruciton_transition_delay: Timer = $DestructionTransitionDelay

@export var default_zoom := Vector2(-5, -5)
@export var default_camera_position := Vector2(500,100)
@export var loading_zoom := Vector2(0.5, 0.5)
@export var loading_camera_position := Vector2(300.0, -100.0)
@export var playing_zoom := Vector2(0.3, 0.3)
@export var playing_camera_position := Vector2(0.0, 0.0)
@export var zoom_duration := 0.5

@export var default_girl_position := Vector2(304.889, 171.5)
@export var loading_girl_position := Vector2(804.889, 171.5)


@export var max_patience_level = 1
var patience_level = 1

var _previous_monitor_state: BaseState = null

signal video_finished
signal monitor_destroyed

func _ready() -> void:
	pass

func reset() -> void:
	monitor_destruction_delay_timer.stop()
	destruciton_transition_delay.stop()
	main_ui.punch.play("default")
	patience_level = max_patience_level
	main_ui.modulate_base(1 - patience_level)
	for anomaly in monitor.loading.anomalies_dictionary.values():
		if is_instance_valid(anomaly):
			anomaly.queue_free()
	monitor.loading.anomalies_dictionary.clear()
	monitor.video.frame = 0
	monitor.video.play()
	monitor.video.visible = true
	monitor.video_progress_bar.value = 0
	monitor.screen.visible = true
	monitor.destroyed.visible = false
	monitor.initialize()
	monitor.loading.rotation_speed = monitor.loading.base_rotation_speed
	_previous_monitor_state = null
	monitor.states.change_state(MonitorState.State.Playing)

func _process(_delta: float) -> void:
	var current = monitor.states.current_state
	if current == _previous_monitor_state:
		return
	_previous_monitor_state = current

	if not camera:
		return

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
		video_finished.emit()
	elif current == monitor.states.states[MonitorState.State.Destroyed]:
		camera.zoom_to(default_zoom, default_camera_position, zoom_duration)

func _on_monitor_pressed_wrong_color() -> void:
	main_ui.flash_red()
	camera.shake(0.4, 20.0)
	patience_level -= 0.2
	if patience_level < 0:
		patience_level = 0
	main_ui.modulate_base(1 - patience_level)
	if patience_level <= 0:
		monitor_destruction_delay_timer.start()
		main_ui.punch.play("punch")


func _on_monitor_desctruction_delay_timer_timeout() -> void:
	monitor.states.change_state(MonitorState.State.Destroyed)
	main_ui.punch.current_animation = "default"
	main_ui.punch.play("default")
	monitor_destruction_delay_timer.stop()
	destruciton_transition_delay.start()


func _on_destruction_transition_delay_timeout() -> void:
	main_ui.punch.play("default")
	main_ui.punch.advance(0.0)
	if camera:
		camera.zoom_to(default_zoom, default_camera_position, zoom_duration)
	monitor_destroyed.emit()
	destruciton_transition_delay.stop()
