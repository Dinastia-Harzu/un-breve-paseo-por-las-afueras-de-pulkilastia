class_name Player
extends CharacterBody2D


@export var speed: float = 100.

@export var sprite: Sprite2D
@export var remote_transform: RemoteTransform2D


func _ready() -> void:
	add_to_group(NodeGroups.WORLD_ENTITIES)


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

	move_and_slide()


func assign_camera(camera: Camera2D) -> void:
	remote_transform.remote_path = camera.get_path()
