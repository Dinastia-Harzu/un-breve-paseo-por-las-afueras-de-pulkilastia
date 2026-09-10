extends FSMNode


@export var min_idle_time := 0.5
@export var max_idle_time := 2.

@export var ai_component: AIComponent
@export var idle_timer: Timer


func _ready() -> void:
	idle_timer.timeout.connect(_on_timeout)


func enter(previous_state_path: NodePath, data := {}) -> void:
	idle_timer.start(_random_time())


func physics_update(_delta: float) -> void:
	if ai_component.player_detected():
		finished.emit("Follow")
		return


func exit() -> void:
	idle_timer.stop()


func _random_time() -> float:
	return randf_range(min_idle_time, max_idle_time)


func _on_timeout() -> void:
	finished.emit("Patrol")
