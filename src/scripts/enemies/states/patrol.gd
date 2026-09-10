extends FSMNode


@export var speed := 50.
@export var min_patrol_time := 0.5
@export var max_patrol_time := 2.
@export var min_patrol_radius := 16.
@export var max_patrol_radius := 48.

@export var ai_component: AIComponent
@export var movement_component: MovementComponent
@export var navigation_agent: NavigationAgent2D


func enter(previous_state_path: NodePath, data := {}) -> void:
	var body := movement_component.body
	var angle := randf_range(-PI, PI)
	var random_point := \
		body.global_position \
		+ Vector2(cos(angle), sin(angle)) \
		* randf_range(min_patrol_radius, max_patrol_radius)
	navigation_agent.target_position = NavigationServer2D.map_get_closest_point(
		body.get_world_2d().navigation_map,
		random_point
	)


func physics_update(delta: float) -> void:
	if ai_component.player_detected():
		finished.emit("Follow")
		return

	if not navigation_agent.is_navigation_finished():
		movement_component.move_towards(
			movement_component.body.to_local(navigation_agent.get_next_path_position()).normalized(),
			speed,
			delta
		)
	else:
		finished.emit("Idle")
