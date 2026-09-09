extends FSMNode


@export var ai_component: AIComponent

@export var speed := 50.


func enter(previous_state_path: NodePath, data := {}) -> void:
	pass


func physics_update(_delta: float) -> void:
	if ai_component.player_detected():
		finished.emit("Follow")
		return
