extends Node
class_name GameManager

@onready var states: GameManagerStateManager = $StateManager
@onready var gameplay: Gameplay = $StateManager/Prototype/Gameplay

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
	gameplay.reset()
	gameplay.is_endless = true
	gameplay.monitor.is_endless = true
	states.change_state(GameManagerState.State.Loading)


func _on_main_menu_pressed_story() -> void:
	gameplay.reset()
	gameplay.is_endless = false
	gameplay.monitor.is_endless = false
	states.change_state(GameManagerState.State.Loading)


func _on_exit_button_up() -> void:
	states.change_state(GameManagerState.State.MainMenu)
