extends GameManagerState

@onready var main_menu = $MainMenu
@onready var main_menu_music = $MainMenuMusic

func enter() -> void:
	main_menu_music.play()
	toggle_state_visibility(self, true) 

func exit() -> void:
	main_menu_music.stop()
	toggle_state_visibility(self, false) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	return GameManagerState.State.MainMenu
