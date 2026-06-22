extends BaseState
class_name GameManagerState

enum State {
	Null,
	Loading,
	MainMenu,
	Prototype
}

func toggle_state_visibility(state: Node, is_visible: bool) -> void:
	for child in state.get_children():
		if "visible" in child:
			child.visible = is_visible
			child.process_mode = Node.PROCESS_MODE_INHERIT if is_visible else Node.PROCESS_MODE_DISABLED
			for sub_child in child.get_children():
				if sub_child is CanvasLayer:
					sub_child.visible = is_visible

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	toggle_state_visibility(self, true) 

func exit() -> void:
	toggle_state_visibility(self, false) 
