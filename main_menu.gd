extends CanvasLayer

@export var start_button: Button
@export var option: Button
@export var exit: Button

signal pressed_start
signal pressed_option
signal pressed_exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_up() -> void:
	pressed_start.emit()
	pass # Replace with function body.


func _on_option_button_up() -> void:
	pressed_option.emit()


func _on_exit_button_up() -> void:
	pressed_exit.emit()
