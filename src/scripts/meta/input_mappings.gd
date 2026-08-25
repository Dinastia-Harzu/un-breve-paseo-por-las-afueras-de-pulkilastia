@tool
class_name InputMappings extends EditorScript

func _run() -> void:
	var script := FileAccess.open("res://src/scripts/utils/input_actions.gd", FileAccess.WRITE)
	script.store_line("class_name InputActions")
	for action_name in InputMap.get_actions():
		var action_ident := action_name.replace(".", "__").replace("/", "__").to_upper()
		script.store_line("const %s := &\"%s\"" % [action_ident, action_name])
	pass
