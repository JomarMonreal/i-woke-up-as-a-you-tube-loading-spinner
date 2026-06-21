extends CanvasLayer

enum Timing {
	Early,
	Good,
	Perfect,
	Late
}

@onready var timing_label: Label = $Control/Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_loading_cleared_anomaly(timing: LoadingSpinner.Timing) -> void:
	var timing_string = Timing.keys()[timing]
	timing_label.text = timing_string
