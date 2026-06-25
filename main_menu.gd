extends CanvasLayer

signal pressed_story
signal pressed_endless

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_story_button_up() -> void:
	pressed_story.emit()
	pass # Replace with function body.


func _on_endless_button_up() -> void:
	pressed_endless.emit()
	pass # Replace with function body.
