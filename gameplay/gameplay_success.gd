extends GameplayState

@export var duration := 1.0
@export var default_girl_position := Vector2(304.889, 171.5)
@export var finished_girl_position := Vector2(804.889, 171.5)
@export var success_zoom := Vector2(0.3, 0.3)
@export var success_camera_position := Vector2(0.0, 0.0)

@export var default_desktop_position := Vector2(0, 0)
@export var finished_desktop_position := Vector2(-2500, 0)

func enter() -> void:
	var gameplay := entity as Gameplay
	gameplay.main_ui.red_overlay.visible = false
	gameplay.camera.zoom_to(success_zoom, success_camera_position, duration)
	create_tween().tween_property(gameplay.watching_girl, "position", finished_girl_position, duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	create_tween().tween_property(gameplay.desktop, "position", finished_desktop_position, duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	gameplay.score_instance = gameplay.score_scene.instantiate() as Score
	gameplay.score_instance.setup(gameplay.perfect_count, gameplay.good_count, gameplay.early_count, gameplay.late_count)
	gameplay.add_child(gameplay.score_instance)

func process(_delta: float) -> int:
	return GameplayState.State.Success
