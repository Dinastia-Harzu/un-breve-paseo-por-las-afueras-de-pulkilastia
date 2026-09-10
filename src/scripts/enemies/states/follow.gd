extends FSMNode


@export var speed := 80.

@export var ai_component: AIComponent
@export var movement_component: MovementComponent
@export var navigation_agent: NavigationAgent2D
@export var navigation_timer: Timer


func _ready() -> void:
	navigation_timer.timeout.connect(_on_timeout)


func enter(previous_state_path: NodePath, data := {}) -> void:
	navigation_timer.timeout.emit()
	navigation_timer.start()


func physics_update(delta: float) -> void:
	if not ai_component.player_detected():
		finished.emit("Patrol")
		return

	if not navigation_agent.is_navigation_finished():
		movement_component.move_towards(
			movement_component.body.to_local(navigation_agent.get_next_path_position()).normalized(),
			speed,
			delta
		)
	else:
		movement_component.move_towards(Vector2.ZERO, speed, delta)


func exit() -> void:
	navigation_timer.stop()


func _on_timeout() -> void:
	if ai_component.player_detected():
		navigation_agent.target_position = ai_component.player.global_position
