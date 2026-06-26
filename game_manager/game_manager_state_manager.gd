extends BaseStateManager
class_name GameManagerStateManager

func init(entity: Node) -> void:
	for child in get_children():
		if child is GameManagerState:
			child.entity = entity
			child.toggle_state_visibility(child, false)

	change_state(initial_state)

func _ready() -> void:
	states = {
		GameManagerState.State.Loading: $Loading,
		GameManagerState.State.MainMenu: $MainMenu,
		GameManagerState.State.Prototype: $Prototype,
		GameManagerState.State.Losing: $Losing,
		GameManagerState.State.Cutscene: $Cutscene
	}
		
	initial_state = GameManagerState.State.MainMenu
