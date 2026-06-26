extends Node
class_name GameManager

@onready var states: GameManagerStateManager = $StateManager
@onready var gameplay: Gameplay = $StateManager/Prototype/Gameplay
@export var story_mode_config: StoryModeConfig

var story_timelines = ["day_1","day_2","day_3","day_4","day_45"]
var has_watched_cutscenes: Array[bool] = [false, false, false, false, false]
var current_timeline_index = 0

func _ready() -> void:
	states.init(self)
	
func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)


func _on_gameplay_monitor_destroyed() -> void:
	states.change_state(GameManagerState.State.Losing)


func _on_restart_button_button_up() -> void:
	gameplay.reset()
	states.change_state(GameManagerState.State.Prototype)


func _on_main_menu_pressed_endless() -> void:
	gameplay.is_endless = true
	gameplay.monitor.is_endless = true
	gameplay.reset()
	states.change_state(GameManagerState.State.Loading)


func _on_main_menu_pressed_story() -> void:
	gameplay.is_endless = false
	gameplay.monitor.is_endless = false
	gameplay.reset()
	states.change_state(GameManagerState.State.Loading)


func _on_exit_button_up() -> void:
	states.change_state(GameManagerState.State.MainMenu)
