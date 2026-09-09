class_name AIComponent
extends Node2D


var sensors: Array[Sensor2D] = []

var player: Player = null


func _ready() -> void:
	for child: Sensor2D in find_children("*", "Sensor2D"):
		sensors.append(child)


func _physics_process(delta: float) -> void:
	var detected_player: Player = null
	for sensor in sensors:
		if sensor.has_detected():
			detected_player = sensor.target
			break

	player = detected_player


func player_detected() -> bool:
	return player != null
