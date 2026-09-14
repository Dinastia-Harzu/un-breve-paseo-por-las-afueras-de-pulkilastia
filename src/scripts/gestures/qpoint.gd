class_name QPoint

var position: Vector2:
	get:
		# print("%v is%s tool" % [position, "" if (get_script() as Script).is_tool() else "n't"])
		# print_stack()
		return position
var stroke_id: int
var int_pos: Vector2i = Vector2i.ZERO


func _init(p: Vector2, si: int) -> void:
	position = p
	stroke_id = si


func _to_string() -> String:
	return "QPoint { position: %v, stroke_id: %d, int_pos: %.v }" % [position, stroke_id, int_pos]


func distance_to(other: QPoint) -> float:
	return position.distance_to(other.position)


func distance_squared_to(other: QPoint) -> float:
	return position.distance_squared_to(other.position)


func int_distance_to(other: QPoint) -> float:
	return int_pos.distance_to(other.int_pos)


func int_distance_squared_to(other: QPoint) -> float:
	return int_pos.distance_squared_to(other.int_pos)


func in_same_stroke_as(other: QPoint) -> bool:
	return stroke_id == other.stroke_id


func new_in_same_stroke(pos: Vector2) -> QPoint:
	return QPoint.new(pos, stroke_id)
