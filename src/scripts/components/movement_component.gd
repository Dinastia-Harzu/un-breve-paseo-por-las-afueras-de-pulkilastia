class_name MovementComponent
extends Node


@export var body: CharacterBody2D
@export var acceleration := 10.
@export var friction := 15.

var _movement := _acceleration_movement


func _ready() -> void:
	if acceleration < 0. or friction < 0.:
		_movement = _accelerationless_movement



func move_towards(direction: Vector2, max_speed: float, delta: float) -> void:
	body.velocity = _movement.call(direction, max_speed, delta)
	body.move_and_slide()


func move_towards_target(target: Node2D, max_speed: float, delta: float) -> void:
	return move_towards(direction_to(target), max_speed, delta)


func direction_to(to: Node2D) -> Vector2:
	return body.global_position.direction_to(to.global_position)


func _acceleration_movement(direction: Vector2, max_speed: float, delta: float) -> Vector2:
	return body.velocity.lerp(
		direction.normalized() * max_speed,
		(acceleration if direction != Vector2.ZERO else friction) * delta
	)

func _accelerationless_movement(direction: Vector2, speed: float, _delta: float) -> Vector2:
	return direction * speed if direction else body.velocity.move_toward(Vector2.ZERO, speed)
