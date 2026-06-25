extends GameManagerState

@onready var losing_ui: CanvasLayer = $LosingUI
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var destroy_audio: AudioStreamPlayer2D = $DestroyAudio

func enter() -> void:
	toggle_state_visibility(self, true) 
	destroy_audio.play()
	losing_ui.visible = false
	animation.frame = 0
	animation.play()
	

func exit() -> void:
	toggle_state_visibility(self, false) 
	destroy_audio.stop()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	var game_manager := entity as GameManager
	return GameManagerState.State.Losing


func _on_animated_sprite_2d_animation_finished() -> void:
	losing_ui.visible = true
	pass # Replace with function body.
