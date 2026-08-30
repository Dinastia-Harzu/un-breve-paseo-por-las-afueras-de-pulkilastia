extends Control


@onready var fps_label: Label = %FPS


func _process(delta: float) -> void:
	fps_label.text = "FPS: %s" % Engine.get_frames_per_second()
