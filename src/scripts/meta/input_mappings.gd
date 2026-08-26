@tool
class_name InputMappings
extends EditorScript


func _run() -> void:
	InputMap.load_from_project_settings()
	var script := FileAccess.open("uid://dtrk02e8x40vf", FileAccess.WRITE)
	script.store_line("class_name InputActions\n")
	for action_name in InputMap.get_actions():
		var action_ident := action_name.replace(".", "__").replace("/", "__").to_upper()
		script.store_line("const %s := &\"%s\"" % [action_ident, action_name])
	pass
