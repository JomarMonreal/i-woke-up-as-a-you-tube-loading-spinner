extends GameManagerState

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var label: Label = $CanvasLayer/Control/Label
@onready var timer: Timer = $Timer

@export var credits: PackedScene

func enter() -> void:
	toggle_state_visibility(self, true) 
	var game := entity as GameManager
	
	# credits
	if game.current_timeline_index > 4:
		canvas_layer.visible = false
		Dialogic.start("day_5")
		await Dialogic.timeline_ended
		var instance = credits.instantiate()
		add_child(instance)
		return
		
	label.text = "Day " + str(game.current_timeline_index + 1)
	if game.has_watched_cutscenes[game.current_timeline_index]:
		canvas_layer.visible = true
	else:
		canvas_layer.visible = false
		Dialogic.start(game.story_timelines[game.current_timeline_index])
		await Dialogic.timeline_ended
		game.has_watched_cutscenes[game.current_timeline_index] = true
		canvas_layer.visible = true
	timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	return GameManagerState.State.Cutscene


func _on_timer_timeout() -> void:
	var game := entity as GameManager
	game.states.change_state(GameManagerState.State.Prototype)
	timer.stop()
