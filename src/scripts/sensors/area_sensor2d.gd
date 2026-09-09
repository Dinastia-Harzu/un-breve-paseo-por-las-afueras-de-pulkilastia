class_name AreaSensor2D
extends Sensor2D


@export var area: Area2D
@export var raycast: RayCast2D = null

var _target_in_range: Player = null


func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	if using_raycast():
		raycast.enabled = false


func _physics_process(delta: float) -> void:
	if not using_raycast() or _target_in_range == null:
		return

	raycast.target_position = raycast.to_local(_target_in_range.global_position)
	raycast.force_raycast_update()

	if raycast.is_colliding():
		if raycast.get_collider() is Player:
			target = _target_in_range
		else:
			target = null
	else:
		target = null


func using_raycast() -> bool:
	return raycast != null


func _on_body_entered(body: Node2D) -> void:
	if using_raycast():
		_target_in_range = body
		raycast.enabled = true
	else:
		target = body


func _on_body_exited(body: Node2D) -> void:
	if using_raycast():
		_target_in_range = null
		raycast.enabled = false
	target = null
