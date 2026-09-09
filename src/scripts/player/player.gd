class_name Player
extends CharacterBody2D


@export var speed: float = 100.

@export var sprite: Sprite2D
@export var remote_transform: RemoteTransform2D
@export var movement_component: MovementComponent


func _ready() -> void:
	add_to_group(NodeGroups.PLAYER)
	add_to_group(NodeGroups.WORLD_ENTITIES)


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector(
		InputActions.MOVE_LEFT,
		InputActions.MOVE_RIGHT,
		InputActions.MOVE_UP,
		InputActions.MOVE_DOWN
	)
	movement_component.move_towards(direction, speed, delta)


func assign_camera(camera: Camera2D) -> void:
	remote_transform.remote_path = camera.get_path()
