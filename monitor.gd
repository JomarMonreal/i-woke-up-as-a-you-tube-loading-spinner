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

@export var video_loading_timestamps_count = 5
var video_timestamps = []


var video_length: float = 100
var video_speed = 5

signal cleared_anomaly(timing: Timing)
signal pressed_wrong_color

func _ready() -> void:
	video_progress_bar.value = 0
	
	# assign timestamps for loading
	var video_step = video_length / (video_loading_timestamps_count + 1)
	for i in range(0, video_loading_timestamps_count):
		video_timestamps.append((i+1) * video_step)
		
	states.init(self)
	
func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)


func _on_loading_spinner_cleared_anomaly(timing: LoadingSpinner.Timing) -> void:
	cleared_anomaly.emit(timing)
