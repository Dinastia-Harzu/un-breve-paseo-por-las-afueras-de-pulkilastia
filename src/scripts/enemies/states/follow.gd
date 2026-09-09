extends FSMNode


@export var speed := 80.

@export var ai_component: AIComponent
@export var movement_component: MovementComponent


func enter(previous_state_path: NodePath, data := {}) -> void:
	pass


func physics_update(delta: float) -> void:
	if not ai_component.player_detected():
		finished.emit("Patrol")
		return

	movement_component.move_towards_target(ai_component.player, speed, delta)
