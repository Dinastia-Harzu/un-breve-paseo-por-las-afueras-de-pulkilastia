@tool
class_name NodeGroupsNamesRetriever
extends EditorScript


func _run() -> void:
	var script := FileAccess.open("uid://dwxebkyql2iux", FileAccess.WRITE)
	script.store_line("class_name NodeGroups\n")

	var project_settings := ConfigFile.new()
	var err := project_settings.load("res://project.godot")
	if err != OK:
		printerr("No se ha podido leer project.godot: ", err)
		return

	if not project_settings.has_section("global_group"):
		printerr("No hay grupos de nodos globales definidos")
		return

	for node_group in project_settings.get_section_keys("global_group"):
		script.store_line("const %s := \"%s\"" % [node_group.to_upper(), node_group])

# 	var scene_groups := _read_recursive("res://src/scenes/")
#
#
# func _read_recursive(current_path: String) -> Array[String]:
# 	var scene_groups: Array[String] = []
# 	var dir := DirAccess.open(current_path)
# 	if dir:
# 		dir.list_dir_begin()
# 		var file_name := dir.get_next()
# 		while not file_name.is_empty():
# 			var full_path := current_path + file_name
# 			if dir.current_is_dir():
# 				scene_groups.append_array(_read_recursive(full_path + "/"))
# 			elif file_name.ends_with(".tscn"):
# 				scene_groups.append_array(_extract_from_scene(full_path))
# 		dir.list_dir_end()
#
# 	var unique_groups: Array[String] = []
# 	for group in scene_groups:
# 		if not group in unique_groups:
# 			unique_groups.append(group)
# 	return unique_groups
#
#
# func _extract_from_scene(scene_path: String) -> Array[String]:
# 	var scene_groups: Array[String] = []
# 	var scene := FileAccess.open(scene_path, FileAccess.READ)
# 	if scene:
# 		while not scene.eof_reached():
# 			var current_line := scene.get_line()
# 			if current_line.begins_with("[node ") and "groups=[" in current_line:
#
