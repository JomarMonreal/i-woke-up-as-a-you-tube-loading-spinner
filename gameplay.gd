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

@onready var states: GameplayStateManager = $StateManager
@onready var main_ui: MainUI = $MainUI
@onready var monitor: Monitor = $Desktop/Monitor
@onready var camera: Camera2D = get_tree().get_first_node_in_group("camera")
@onready var watching_girl: AnimatedSprite2D = $WatchingGirl
@onready var monitor_destruction_delay_timer: Timer = $MonitorDesctructionDelayTimer
@onready var destruciton_transition_delay: Timer = $DestructionTransitionDelay


@export var max_patience_level = 1
var patience_level = 1

var _previous_monitor_state: BaseState = null

signal video_finished
signal monitor_destroyed

func reset() -> void:
	monitor_destruction_delay_timer.stop()
	destruciton_transition_delay.stop()
	main_ui.punch.play("default")
	patience_level = max_patience_level
	main_ui.modulate_base(1 - patience_level)
	for anomaly in monitor.loading.anomalies_dictionary.values():
		if is_instance_valid(anomaly):
			anomaly.queue_free()
	
	monitor.reset()
	_previous_monitor_state = null

func _ready() -> void:
	states.init(self)
	
func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)


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
	monitor_destroyed.emit()
	destruciton_transition_delay.stop()
