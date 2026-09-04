@tool
class_name LayerNamesRetriever
extends EditorScript


func _run() -> void:
	var script := FileAccess.open("res://src/scripts/utils/layer_names.gd", FileAccess.WRITE)
	script.store_line("class_name LayerNames\n")

	const LAYER_TYPES := ["avoidance", "3d_navigation", "3d_physics", "2d_navigation", "2d_physics"]
	for layer_type in LAYER_TYPES:
		var layer_type_namespace: String
		match layer_type:
			"avoidance": layer_type_namespace = "Avoidance"
			"3d_navigation": layer_type_namespace = "Navigation3D"
			"3d_physics": layer_type_namespace = "Physics3D"
			"2d_navigation": layer_type_namespace = "Navigation2D"
			"2d_physics": layer_type_namespace = "Physics2D"
		script.store_line("class %s:" % layer_type_namespace)
		for layer in 32:
			layer += 1
			var layer_name: String = ProjectSettings.get_setting("layer_names/%s/layer_%d" % [layer_type, layer])
			if layer_name.is_empty():
				layer_name = "LAYER_%d" % layer
			script.store_line("\tconst %s = %d" % [layer_name.to_upper(), layer])
