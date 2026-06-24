extends Node2D

enum Timing {
	Early,
	Good,
	Perfect,
	Late
}

@onready var perfect_spawn = $Perfect
@onready var good_spawn = $Good
@onready var early_spawn = $Early
@onready var late_spawn = $Late

@export var perfect_text: PackedScene
@export var good_text: PackedScene
@export var early_text: PackedScene
@export var late_text: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_monitor_cleared_anomaly(timing: Monitor.Timing) -> void:
	if timing == Timing.Perfect:
		var instance = perfect_text.instantiate()
		perfect_spawn.add_child(instance)
	if timing == Timing.Good:
		var instance = good_text.instantiate()
		good_spawn.add_child(instance)
	if timing == Timing.Early:
		var instance = early_text.instantiate()
		early_spawn.add_child(instance)
	if timing == Timing.Late:
		var instance = late_text.instantiate()
		late_spawn.add_child(instance)
