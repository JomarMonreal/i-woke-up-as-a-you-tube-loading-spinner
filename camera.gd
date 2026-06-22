extends Camera2D

var shake_duration := 0.0
var shake_max_duration := 0.0
var shake_strength := 0.0

func shake(duration: float, strength: float) -> void:
	shake_duration = duration
	shake_max_duration = duration
	shake_strength = strength

func _process(delta: float) -> void:
	if shake_duration > 0.0:
		shake_duration -= delta
		var t = shake_duration / shake_max_duration
		var current_strength = shake_strength * t * t 
		offset = Vector2(
			randf_range(-current_strength, current_strength),
			randf_range(-current_strength, current_strength)
		)
	else:
		offset = Vector2.ZERO
