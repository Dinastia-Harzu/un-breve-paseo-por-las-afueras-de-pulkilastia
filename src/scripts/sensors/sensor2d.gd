class_name Sensor2D
extends Node2D


var target: Node2D = null


func has_detected() -> bool:
	return target != null
