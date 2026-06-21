extends Node2D
class_name LoadingSpinner

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

@export var anomaly: PackedScene
@export var max_anomaly_count: int = 1
@export var anomaly_keys: Array[AnomalyColor] = [AnomalyColor.Red, AnomalyColor.Green]

@export var steps: int = 30
@export var radius: float = 32
@export var rotation_speed: float = 90

@onready var spinner: Node2D = $Spinner
@onready var spinner_collider: CollisionShape2D = $Spinner/CollisionShape2D

var anomalies_dictionary: Dictionary[int, Anomaly]
var closest_visible_anomaly = null

signal cleared_anomaly(timing: Timing)
signal pressed_wrong_color

func clear_anomaly(anomaly: Anomaly):
	var sprite_scale = anomaly.sprite_scale
	var has_been_passed = anomaly.has_been_pased
	anomaly.clear()
	if sprite_scale < 0.2:
		if has_been_passed:
			return Timing.Late
		else:
			return Timing.Early
		
	elif sprite_scale >= 0.2 and  sprite_scale < 0.4:
		return Timing.Good
	else:
		return Timing.Perfect

func spwan_anomaly_at_border():
	var possible_degrees = range(0,360,steps)
	
	for i in range(max_anomaly_count):
		var rand_index = randi_range(i, len(possible_degrees) - 1) 
		var temp = possible_degrees[i]
		possible_degrees[i] = possible_degrees[rand_index]
		possible_degrees[rand_index] = temp
		
	for i in range(max_anomaly_count):
		var anomaly_instance = anomaly.instantiate() as Anomaly
		var degree = possible_degrees[i]
		var radians = deg_to_rad(degree)
		anomaly_instance.position = Vector2(cos(radians), sin(radians)) * radius
		anomaly_instance.spinner_collider = spinner_collider
		anomaly_instance.texture_key = anomaly_keys[randi_range(0, len(anomaly_keys) - 1)]
		anomalies_dictionary[i] = anomaly_instance
		add_child(anomaly_instance)
		move_child(anomaly_instance, 0)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spwan_anomaly_at_border()
	

func _process(delta: float) -> void:
	# distance calculation
	spinner.rotation_degrees += rotation_speed * delta
	closest_visible_anomaly = null
	var smallest_distance = INF
	
	# never modify a dict while iterating it
	var stale_keys: Array = []
	for index in anomalies_dictionary:
		var a = anomalies_dictionary[index]
		if not is_instance_valid(a):
			stale_keys.append(index)
			continue
		if a.sprite_scale > 0 and a.distance_to_spinner_collider < smallest_distance:
			closest_visible_anomaly = a
			smallest_distance = a.distance_to_spinner_collider

	for key in stale_keys:
		anomalies_dictionary.erase(key)

	if not is_instance_valid(closest_visible_anomaly):
		return
	
	# input handling
	if closest_visible_anomaly == null:
		return

	if Input.is_action_just_pressed("press_red"):
		if closest_visible_anomaly.texture_key == AnomalyColor.Red:
			var timing = clear_anomaly(closest_visible_anomaly)
			cleared_anomaly.emit(timing) 
		else:
			pressed_wrong_color.emit()
			
	if Input.is_action_just_pressed("press_blue"):
		if closest_visible_anomaly.texture_key == AnomalyColor.Blue:
			var timing = clear_anomaly(closest_visible_anomaly)
			cleared_anomaly.emit(timing) 
		else:
			pressed_wrong_color.emit()
	
	if Input.is_action_just_pressed("press_green"):
		if closest_visible_anomaly.texture_key == AnomalyColor.Green:
			var timing = clear_anomaly(closest_visible_anomaly)
			cleared_anomaly.emit(timing) 
		else:
			pressed_wrong_color.emit()
