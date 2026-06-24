extends CanvasLayer
class_name MainUI

enum Timing {
	Early,
	Good,
	Perfect,
	Late
}

@onready var red_overlay: TextureRect = $Control/RedOverlay
@onready var camera: GameCamera = get_tree().get_first_node_in_group("camera")
@onready var punch: AnimationPlayer = $Control/AnimationPlayer

@export var flash_speed := 0.15
var base_modulation = 0.0
var _flash_tween: Tween

func modulate_base(amount: float) -> void:
	if _flash_tween:
		_flash_tween.kill()
	base_modulation = amount
	red_overlay.modulate.a = amount

func _ready() -> void:
	red_overlay.modulate.a = base_modulation
	$Control.mouse_filter = Control.MOUSE_FILTER_IGNORE

func flash_red() -> void:
	if _flash_tween:
		_flash_tween.kill()
	_flash_tween = create_tween()
	_flash_tween.tween_property(red_overlay, "modulate:a", 1.0, flash_speed)
	_flash_tween.tween_property(red_overlay, "modulate:a", base_modulation, flash_speed)

func _process(_delta: float) -> void:
	pass
