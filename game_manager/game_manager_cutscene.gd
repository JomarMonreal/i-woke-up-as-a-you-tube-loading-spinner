extends GameManagerState

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var label: Label = $CanvasLayer/Control/Label
@onready var timer: Timer = $Timer

@export var credits: PackedScene

var _waiting_for_timeline := false
var _is_credits := false
var _timeline_started := false


func enter() -> void:
	toggle_state_visibility(self, true)
	var game := entity as GameManager

	if game.current_timeline_index > 4:
		canvas_layer.visible = false
		_is_credits = true
		_timeline_started = false
		_waiting_for_timeline = true
		Dialogic.start("day_5")
		return

	_is_credits = false
	label.text = "Day " + str(game.current_timeline_index + 1)
	if game.has_watched_cutscenes[game.current_timeline_index]:
		canvas_layer.visible = true
		timer.start()
	else:
		canvas_layer.visible = false
		_timeline_started = false
		_waiting_for_timeline = true
		Dialogic.start(game.story_timelines[game.current_timeline_index])


func process(_delta: float) -> int:
	if _waiting_for_timeline:
		if not _timeline_started:
			if Dialogic.current_timeline != null:
				_timeline_started = true
		else:
			if Dialogic.current_timeline == null:
				_waiting_for_timeline = false
				_on_timeline_done()
	return GameManagerState.State.Cutscene


func _on_timeline_done() -> void:
	if _is_credits:
		var instance = credits.instantiate()
		add_child(instance)
		return

	var game := entity as GameManager
	game.has_watched_cutscenes[game.current_timeline_index] = true
	canvas_layer.visible = true
	timer.start()


func _on_timer_timeout() -> void:
	var game := entity as GameManager
	game.states.change_state(GameManagerState.State.Prototype)
	timer.stop()
