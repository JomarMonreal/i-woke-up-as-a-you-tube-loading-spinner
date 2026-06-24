extends GameManagerState

@onready var main_menu = $MainMenu

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	return GameManagerState.State.MainMenu
