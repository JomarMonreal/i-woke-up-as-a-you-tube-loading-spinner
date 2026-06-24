extends Control

@export var float_amplitude := 8.0  # pixels up and down
@export var float_speed := 2.0      # cycles per second

var _origin_y: float
var _time := 0.0

func _ready() -> void:
	_origin_y = position.y

func _process(delta: float) -> void:
	_time += delta
	position.y = _origin_y + sin(_time * float_speed * TAU) * float_amplitude
