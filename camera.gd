extends Camera2D
class_name GameCamera

var shake_duration := 0.0
var shake_max_duration := 0.0
var shake_strength := 0.0

var _zoom_tween: Tween

func shake(duration: float, strength: float) -> void:
	shake_duration = duration
	shake_max_duration = duration
	shake_strength = strength

func zoom_to(target_zoom: Vector2, target_position: Vector2, duration: float) -> void:
	if _zoom_tween:
		_zoom_tween.kill()
	_zoom_tween = create_tween().set_parallel(true)
	_zoom_tween.tween_property(self, "zoom", target_zoom, duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	_zoom_tween.tween_property(self, "position", target_position, duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

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
