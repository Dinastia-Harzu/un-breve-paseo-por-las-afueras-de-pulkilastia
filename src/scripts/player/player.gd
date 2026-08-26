class_name Player
extends CharacterBody2D


@export var speed: float = 100.

@export var sprite: Sprite2D


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector(
		InputActions.MOVE_LEFT,
		InputActions.MOVE_RIGHT,
		InputActions.MOVE_UP,
		InputActions.MOVE_DOWN
	)
	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	Log.info("%.2v" % global_position)

	move_and_slide()
