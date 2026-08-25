extends Camera2D


# FUTURE: apaño temporal
var target: Node2D = null


func _process(delta: float) -> void:
	if target != null:
		global_position = target.global_position
