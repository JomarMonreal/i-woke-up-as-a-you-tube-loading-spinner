extends Control

@export var default_font_size := 16
@export var hover_font_size := 22
@export var default_color := Color.WHITE
@export var hover_color := Color(1.0, 0.95, 0.5)
@export var duration := 0.15

var _tween: Tween
var _current_size: float
var _current_color: Color

func _ready() -> void:
	pivot_offset = size / 2.0
	resized.connect(func(): pivot_offset = size / 2.0)
	_current_size = default_font_size
	_current_color = default_color
	add_theme_font_size_override("font_size", default_font_size)
	add_theme_color_override("font_color", default_color)
	add_theme_color_override("font_shadow_color", Color(hover_color.r, hover_color.g, hover_color.b, 0.0))
	add_theme_constant_override("shadow_offset_x", 0)
	add_theme_constant_override("shadow_offset_y", 0)
	add_theme_constant_override("shadow_outline_size", 6)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)

func _on_hover() -> void:
	_animate(hover_font_size, hover_color, 1.0)

func _on_unhover() -> void:
	_animate(default_font_size, default_color, 0.0)

func _animate(target_size: float, target_color: Color, target_glow_alpha: float) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_method(
		func(s: float):
			_current_size = s
			add_theme_font_size_override("font_size", int(s)),
		_current_size, target_size, duration
	)
	_tween.tween_method(
		func(c: Color):
			_current_color = c
			add_theme_color_override("font_color", c),
		_current_color, target_color, duration
	)
	var current_glow = get_theme_color("font_shadow_color").a
	_tween.tween_method(
		func(a: float):
			add_theme_color_override("font_shadow_color", Color(hover_color.r, hover_color.g, hover_color.b, a)),
		current_glow, target_glow_alpha, duration
	)
