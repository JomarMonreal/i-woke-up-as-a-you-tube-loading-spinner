extends Node2D
class_name Monitor

enum Timing {
	Early,
	Good,
	Perfect,
	Late
}

@onready var states: MonitorStateManager = $StateManager
@onready var video_progress_bar: HSlider = $Screen/Control/ProgressBar
@onready var video_overlay: Sprite2D = $Screen/Overlay
@onready var video: AnimatedSprite2D = $Video
@onready var loading: LoadingSpinner = $LoadingSpinner
@onready var destroyed: Sprite2D = $Destroyed
@onready var screen: Sprite2D = $Screen

@export var spawn_config: MonitorSpawnConfig

var video_timestamps = []
var spawn_configs_queue: Array[AnomalySpawnConfig] = []

var video_length: float = 100
var video_speed = 5
var is_endless = true
var endless_iteration := 0

signal cleared_anomaly(timing: Timing)
signal pressed_wrong_color
signal loading_completed_rotation

func initialize() -> void:
	video_progress_bar.value = 0
	video_timestamps = []
	spawn_configs_queue.clear()
	if is_endless:
		var config = _generate_endless_config(endless_iteration)
		var stamp_count = randi_range(4, 6)
		var step = video_length / (stamp_count + 1)
		for i in range(stamp_count):
			video_timestamps.append((i + 1) * step)
			spawn_configs_queue.append(config)
	else:
		var configs = spawn_config.spawn_configs if spawn_config else []
		spawn_configs_queue.assign(configs)
		var count = configs.size()
		var video_step = video_length / (count + 1)
		for i in range(count):
			video_timestamps.append((i + 1) * video_step)
	destroyed.visible = false


func _generate_endless_config(iteration: int) -> AnomalySpawnConfig:
	var config = AnomalySpawnConfig.new()
	var max_count = mini(2 + iteration, int(360.0 / loading.steps))
	var min_count = mini(2, max_count)
	config.count = randi_range(min_count, max_count)
	config.anomaly_keys.append(AnomalySpawnConfig.AnomalyColor.Red)
	config.anomaly_keys.append(AnomalySpawnConfig.AnomalyColor.Green)
	config.anomaly_keys.append(AnomalySpawnConfig.AnomalyColor.Blue)
	
	return config


func reset() -> void:
	loading.clear_all_anomalies()
	video.frame = 0
	video.play()
	video.visible = true
	video_progress_bar.value = 0
	screen.visible = true
	destroyed.visible = false
	loading.rotation_speed = loading.base_rotation_speed
	initialize()
	states.change_state(MonitorState.State.Playing)

	
func _ready() -> void:
	initialize()
	states.init(self)
	
func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)


func _on_loading_spinner_cleared_anomaly(timing: LoadingSpinner.Timing) -> void:
	cleared_anomaly.emit(timing)


func _on_loading_spinner_pressed_wrong_color() -> void:
	pressed_wrong_color.emit()


func _on_loading_spinner_completed_rotation() -> void:
	loading_completed_rotation.emit()
