extends GameManagerState

@onready var main_menu = $MainMenu

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	return GameManagerState.State.MainMenu


func _on_main_menu_pressed_start() -> void:
	var game_manger := entity as GameManager
	game_manger.states.change_state(GameManagerState.State.Prototype)
