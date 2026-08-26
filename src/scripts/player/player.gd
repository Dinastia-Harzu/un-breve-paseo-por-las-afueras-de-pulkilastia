class_name Player
extends CharacterBody2D


@export var speed: float = 100.

@export var sprite: Sprite2D



func _physics_process(delta: float) -> void:
	var direction := Input.get_vector(InputActions.LEFT, InputActions.RIGHT, InputActions.UP, InputActions.DOWN)
	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	move_and_slide()
