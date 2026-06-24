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
	pass # Replace with function body.


func _on_main_menu_pressed_endless() -> void:
	states.change_state(GameManagerState.State.Loading)


func _on_main_menu_pressed_story() -> void:
	states.change_state(GameManagerState.State.Loading)


func _on_gameplay_go_to_main_menu() -> void:
	states.change_state(GameManagerState.State.MainMenu)
