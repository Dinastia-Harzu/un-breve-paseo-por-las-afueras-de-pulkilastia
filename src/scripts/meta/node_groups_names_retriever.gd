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
