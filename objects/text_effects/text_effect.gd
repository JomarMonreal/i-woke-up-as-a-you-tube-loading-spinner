extends Node2D
class_name TextEffect

@onready var label: Label = $Control/Label

@export var pop_duration := 0.15
@export var hold_duration := 0.3
@export var fade_duration := 0.1
@export var pop_scale := Vector2(1.3, 1.3)
@export var final_scale := Vector2(1.0, 1.0)
@export var auto_free := true
@export var auto_play := true
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	sound.stop()
	label.scale = Vector2.ZERO
	label.modulate.a = 1.0
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.get_parent().mouse_filter = Control.MOUSE_FILTER_IGNORE
	if auto_play:
		play()

func play() -> void:
	var tween = create_tween()
	tween.tween_property(label, "scale", pop_scale, pop_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(label, "scale", final_scale, pop_duration * 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(hold_duration)
	if auto_free:
		tween.tween_property(label, "modulate:a", 0.0, fade_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		tween.tween_callback(queue_free)
