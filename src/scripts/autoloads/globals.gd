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
