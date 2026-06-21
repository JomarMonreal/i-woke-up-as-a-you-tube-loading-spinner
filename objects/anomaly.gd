extends Area2D
class_name Anomaly

enum AnomalyColor {
	Null,
	Red,
	Blue,
	Green
}

@onready var sprite: Sprite2D = $Sprite2D
@export var explosion_effect: PackedScene
@export var textures: Dictionary[AnomalyColor, Texture2D]
@export var max_distance = 50.0
var texture_key = AnomalyColor.Blue
var spinner_collider: CollisionShape2D

var sprite_scale = 0
var distance_to_spinner_collider = INF
var has_been_pased = false

var _previous_distance = INF

func clear() -> void:
	set_process(false)
	sprite_scale = 0
	sprite.visible = false

	if explosion_effect:
		var effect = explosion_effect.instantiate() as CPUParticles2D
		if texture_key == AnomalyColor.Red:
			effect.color = Color.FIREBRICK
		elif texture_key == AnomalyColor.Blue:
			effect.color = Color.DODGER_BLUE
		elif texture_key == AnomalyColor.Green:
			effect.color = Color.FOREST_GREEN
		add_child(effect)
		effect.global_position = global_position
		
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = textures.get(texture_key)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spinner_collider:
		_previous_distance = distance_to_spinner_collider
		distance_to_spinner_collider = spinner_collider.global_position.distance_to(global_position)
		
		var t = clamp(distance_to_spinner_collider / max_distance, 0.0, 1.0)
		var new_scale = lerp(0.5, 0.0, t)  # swapped: 0.25 when close, 0.0 when far
		sprite_scale = new_scale
		sprite.scale = Vector2(new_scale, new_scale)
		
		if sprite_scale <= 0:
			has_been_pased = false
			return

		if distance_to_spinner_collider > _previous_distance:
			has_been_pased = true
		
		
		
