class_name Transition
extends Control


signal finished


@export var transition_animator: AnimationPlayer


func _ready() -> void:
	transition_animator.animation_finished.connect(_on_animation_finished)


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "RESET":
		return

	transition_animator.play("RESET")
	finished.emit()
