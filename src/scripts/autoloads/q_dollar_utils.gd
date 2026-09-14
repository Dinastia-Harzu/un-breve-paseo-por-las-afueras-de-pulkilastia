extends Node


class Result:
	var score: float
	var time: float
	var name: StringName

	func _init(s: float, ms: float, n: StringName = &"Nil") -> void:
		score = s
		time = ms
		name = n

	func _to_string() -> String:
		return "Result { score: %f, time: %.2fs, name: %s }" % [score, time, name]


const POINT_CLOUDS: int = 16
const NUM_POINTS: int = 32
const MAX_INT_COORD: int = 1024
const LUT_SIZE: int = 64
const LUT_SCALE_FACTOR: float = float(MAX_INT_COORD) / float(LUT_SIZE)
