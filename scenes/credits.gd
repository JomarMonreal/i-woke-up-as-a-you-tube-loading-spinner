extends AnimationPlayer

@onready var game: GameManager = get_tree().get_first_node_in_group("game_manager")
var is_finished = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_anything_pressed() and is_finished:
		game.current_timeline_index = 0
		game.has_watched_cutscenes = [false, false, false, false, false]
		game.states.change_state(GameManagerState.State.MainMenu)
		queue_free()
		

func _on_animation_finished(anim_name: StringName) -> void:
	is_finished = true
	pass # Replace with function body.
