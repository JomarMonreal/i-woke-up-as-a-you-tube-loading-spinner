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
@onready var camera: GameCamera = get_tree().get_first_node_in_group("camera")
@onready var watching_girl: AnimatedSprite2D = $WatchingGirl
@onready var monitor_destruction_delay_timer: Timer = $MonitorDesctructionDelayTimer
@onready var destruciton_transition_delay: Timer = $DestructionTransitionDelay
@onready var desktop: Node2D = $Desktop

@onready var music: AudioStreamPlayer2D = $GameplayMusic
@onready var error_sfx: AudioStreamPlayer2D = $ErrorSFX
@onready var monitor_destroyed_sfx: AudioStreamPlayer2D = $MonitorDestroyedSFX
@onready var game: GameManager = get_tree().get_first_node_in_group("game_manager")


@export var is_endless = true
@export var score_scene: PackedScene
var max_patience_level = 1
var patience_level = 1

@export var rotation_patience_penalty := 0.1
@export var perfect_patience_reward := 0.1

@export var playing_zoom := Vector2(0.3, 0.3)
@export var playing_camera_position := Vector2(0.0, 0.0)

var perfect_count := 0
var good_count := 0
var early_count := 0
var late_count := 0

var _previous_monitor_state: BaseState = null
var score_instance = null

signal monitor_destroyed

func reset() -> void:
	music.play(0)
	monitor_destruction_delay_timer.stop()
	destruciton_transition_delay.stop()
	main_ui.punch.play("default")
	patience_level = max_patience_level
	main_ui.modulate_base(1 - patience_level)
	monitor.endless_iteration = 0
	if not is_endless and game.current_timeline_index < 5:
		var timeline = game.story_timelines[game.current_timeline_index]
		monitor.spawn_config = game.story_mode_config.spawn_configs[timeline]
	monitor.reset()
	
	_previous_monitor_state = null
	perfect_count = 0
	good_count = 0
	early_count = 0
	late_count = 0
	states.change_state(GameplayState.State.Playing)

func _ready() -> void:
	states.init(self)
	
func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)


func _on_monitor_cleared_anomaly(timing: Monitor.Timing) -> void:
	match timing:
		Monitor.Timing.Perfect:
			perfect_count += 1
			patience_level = minf(patience_level + perfect_patience_reward, max_patience_level)
			main_ui.modulate_base(1 - patience_level)
		Monitor.Timing.Good:    good_count += 1
		Monitor.Timing.Early:   early_count += 1
		Monitor.Timing.Late:    late_count += 1

func _on_monitor_pressed_wrong_color() -> void:
	error_sfx.play()
	main_ui.flash_red()
	camera.shake(0.4, 20.0)
	patience_level -= 0.2
	if patience_level < 0:
		patience_level = 0
	main_ui.modulate_base(1 - patience_level)
	if patience_level <= 0:
		if is_endless:
			monitor.states.change_state(MonitorState.State.Finished)
			states.change_state(GameplayState.State.Success)
		else:
			monitor_destruction_delay_timer.start()
			main_ui.punch.play("punch")
			monitor_destroyed_sfx.play()


func _on_monitor_desctruction_delay_timer_timeout() -> void:
	music.stop()
	monitor.states.change_state(MonitorState.State.Destroyed)
	monitor_destruction_delay_timer.stop()
	destruciton_transition_delay.start()


func _on_destruction_transition_delay_timeout() -> void:
	monitor_destroyed.emit()
	main_ui.punch.play("default")
	main_ui.punch_texture.visible = false
	destruciton_transition_delay.stop()


func _on_monitor_loading_completed_rotation() -> void:
	patience_level = maxf(patience_level - rotation_patience_penalty, 0.0)
	main_ui.modulate_base(1 - patience_level)
	if patience_level <= 0:
		if is_endless:
			monitor.states.change_state(MonitorState.State.Finished)
			states.change_state(GameplayState.State.Success)
		else:
			monitor_destruction_delay_timer.start()
			main_ui.punch.play("punch")
