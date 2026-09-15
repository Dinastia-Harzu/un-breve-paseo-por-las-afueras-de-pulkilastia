extends Node


const POINT_CLOUDS := 16
const NUM_POINTS := 32
const MAX_INT_COORD := 1024
const LUT_SIZE := 64
const LUT_SCALE_FACTOR := float(MAX_INT_COORD) / float(LUT_SIZE)

var templates: Array[PointCloud] = []
var associated_moves: Dictionary[String, MoveData] = {}


func _ready() -> void:
	const PATH := "res://src/resources/gestures/"
	const EXTENSION := ".tres"
	for gesture_template_file in [
		"curar",
		"empty",
		"kaminari",
		"star",
	]:
		var gesture_template := ResourceLoader.load(PATH + gesture_template_file + EXTENSION) as GestureTemplate
		assert(gesture_template != null)
		add_template(gesture_template)


func add_template(gesture_template: GestureTemplate) -> void:
	gesture_template.deserialize()
	templates.append(gesture_template.point_cloud)
	associated_moves[gesture_template.point_cloud.gesture_name] = gesture_template.associated_move


class Result:
	var score: float
	var time: float
	var name: String

	func _init(s: float, ms: float, n: String = "Nil") -> void:
		score = s
		time = ms
		name = n

	func _to_string() -> String:
		return "Result { score: %f, time: %.2fs, name: %s }" % [score, time, name]
