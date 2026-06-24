extends BaseStateManager
class_name GameplayStateManager

func _ready() -> void:
	states = {
		GameplayState.State.Playing: $Playing,
		GameplayState.State.Success: $Success,
	}
		
	initial_state = GameplayState.State.Playing
