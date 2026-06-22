extends Node2D
class_name  Gameplay

enum AnomalyColor {
	Null,
	Red,
	Blue,
	Green
}

enum Timing {
	Early,
	Good,
	Perfect,
	Late
}

@onready var main_ui: CanvasLayer = $MainUI
@onready var monitor: Monitor = $Monitor
@export var max_patience_level = 100
var patience_level = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
