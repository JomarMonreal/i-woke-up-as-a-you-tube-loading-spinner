extends Node2D
class_name Score

@onready var late_label: TextEffect = $Late
@onready var late_score: TextEffect = $LateScore

@onready var early_label: TextEffect = $Early
@onready var early_score: TextEffect = $EarlyScore

@onready var good_label: TextEffect = $Good
@onready var good_score: TextEffect = $GoodScore

@onready var perfect_label: TextEffect = $Perfect
@onready var perfect_score: TextEffect = $PerfectScore

@onready var actions: TextEffect = $PressToContinue

@export var item_delay := 0.2

var _perfect := 0
var _good := 0
var _early := 0
var _late := 0

var _accepting_input := false

func setup(perfect: int, good: int, early: int, late: int) -> void:
	_perfect = perfect
	_good = good
	_early = early
	_late = late

func _ready() -> void:
	perfect_score.label.text = str(_perfect)
	good_score.label.text = str(_good)
	early_score.label.text = str(_early)
	late_score.label.text = str(_late)

	var items: Array[TextEffect] = [
		late_label, late_score,
		early_label, early_score,
		good_label, good_score,
		perfect_label, perfect_score,
		actions
	]
	for item in items:
		item.sound.autoplay = false
		item.sound.stop()
		item.play()
		await get_tree().create_timer(item_delay).timeout

	_accepting_input = true

func _input(event: InputEvent) -> void:
	if not _accepting_input:
		return
	if (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
		var game_manager := get_tree().get_first_node_in_group("game_manager") as GameManager
		if game_manager:
			game_manager.states.change_state(GameManagerState.State.MainMenu)
