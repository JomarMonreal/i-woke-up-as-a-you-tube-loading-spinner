extends GameManagerState

func enter() -> void:
	toggle_state_visibility(self, true) 
	var game := entity as GameManager
	game.gameplay.reset()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	return GameManagerState.State.Prototype
