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

@export var spawn_configs: Array[AnomalySpawnConfig] = []

var video_timestamps = []
var spawn_configs_queue: Array[AnomalySpawnConfig] = []

var video_length: float = 100
var video_speed = 5

signal cleared_anomaly(timing: Timing)
signal pressed_wrong_color

func initialize() -> void:
	video_progress_bar.value = 0
	video_timestamps = []
	spawn_configs_queue = spawn_configs.duplicate()
	var count = spawn_configs.size()
	var video_step = video_length / (count + 1)
	for i in range(count):
		video_timestamps.append((i + 1) * video_step)
	destroyed.visible = false

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
