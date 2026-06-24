extends GameManagerState

@onready var losing_ui: CanvasLayer = $LosingUI
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func enter() -> void:
	toggle_state_visibility(self, true) 
	losing_ui.visible = false
	animation.frame = 0
	animation.play()
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	return GameManagerState.State.Losing


func _on_animated_sprite_2d_animation_finished() -> void:
	losing_ui.visible = true
	pass # Replace with function body.
