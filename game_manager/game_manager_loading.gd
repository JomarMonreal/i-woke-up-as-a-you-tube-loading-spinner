extends GameManagerState

@onready var loading_timer: Timer = $Timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	return GameManagerState.State.Loading


func _on_timer_timeout() -> void:
	var game_manger := entity as GameManager
	game_manger.states.change_state(GameManagerState.State.MainMenu)
