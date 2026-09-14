extends Node


func quit_game() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	exit()


func exit(exit_code: int = 0) -> void:
	get_tree().quit(exit_code)


func panic(message: String = "") -> void:
	if message.is_empty():
		message = "Panic!"
	else:
		message = "Panic reason: %s" % message
	push_error(message)
	print_stack()
	exit(1)


func todo(message: String = "") -> void:
	panic(message if not message.is_empty() else "Not yet implemented")


func unimplemented(message: String = "") -> void:
	panic(message if not message.is_empty() else "Not implemented")


func check(obj: Object, expected: String = "") -> bool:
	if obj == null:
		if not expected.is_empty():
			push_error(expected)
		return false
	return true


func remove_all_children(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)


func strongest_axis(v: Vector2) -> Vector2:
	var sv := v.sign()
	return Vector2(sv.x, 0.) if v.abs().aspect() >= 1. else Vector2(0., sv.y)


func vmax(v: Vector2) -> float:
	return maxf(v.x, v.y)


func vmin(v: Vector2) -> float:
	return minf(v.x, v.y)


func iota(size: int) -> Array[int]:
	var ι: Array[int] = []
	for i in size:
		ι.append(i)
	return ι
