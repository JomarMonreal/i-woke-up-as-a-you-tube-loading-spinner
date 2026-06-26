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
		var instance = perfect_text.instantiate() as TextEffect
		perfect_spawn.add_child(instance)
		instance.sound.play()
	if timing == Timing.Good:
		var instance = good_text.instantiate() as TextEffect
		good_spawn.add_child(instance)
		instance.sound.play()
	if timing == Timing.Early:
		var instance = early_text.instantiate() as TextEffect
		early_spawn.add_child(instance)
		instance.sound.play()
	if timing == Timing.Late:
		var instance = late_text.instantiate() as TextEffect
		late_spawn.add_child(instance)
		instance.sound.play()
