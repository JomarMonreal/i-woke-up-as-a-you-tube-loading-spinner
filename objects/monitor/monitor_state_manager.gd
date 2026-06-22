extends BaseStateManager
class_name MonitorStateManager

func _ready() -> void:
	states = {
		MonitorState.State.Idle: $Idle,
		MonitorState.State.Playing: $Playing,
		MonitorState.State.Loading: $Loading,
		MonitorState.State.Finished:$Finished,
	}

	initial_state = MonitorState.State.Playing
