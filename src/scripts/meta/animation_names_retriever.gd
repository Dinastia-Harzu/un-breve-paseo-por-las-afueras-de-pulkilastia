@tool
extends EditorScript


const ANIMATION_FOLDER := "res://src/resources/animations/"

func _run() -> void:
	var script := FileAccess.open("uid://dlwxqwwovg3e1", FileAccess.WRITE)
	script.store_line("class_name AnimationNames\n")

	var dir := DirAccess.open(ANIMATION_FOLDER)
	if not dir:
		push_error("No se pudo abrir la carpeta con las animaciones (%s)" % ANIMATION_FOLDER)

	var animations := {}
	var free_animations: Array[String] = []

	dir.list_dir_begin()
	var filename := dir.get_next()
	while not filename.is_empty():
		if dir.current_is_dir():
			var library_animations := _get_animations_from_library(ANIMATION_FOLDER + filename)
			if not library_animations.is_empty():
				animations[filename] = library_animations
		else:
			if is_resource_file(filename) and not filename.get_basename() in animations.keys():
				free_animations.append(filename.get_basename())
		filename = dir.get_next()
	dir.list_dir_end()
	if not free_animations.is_empty():
		animations["."] = free_animations

	var content := ""
	for library: String in animations.keys():
		var is_free := library == "."
		if not is_free:
			content += "class Lib%s:\n" % library.to_pascal_case()
		for animation: String in animations[library]:
			if not is_free:
				content += "\t"
			content += "const %s = \"%s\"\n" % [animation.to_upper(), animation]
		content += "\n"
	script.store_string(content)


func _get_animations_from_library(library_path: String) -> Array[String]:
	var animations: Array[String] = []

	var dir := DirAccess.open(library_path)
	if dir:
		dir.list_dir_begin()
		var filename := dir.get_next()
		while not filename.is_empty():
			if is_resource_file(filename):
				animations.append(filename.get_basename())
			filename = dir.get_next()
		dir.list_dir_end()

	return animations


func is_resource_file(path: String) -> bool:
	return path.ends_with(".res") or path.ends_with(".tres")
