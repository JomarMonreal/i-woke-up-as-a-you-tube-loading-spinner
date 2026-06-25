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

signal cleared_anomaly(timing: Timing)
signal pressed_wrong_color
signal loading_completed_rotation

func initialize() -> void:
	video_progress_bar.value = 0
	video_timestamps = []
	var configs = spawn_config.spawn_configs if spawn_config else []
	spawn_configs_queue = configs.duplicate()
	var count = configs.size()
	var video_step = video_length / (count + 1)
	for i in range(count):
		video_timestamps.append((i + 1) * video_step)
	destroyed.visible = false


func reset() -> void:
	loading.anomalies_dictionary.clear()
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
