extends Node

func panic(message: String = "") -> void:
	if message.is_empty():
		message = "Panic!"
	else:
		message = "Panic reason: %s" % message
	push_error(message)
	print_stack()
	get_tree().quit(1)


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
