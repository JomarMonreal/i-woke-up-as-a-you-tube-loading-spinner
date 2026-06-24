extends TextureRect

@export var rotation_speed := 90.0  # degrees per second

func _ready() -> void:
	pivot_offset = size / 2.0
	resized.connect(func(): pivot_offset = size / 2.0)

func _process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta
