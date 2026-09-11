class_name Transition
extends Control


signal finished


@export_enum(
	AnimationNames.LibTransition.BATTLE_TRANSITION,
	AnimationNames.LibTransition.BATTLE_ENDED_TRANSITION,
	AnimationNames.LibTransition.BACK_TO_LEVEL_TRANSITION
) var animation: String

@export var transition_animator: AnimationPlayer


func _ready() -> void:
	transition_animator.animation_finished.connect(_on_animation_finished)


func play() -> void:
	transition_animator.play(animation)


func reset(restart: bool = false) -> void:
	transition_animator.play("RESET")
	if restart:
		play()


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name != "RESET":
		finished.emit()
