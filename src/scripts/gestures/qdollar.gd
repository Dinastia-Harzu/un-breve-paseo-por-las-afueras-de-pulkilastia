class_name QDollar
extends Node2D


var is_drawing := false
var finished_drawing := false
var current_line: Line2D = null


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if finished_drawing:
				Globals.remove_all_children(self)
				finished_drawing = false
			is_drawing = true
			current_line = Line2D.new()
			add_child(current_line)
			current_line.add_point(event.position)
		else:
			is_drawing = false
	elif event is InputEventScreenDrag and is_drawing:
		current_line.add_point(event.position)


func analyse() -> QDollarUtils.Result:
	var points: Array[QPoint] = []
	var strokes := get_children()
	if strokes.is_empty():
		return null
	for i in strokes.size():
		var stroke := strokes[i] as Line2D
		for p in stroke.points:
			points.append(QPoint.new(p, i + 1))
	var result := q_recogniser(points)
	print(result)
	finished_drawing = true
	return result


func clear() -> void:
	Globals.remove_all_children(self)


func q_recogniser(points: Array[QPoint]) -> QDollarUtils.Result:
	var time_spent = Time.get_unix_time_from_system()
	var index := -1
	var score := INF
	var candidate := PointCloud.new(points)
	var templates := QDollarUtils.templates
	for i in templates.size():
		var d := cloud_match(candidate, templates[i], score)
		if d < score:
			score = d
			index = i
	time_spent = Time.get_unix_time_from_system() - time_spent
	return QDollarUtils.Result.new(
		1. / score if score > 1. else 1.,
		time_spent,
		templates[index].gesture_name
	) if index != -1 else QDollarUtils.Result.new(0., time_spent)


func cloud_match(candidate: PointCloud, template: PointCloud, msf: float) -> float:
	var n := candidate.points.size()
	var step := floori(n ** 0.5)
	var lb1 := compute_lower_bound(candidate.points, template.points, step, template.lut)
	var lb2 := compute_lower_bound(template.points, candidate.points, step, candidate.lut)
	for i in range(0, n, step):
		var j := i / step
		if lb1[j] < msf:
			msf = minf(msf, cloud_distance(candidate.points, template.points, i, msf))
		if lb2[j] < msf:
			msf = minf(msf, cloud_distance(template.points, candidate.points, i, msf))
	return msf


func cloud_distance(
	points: Array[QPoint],
	template: Array[QPoint],
	start: int,
	msf: float
) -> float:
	var n := points.size()
	var unmatched := Globals.iota(template.size())
	var i := start
	var weight := n
	var sum := 0.
	while true:
		var index := -1
		var b := INF
		for j in unmatched.size():
			var d := points[i].distance_squared_to(template[unmatched[j]])
			if d < b:
				b = d
				index = j
		unmatched.remove_at(index)
		sum += weight * b
		if sum >= msf:
			return sum
		weight -= 1
		i = posmod(i + 1, n)
		if i == start:
			break
	return sum


func compute_lower_bound(
	points: Array[QPoint],
	template: Array[QPoint],
	step: int,
	some_lut: PackedInt32Array
) -> PackedFloat32Array:
	var n := points.size()
	var lb: PackedFloat32Array = []
	lb.resize(n / step + 1)
	var sat: PackedFloat32Array = []
	sat.resize(n)
	lb[0] = 0.
	for i in n:
		var xy := Vector2i((points[i].int_pos / QDollarUtils.LUT_SCALE_FACTOR).round())
		var d := points[i].distance_squared_to(template[some_lut[xy.x * QDollarUtils.LUT_SIZE + xy.y]])
		sat[i] = d if i == 0 else d + sat[i - 1]
		# sat[i] = d + sat.get(i - 1) # PackedFloat32Array.get devuelve 0.0 si el índice es negativo, así me ahorro una condición
		lb[0] += (n - i) * d
	for i in range(step, n, step):
		lb[i / step] = lb[0] + i * sat[n - 1] - n * sat[i - 1]
	return lb
